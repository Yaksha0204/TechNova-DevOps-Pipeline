# TechNova-DevOps-Pipeline
TechNova is a fully automated DevOps pipeline that handles everything — from code commit to deployment on AWS EC2 — without any human intervention.
This project represents a real-world enterprise-grade CI/CD pipeline, built exactly the way modern companies deploy apps.

🌟 Features

✔️ GitHub → Source Code Management
✔️ Jenkins → Full CI/CD automation
✔️ Docker → Containerized deployments
✔️ Terraform → Infrastructure as Code (IaC)
✔️ AWS EC2 → Production-like environment
✔️ Automated testing (pytest)
✔️ Zero manual deployment
✔️ Smooth rollback & reproducible builds

🏗️ Architecture Overview
     1️⃣ Developer Stage (Source Code Management)

Developer writes code or updates the application.

Code is committed and pushed to the GitHub repository.

GitHub stores the code in the main branch (or other branches).

2️⃣ GitHub → Jenkins Trigger (Webhook)

GitHub sends an automatic webhook notification to Jenkins whenever a new commit is pushed.

Jenkins receives the event and immediately triggers the CI/CD pipeline job.

3️⃣ CI Stage on Jenkins (Build & Test)
3.1 — Checkout Code

Jenkins pulls the latest source code from GitHub into its workspace.

3.2 — Install Dependencies

Jenkins installs the dependencies listed in requirements.txt.

3.3 — Run Unit Tests

Jenkins uses pytest to run test cases located inside the tests/ directory.

If any test fails → pipeline stops (fail-fast approach).

4️⃣ Build Stage (Containerization)
4.1 — Build Docker Image

Jenkins reads the Dockerfile and builds a new Docker image for the application.

The image is tagged using:

<dockerhub-user>/<repo-name>:<build-number>

4.2 — Security Scan (Optional)

Jenkins may run a vulnerability scan (e.g., Trivy) on the Docker image.

5️⃣ Push Stage (Artifact Storage)

Jenkins logs into Docker Hub using secure credentials.

The newly built Docker image is pushed to your Docker Hub repository.

Docker Hub now stores the latest version of the application image.

6️⃣ Infrastructure Stage (IaC via Terraform)

(This is done once or when infra changes)

Terraform provisions an AWS EC2 instance, Security Group, and necessary networking.

EC2 instance boots up and installs Docker using the user_data.sh script.

EC2 becomes ready to host the container.

7️⃣ Deployment Stage (Automated Delivery)
7.1 — Jenkins SSH to EC2

Jenkins uses an SSH key (stored in Jenkins Credentials Manager).

Jenkins connects securely to the EC2 instance.

7.2 — Run Deployment Script

Jenkins uploads and executes deploy.sh on EC2.

The script performs:

Stop existing container

Remove old container

Pull the new Docker image from Docker Hub

Start a fresh container using the new image

Expose app on port 80

8️⃣ Runtime Stage (Live Application)

The updated version of the application begins running inside a Docker container on EC2.

Users can access the app through:

http://<EC2-Public-IP>/

9️⃣ Monitoring & Feedback Loop

If monitoring is enabled (CloudWatch or Jenkins logs):

Logs are collected

Errors/metrics can trigger alerts

Developers get feedback → commit fixes → start the cycle again

⭐ Text Summary (One-Line Flow)

GitHub → Jenkins Webhook → Build → Test → Docker Image → Docker Hub → SSH Deploy to EC2 → New Container → Live Application
                       
📂 Project Structure
TechNova-DevOps-Pipeline/
│── app.py
│── Dockerfile
│── deploy.sh
│── requirements.txt
│── Jenkinsfile
│── .dockerignore
│── tests/
│    └── test_app.py
│── terraform/
│    ├── main.tf
│    ├── variables.tf
│    ├── provider.tf
│    ├── outputs.tf
│    └── user_data.sh
│── README.md
│── ARCHITECTURE.md
│── SETUP.md
└── .env.example

⚙️ How the Pipeline Works
1️⃣ Developer → GitHub

Code push triggers GitHub Webhook

Jenkins pipeline starts automatically

2️⃣ Jenkins CI Pipeline
Stage	Description
🔍 Checkout	Pulls latest code
🧪 Tests	Runs pytest
📦 Build	Creates Docker image
☁️ Push	Pushes image to Docker Hub
🚀 Deploy	SSH deploys updated container to EC2
3️⃣ Deployment on EC2

Container stops → latest image pulled → new container starts

App updated instantly, no downtime

🐳 Run Locally (Docker)
docker build -t technova:latest .
docker run -p 5000:5000 technova:latest

🧪 Run Unit Tests
pytest -q

☁️ Provision AWS EC2 With Terraform
cd terraform
terraform init
terraform apply


Outputs include:

Public IP

DNS hostname

🔑 Environment Variables

Your .env file (use .env.example):

FLASK_ENV=development
PORT=5000
DOCKERHUB_REPO=yaksha0204/technova-app

🔥 CI/CD Pipeline Tools Used
Tool	Purpose
GitHub	Version control + webhook
Jenkins	Automation engine
Docker	Build, package, run application
Terraform	Create AWS infrastructure
AWS EC2	Production deployment
pytest	Automated tests
