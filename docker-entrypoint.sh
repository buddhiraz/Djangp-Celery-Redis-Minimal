#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Wait for Redis to be available
echo "Waiting for Redis to be available..."
until nc -z redis 6379; do
    echo "Redis is unavailable - sleeping"
    sleep 1
done
echo "Redis is up - continuing"

# Run Django migrations
echo "Running migrations..."
python manage.py migrate

# Start the Django development server
echo "Starting Django server..."
python manage.py runserver 0.0.0.0:8000
