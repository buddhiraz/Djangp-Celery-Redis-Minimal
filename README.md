# Django, Celery, Redis - Async Task Management

A Dockerized Django application with Celery and Redis for handling asynchronous tasks. This setup allows for executing background jobs in Django using Celery workers, with Redis acting as a message broker.

## Features

- **Django**: A high-level Python web framework for building web applications.
- **Celery**: A distributed task queue system for handling asynchronous or scheduled tasks.
- **Redis**: An in-memory data store used as the message broker for Celery to manage task queues and results.
- **Docker & Docker Compose**: Containers for easy local setup and deployment.
- **AWS Deployment**: Deploy to AWS using ECS, Terraform, and GitHub Actions for automated CI/CD.

## Prerequisites

Make sure you have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://www.terraform.io/downloads)

## Local Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone git@github.com:buddhiraz/Djangp-Celery-Redis-Minimal.git
   cd Djangp-Celery-Redis-Minimal
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

## Deployment Instructions

### AWS Deployment Steps

The deployment uses **AWS ECS**, **Terraform**, and **GitHub Actions** for CI/CD:

1. **AWS Resources Setup**:
   - An ECS Cluster is created using Terraform.
   - The Django, Celery worker, and Redis containers are deployed using ECS tasks.
   - A CloudWatch Log Group is configured to capture logs from the containers.
   - Network resources like VPC, subnets, security groups, and an Internet Gateway are created using Terraform.

2. **GitHub Actions CI/CD**:
   - The GitHub Actions workflow handles the build and deployment process.
   - Docker images are built and pushed to Amazon ECR.
   - Terraform manages the infrastructure as code for consistent deployments.
   - The public IP of the ECS service is retrieved and used to update Django's `ALLOWED_HOSTS`.

### Deployment Steps

1. **Clone the Repository**:
   ```bash
   git clone git@github.com:buddhiraz/Djangp-Celery-Redis-Minimal.git
   cd Djangp-Celery-Redis-Minimal
   ```

2. **Deploy with GitHub Actions**:
   - Push changes to the `main` branch to trigger the GitHub Actions workflow for deployment.
   - The workflow will:
     1. Build Docker images.
     2. Push images to Amazon ECR.
     3. Deploy using Terraform to AWS ECS.

3. **Access the Application**:
   - After deployment, GitHub Actions will output the public IP of the ECS service.
   - Use the public IP to access the Django application.

## AWS, Terraform, GitHub Actions Workflow

```mermaid
graph TD
    A[GitHub Actions] --> B[Build Docker Images]
    B --> C[Push to Amazon ECR]
    C --> D[Terraform Deployment]

    subgraph Terraform Deployment
        D --> E[Provision ECS Cluster]
        D --> F[Deploy Containers to ECS]
        D --> G[Configure CloudWatch Logs]
        D --> H[Create VPC and Network Resources]
    end

    I[AWS Infrastructure] --> E
    I --> F
    I --> G
    I --> H
```

### AWS Resources Used

Below are the AWS resources that are managed by Terraform during deployment:

```mermaid
graph LR
    A[VPC] --> B[Public Subnets]
    A --> C[Internet Gateway]
    B --> D[Security Groups]
    D --> E[ECS Cluster]
    E --> F[ECS Task Definitions]
    F --> G[ECS Service]
    G --> H[Docker Containers]
    H --> I[CloudWatch Log Group]
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
├── terraform               # Terraform configuration
│   ├── main.tf             # Main Terraform file for AWS resources
│   ├── variables.tf        # Terraform variables
│   ├── outputs.tf          # Terraform output variables
│   └── container_definitions.json.tpl # ECS task definition template
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

- You can trigger a simple background task by calling a Celery task in your Django views or shell.
  
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


### **How is the Terraform files being used for deployment ?**
1. **`main.tf`**: 
   - The core Terraform file that defines infrastructure resources such as VPC, ECS Cluster, ECS Task Definitions, Security Groups, and ECS Services.
   - It also sets up data sources to fetch existing resources like IAM roles and ECR repositories.
   - Contains resource dependencies and outputs like ECS service and cluster information.

2. **`variables.tf`**:
   - Defines variables for the Terraform configuration. These variables can be set dynamically (e.g., Docker image URI).
   - Helps to manage reusable configurations like AWS region, ECS cluster names, and Docker image.

3. **`outputs.tf`**:
   - Defines outputs to retrieve information about the created resources, like ECS cluster IDs or ECR repository URLs.
   - These outputs can be referenced or used for debugging.

4. **`container_definitions.json.tpl`**:
   - A template file that contains the JSON definition for containers in the ECS task.
   - It uses Terraform variables for dynamic configuration (e.g., Docker image, environment variables).
   - Allows you to control how containers are configured without hardcoding values.

### **GitHub Actions Workflow Integration**
The GitHub Actions workflow is responsible for:
1. **Building** and **pushing** a Docker image to ECR.
2. **Setting up** AWS credentials and configuring Terraform to interact with AWS.
3. **Passing the Docker image URI** as a dynamic variable to Terraform.
4. **Running Terraform commands** to deploy or update the infrastructure.

### **Step-by-Step Workflow Breakdown**
1. **GitHub Actions Start**: On a push to the `main` branch, the GitHub Actions workflow is triggered.
   - It sets environment variables like AWS region, ECR repository, and Terraform backend configuration.

2. **Docker Build and Push**:
   - Docker builds an image from the repository and tags it using the Git commit SHA.
   - The image is pushed to ECR, and the image URI is captured as `IMAGE_URI`.

3. **Terraform Initialization**:
   - Terraform is initialized (`terraform init`) with backend configuration using S3 and DynamoDB for state management.
   - This ensures the state is maintained consistently across deployments.

4. **Terraform Planning**:
   - `terraform plan` is executed using the dynamically provided `IMAGE_URI`.
   - It generates a deployment plan to update ECS with the new Docker image.

5. **Terraform Apply**:
   - `terraform apply` deploys the planned infrastructure, updating the ECS Task Definition to use the new Docker image.
   - ECS automatically updates the service with the latest task definition.

### **Mermaid Chart: GitHub Actions to Terraform to ECS Workflow**

Here's the visualization of the workflow:

```mermaid
flowchart TD
    subgraph GitHub_Actions
        A1[GitHub Push to main] --> A2[Trigger GitHub Actions Workflow]
        A2 --> A3[Build Docker Image]
        A3 --> A4[Tag Docker Image with Commit SHA]
        A4 --> A5[Push Image to ECR]
        A5 --> A6[Set IMAGE_URI Environment Variable]
        A6 --> A7[Initialize Terraform]
        A7 --> A8[Run terraform plan with IMAGE_URI]
        A8 --> A9[Apply terraform plan]
    end

    subgraph Terraform
        T1[Initialize Backend with S3 and DynamoDB] --> T2[Load Variables from variables.tf]
        T2 --> T3[Use container_definitions.json.tpl]
        T3 --> T4[Create/Update ECS Task Definition]
        T4 --> T5[Update ECS Service]
        T5 --> T6[Output Information from outputs.tf]
    end

    subgraph AWS_ECS
        E1[ECR Stores Docker Image] --> E2[ECS Pulls Image from ECR]
        E2 --> E3[Run Containers using ECS Task Definition]
        E3 --> E4[ECS Service Updated with New Containers]
    end

    A9 --> T1
    T4 --> E2
```

### **Detailed Steps in the Chart**
1. **GitHub Actions**:
   - Triggers when there is a new commit to the `main` branch.
   - Handles Docker image build and push to ECR.
   - Sets the Docker image URI dynamically for Terraform deployment.

2. **Terraform Execution**:
   - Uses the `variables.tf` file to load parameters like region, ECR repository, and image.
   - References `container_definitions.json.tpl` to define container behavior dynamically.
   - Creates or updates the ECS task definition with the new Docker image.
   - Outputs key information for ECS service and cluster.

3. **AWS ECS**:
   - Pulls the updated Docker image from ECR using the new task definition.
   - Deploys the updated containers, ensuring the latest application version runs on ECS.

### **Key Takeaways**
- **Dynamic Docker Image Handling**: The GitHub Actions workflow ensures that every deployment uses the specific Docker image built from the latest commit, avoiding issues with using a static `latest` tag.
- **State Management**: Terraform maintains the state in S3, ensuring consistency in infrastructure deployments.
- **AWS Infrastructure**: The ECS service is updated automatically with the new Docker image using the revised task definition, minimizing manual updates.

