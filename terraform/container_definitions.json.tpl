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
    "cpu": 256,
    "memory": 512,
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
    "image": "${redis_image}",
    "essential": true,
    "cpu": 128,
    "memory": 256,
    "portMappings": [
      {
        "containerPort": 6379,
        "hostPort": 6379,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${ecs_service_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "redis"
      }
    }
  },
  {
    "name": "celery",
    "image": "${image}",
    "essential": false,
    "cpu": 64,
    "memory": 128,
    "environment": [
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
        "awslogs-stream-prefix": "celery"
      }
    }
  },
  {
    "name": "celery-beat",
    "image": "${image}",
    "essential": false,
    "cpu": 64,
    "memory": 128,
    "environment": [
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
        "awslogs-stream-prefix": "celery-beat"
      }
    }
  }
]
