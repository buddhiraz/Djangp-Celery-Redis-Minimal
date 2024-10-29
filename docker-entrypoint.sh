#!/bin/bash

# Start Django server
python manage.py runserver 0.0.0.0:8000 &

# Start Celery Worker
celery -A celery_example worker --loglevel=info &

# Start Celery Beat
celery -A celery_example beat --loglevel=info &

# Wait for any of the background processes to exit
wait -n
