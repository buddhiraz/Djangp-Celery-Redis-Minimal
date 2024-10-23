#!/bin/bash

if [ "$1" = "celery" ]; then
    # Run Celery worker
    celery -A celery_example worker --loglevel=info
elif [ "$1" = "celery-beat" ]; then
    # Run Celery beat
    celery -A celery_example beat --loglevel=info
else
    # Run Django development server
    python manage.py migrate
    python manage.py runserver 0.0.0.0:8000
fi
