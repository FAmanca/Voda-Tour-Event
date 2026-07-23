#!/bin/bash

# Perintah ini dijalankan dari folder root proyek Voda Tour & Event.
# Script ini akan membaca file YAML skema dan menerapkannya ke container Postgres di produksi.

echo "⏳ Menerapkan skema Directus ke VPS Produksi..."

# Di VPS produksi, nama containernya adalah 'voda-directus-prod' (sesuai deploy.yml).
# Jika Anda menjalankan perintah ini di LOKAL untuk testing, ganti 'voda-directus-prod' menjadi 'voda-directus'.

docker exec -i voda-directus-prod node cli.js schema apply - < infrastructure/directus-schema.yaml

echo "✅ Selesai!"
