
# Django, Celery, Redis - Async Task Management

A Dockerized Django application with Celery and Redis for handling asynchronous tasks. This setup allows for executing background jobs in Django using Celery workers, with Redis acting as a message broker.

## Features

- **Django**: A high-level Python web framework for building web applications.
- **Celery**: A distributed task queue system for handling asynchronous or scheduled tasks.
- **Redis**: An in-memory data store used as the message broker for Celery to manage task queues and results.
- **Docker & Docker Compose**: Containers for easy local setup and deployment.

## Prerequisites

Make sure you have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Local Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Build and Start the Containers**:
   Use Docker Compose to build and run the Django app, Redis, Celery worker, and Celery beat:
   ```bash
   docker-compose up --build
   ```

   This will:
   - Build the Docker containers for Django, Celery worker, and Celery beat.
   - Pull the Redis image from Docker Hub.
   - Start the Django development server at `http://localhost:8000`.

3. **Access the Application**:
   - **Django**: Visit `http://localhost:8000` to access the web application.
   - **Celery Worker Logs**: Logs for Celery workers will be shown in the terminal where Docker Compose is running.
   - **Redis**: Redis is running in the background on `localhost:6379`.

4. **Stopping the Application**:
   To stop the application and remove the containers, use:
   ```bash
   docker-compose down
   ```

## Project Structure

```
.
├── celery_example          # Main Django project
│   ├── celery.py           # Celery configuration
│   ├── settings.py         # Django settings
│   └── wsgi.py             # Entry point for WSGI servers
├── myapp                   # Django app
│   ├── tasks.py            # Celery tasks
│   └── views.py            # Django views
├── Dockerfile              # Dockerfile for building Django app
├── docker-compose.yml      # Docker Compose setup for Django, Redis, Celery
├── requirements.txt        # Python dependencies
└── README.md               # Project documentation
```

## How It Works

This project uses **Django**, **Celery**, and **Redis** to enable asynchronous task execution. Below is a technical explanation of how these components work together:

### 1. Django (Web Framework)
- **Django** handles the web application's HTTP requests and user interactions.
- When a task (such as sending an email or processing large data) is triggered in Django, instead of executing the task immediately, it is delegated to **Celery**.

### 2. Celery (Task Queue)
- **Celery** is used to offload long-running tasks (like sending emails, image processing, etc.) to background workers.
- Celery runs in the background and pulls tasks from a queue (provided by Redis).
- In this project, we have:
  - **Celery worker**: Processes asynchronous tasks.
  - **Celery beat**: A scheduler that runs periodic tasks (if you have scheduled tasks defined).

### 3. Redis (Message Broker)
- **Redis** is used as the message broker that Celery relies on to queue tasks.
- When Django triggers a task, the task details are pushed to Redis. The Celery worker pulls these tasks from Redis, executes them, and returns the results (if needed).
  
The process looks like this:
1. **Django View**: A user makes a request that triggers a long-running task.
2. **Task Queued**: The task is pushed to Redis by Django via Celery.
3. **Celery Worker**: The worker picks up the task from Redis, processes it in the background, and optionally stores the result back in Redis.

This setup allows the Django app to remain responsive to users, even when handling time-consuming tasks.

## Running Celery Tasks

- You can trigger a background task by calling a Celery task in your Django views or shell.
  
  For example, if you have a task in `tasks.py` like this:

  ```python
  from celery import shared_task
  import time

  @shared_task
  def add(x, y):
      time.sleep(5)  # Simulating a long-running task
      return x + y
  ```

  You can trigger the task in a Django view:

  ```python
  from .tasks import add

  def trigger_task(request):
      result = add.delay(4, 6)  # Task is processed in the background
      return JsonResponse({'task_id': result.id})
  ```

  The task will be processed by Celery in the background, allowing your Django app to respond immediately to the user.

## Troubleshooting

- **Cannot connect to Redis**: Make sure Redis is running and accessible on `localhost:6379`. Check your `docker-compose.yml` for the correct configuration.
- **Celery Worker is not processing tasks**: Ensure that the Celery worker is running (`docker-compose up` should start it). Check the logs for any errors.
- **Django errors**: Check the Django logs or use the Django debug toolbar to inspect any issues.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This README provides clear instructions on how to run the application locally with Docker Compose and explains how Django, Celery, and Redis work together to handle asynchronous tasks. Let me know if you need any more details!