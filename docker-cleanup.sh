#!/bin/bash

echo "Removing all stopped containers..."
docker container prune -f

echo "Removing all unused images..."
docker image prune -a -f

echo "Removing all unused volumes..."
docker volume prune -f

echo "Removing all unused networks..."
docker network prune -f

echo "Performing a system-wide cleanup..."
docker system prune --volumes -f

echo "Cleanup complete."

echo "Current Docker disk usage:"
docker system df
