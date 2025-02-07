#!/usr/bin/env bash
set -e

PROJECT_FOLDER="/srv/miniflux/"

mkdir -p ${PROJECT_FOLDER}

cat <<EOF > ${PROJECT_FOLDER}docker-compose.yaml
services:
  postgres:
    image: postgres:17
    restart: unless-stopped
    environment:
      POSTGRES_DB: miniflux
      POSTGRES_USER: miniflux
      POSTGRES_PASSWORD: {{ .Env.MINIFLUX_POSTGRES_PASSWORD }}
    volumes:
      - postgres:/var/lib/postgresql/data/
    healthcheck:
      test: ['CMD', 'pg_isready']
      interval: 10s
      start_period: 30s

  miniflux:
    image: miniflux/miniflux:2.2.5
    ports:
    - 8080:8080
    environment:
      DATABASE_URL: postgres://miniflux:{{ .Env.MINIFLUX_POSTGRES_PASSWORD }}@postgres/miniflux?sslmode=disable
      RUN_MIGRATIONS: 1
      CREATE_ADMIN: 1
      ADMIN_USERNAME: johndoe
      ADMIN_PASSWORD: {{ .Env.MINIFLUX_ADMIN_PASSWORD }}
    healthcheck:
      test: ["CMD", "/usr/bin/miniflux", "-healthcheck", "auto"]
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  postgres:
     name: miniflux_postgres

EOF

cd ${PROJECT_FOLDER}

docker compose pull
docker compose up -d --remove-orphans --wait
