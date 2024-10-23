# Use official Python image as a base
FROM python:3.10

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . .

# Set environment variables for Django
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Ensure Celery commands are available
# Set up a script to run either the Django app, Celery worker, or Celery beat
COPY ./docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Expose the port the app runs on (Django server)
EXPOSE 8000

# Default entry point is the script that will choose the command to run (Django, Celery worker, or beat)
ENTRYPOINT ["/app/docker-entrypoint.sh"]
