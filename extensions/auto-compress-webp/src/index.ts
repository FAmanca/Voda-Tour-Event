import { defineHook } from '@directus/extensions-sdk';
import fs from 'fs';
import path from 'path';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);

function loadSharp() {
	// 1. Try standard require
	try {
		return require('sharp');
	} catch (e) {}

	// 2. Try dynamic search in directus container's .pnpm directory
	try {
		const pnpmDir = '/directus/node_modules/.pnpm';
		if (fs.existsSync(pnpmDir)) {
			const files = fs.readdirSync(pnpmDir);
			const sharpFolder = files.find(f => f.startsWith('sharp@'));
			if (sharpFolder) {
				const sharpPath = path.join(pnpmDir, sharpFolder, 'node_modules', 'sharp');
				if (fs.existsSync(sharpPath)) {
					console.log(`[AutoCompressWebP] Resolved sharp dynamically from: ${sharpPath}`);
					return require(sharpPath);
				}
			}
		}
	} catch (e) {
		console.error(`[AutoCompressWebP] Failed to load sharp from pnpm store:`, e);
	}

	// 3. Hardcoded fallback path
	try {
		return require('/directus/node_modules/.pnpm/sharp@0.34.5/node_modules/sharp');
	} catch (e) {}

	throw new Error('[AutoCompressWebP] Sharp library could not be loaded inside Directus container');
}

const sharp = loadSharp();

export default defineHook(({ action }) => {
	action('files.upload', async ({ payload, key }, { database }) => {
		const mimeType = payload.type;
		
		// Only process images (exclude SVGs and GIFs)
		if (
			mimeType &&
			mimeType.startsWith('image/') &&
			mimeType !== 'image/svg+xml' &&
			mimeType !== 'image/gif'
		) {
			// Rule: Skip images that are already small (under 120 KB) to prevent quality loss
			if (payload.filesize && payload.filesize <= 120 * 1024) {
				console.log(`[AutoCompressWebP] Skipping file ${payload.filename_download} (${(payload.filesize / 1024).toFixed(1)} KB) - File is already small.`);
				return;
			}

			const uploadDir = process.env.STORAGE_LOCAL_ROOT || '/directus/uploads';
			const originalFilePath = path.join(uploadDir, payload.filename_disk);

			if (!fs.existsSync(originalFilePath)) {
				console.error(`[AutoCompressWebP] File not found on disk: ${originalFilePath}`);
				return;
			}

			const newFilenameDisk = `${key}.webp`;
			const targetFilePath = path.join(uploadDir, newFilenameDisk);

			try {
				console.log(`[AutoCompressWebP] Compressing ${payload.filename_download} (${(payload.filesize / 1024).toFixed(1)} KB) to WebP...`);

				const sharpInstance = sharp(originalFilePath);
				const metadata = await sharpInstance.metadata();

				// Configure compression and resizing (limit max width to 1200px for web performance)
				let processedImage = sharpInstance.webp({ quality: 75 });
				if (metadata.width && metadata.width > 1200) {
					processedImage = processedImage.resize({ width: 1200, withoutEnlargement: true });
				}

				// Save compressed WebP to disk
				await processedImage.toFile(targetFilePath);

				const stats = fs.statSync(targetFilePath);
				const newFilesize = stats.size;

				// Retrieve final dimensions
				const finalSharp = sharp(targetFilePath);
				const finalMetadata = await finalSharp.metadata();

				console.log(`[AutoCompressWebP] Done! Compressed from ${(payload.filesize / 1024).toFixed(1)} KB to ${(newFilesize / 1024).toFixed(1)} KB`);

				// Delete original file from disk if it was replaced
				if (originalFilePath !== targetFilePath && fs.existsSync(originalFilePath)) {
					fs.unlinkSync(originalFilePath);
				}

				// Update file details in directus_files database
				await database('directus_files')
					.where({ id: key })
					.update({
						type: 'image/webp',
						filesize: newFilesize,
						filename_disk: newFilenameDisk,
						width: finalMetadata.width || metadata.width,
						height: finalMetadata.height || metadata.height
					});

				console.log(`[AutoCompressWebP] Database record updated for file ID ${key}`);
			} catch (error) {
				console.error(`[AutoCompressWebP] Error processing image ${key}:`, error);
			}
		}
	});
});
