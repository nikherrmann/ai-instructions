# Docker Instructions

## Building Images

```bash
# Build with tag
docker build -t myapp:latest .

# Build with build args
docker build --build-arg ENV=production -t myapp:prod .
```

## Running Containers

```bash
# Run with port mapping
docker run -p 8080:8080 myapp

# Run with environment variables
docker run -e DATABASE_URL=postgres://... myapp

# Run in background
docker run -d --name myapp myapp:latest
```

## Docker Compose

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f

# Rebuild and restart
docker compose up -d --build

# Stop and remove
docker compose down
```

## Cleanup

```bash
# Remove unused images
docker image prune -a

# Remove all stopped containers
docker container prune

# Nuclear option - remove everything
docker system prune -a
```
