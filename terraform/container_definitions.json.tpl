[
  {
    "name": "${container_name}",
    "image": "${image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${container_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "DJANGO_SETTINGS_MODULE",
        "value": "celery_example.settings"
      },
      {
        "name": "CELERY_BROKER_URL",
        "value": "redis://redis:6379/0"
      },
      {
        "name": "CELERY_RESULT_BACKEND",
        "value": "redis://redis:6379/0"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${ecs_service_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${container_name}"
      }
    },
    "dependsOn": [
      {
        "containerName": "redis",
        "condition": "START"
      }
    ]
  },
  {
    "name": "redis",
    "image": "redis:6.2",
    "essential": false,
    "memory": 256,
    "cpu": 256,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/django-celery-redis-backend-service",
        "awslogs-create-group": "true",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "django"
      }
    }
  }
]
