# ==============================================================================
# Voda Tour & Event - Astro Web App Dockerfile
# ==============================================================================

# Stage 1: Build
FROM node:22-alpine AS builder

# Enable pnpm
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

# Copy files
COPY apps/web/package.json apps/web/pnpm-lock.yaml* apps/web/pnpm-workspace.yaml* ./

# Install dependencies using frozen lockfile
RUN pnpm install --frozen-lockfile

# Copy the rest of the application
COPY apps/web ./

# Build the Astro app
ARG DIRECTUS_URL=http://directus:8055
ENV DIRECTUS_URL=$DIRECTUS_URL
ARG PUBLIC_DIRECTUS_URL=http://api.vodatrip.id
ENV PUBLIC_DIRECTUS_URL=$PUBLIC_DIRECTUS_URL
RUN pnpm run build

# Stage 2: Production Runner
FROM node:22-alpine AS runner

WORKDIR /app

# Copy built assets and dependencies from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Expose port (Internal to docker network, Nginx will reverse proxy to this)
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321

# Start the Node.js server (Astro SSR)
CMD ["node", "./dist/server/entry.mjs"]
