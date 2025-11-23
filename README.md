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
              ┌────────────┐          
     Code     │  GitHub    │─────┐     
    Pushes    └────────────┘     │     
                                  ▼
                           ┌────────────┐
                           │  Jenkins   │
                           └────────────┘
          ┌───────────────Pipeline Stages───────────────┐
          │   1. Checkout                                │
          │   2. Install dependencies                    │
          │   3. Unit tests                              │
          │   4. Docker image build                      │
          │   5. Push to Docker Hub                      │
          │   6. Deploy to AWS EC2                       │
          └──────────────────────────────────────────────┘
                                  ▼
                        ┌────────────────┐
                        │ Docker Hub Repo│
                        └────────────────┘
                                  ▼
                        ┌────────────────┐
                        │ AWS EC2 Server │
                        │ (Docker Engine)│
                        └────────────────┘
                                  ▼
                         🔥 Live Application

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
