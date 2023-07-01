#!/usr/bin/env bash
set -e

PROJECT_FOLDER="/srv/miniflux/"

mkdir -p ${PROJECT_FOLDER}

cat <<EOF > ${PROJECT_FOLDER}docker-compose.yaml
version: '3.8'
services:
  miniflux:
    image: miniflux/miniflux:2.0.45
    ports:
    - 8080:8080
    environment:
      DATABASE_URL: postgres://miniflux:secret@postgres/miniflux?sslmode=disable
      RUN_MIGRATIONS: 1
      CREATE_ADMIN: 1
      ADMIN_USERNAME: johndoe
      ADMIN_PASSWORD: password
    depends_on:
      postgres:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "/usr/bin/miniflux", "-healthcheck", "auto"]

  postgres:
    image: postgres:15
    restart: unless-stopped
    environment:
      POSTGRES_DB: miniflux
      POSTGRES_USER: miniflux
      POSTGRES_PASSWORD: secret
    volumes:
      - /var/lib/miniflux/postgres/:/var/lib/postgresql/data
    healthcheck:
      test: ['CMD', 'pg_isready']
      interval: 10s
      start_period: 30s

EOF

cd ${PROJECT_FOLDER}

docker compose pull
docker compose up -d miniflux --wait
