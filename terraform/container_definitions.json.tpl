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
        "awslogs-group": "/ecs/${container_name}",
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
    "image": "${redis_image}",
    "essential": false,
    "memory": 256,
    "cpu": 256,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/redis",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "redis"
      }
    }
  }
]
