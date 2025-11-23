pipeline {
  agent any

  environment {
    // Replace these with Jenkins credential IDs / env variables
    DOCKERHUB_CREDENTIALS = 'dockerhub-creds'   // Jenkins username/password ID
    DOCKERHUB_REPO = 'yaksha0204/technova-app'  // your Docker Hub repo
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    SSH_CREDENTIALS_ID = 'ec2-ssh-cred'         // Jenkins credential ID for SSH private key
    DEPLOY_USER = 'ec2-user'                   // ec2 user (ubuntu/ec2-user)
    DEPLOY_HOST = ''                            // Fill later or use env var
    DEPLOY_PORT = '22'
    // Optional: set to 'true' to run trivy scan stage when plugin available
    ENABLE_IMAGE_SCAN = 'false'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'python3 -m pip install -r requirements.txt'
        sh 'pytest -q || { echo "Tests failed"; exit 1; }'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} -f Dockerfile ."
        }
      }
    }

    stage('Image Scan (optional)') {
      when { expression { env.ENABLE_IMAGE_SCAN == 'true' } }
      steps {
        // Assumes trivy installed on Jenkins agent
        sh "trivy image --exit-code 1 ${DOCKERHUB_REPO}:${IMAGE_TAG} || true"
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh "docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}"
        }
      }
    }

    stage('Deploy to EC2 (via SSH)') {
      steps {
        script {
          // Copy a deploy script and run it remotely
          sshagent (credentials: ["${SSH_CREDENTIALS_ID}"]) {
            sh """
              scp -P ${DEPLOY_PORT} deploy.sh ${DEPLOY_USER}@${DEPLOY_HOST}:/home/${DEPLOY_USER}/deploy.sh
              ssh -p ${DEPLOY_PORT} ${DEPLOY_USER}@${DEPLOY_HOST} 'chmod +x ~/deploy.sh && ~/deploy.sh ${DOCKERHUB_REPO} ${IMAGE_TAG}'
            """
          }
        }
      }
    }
  }

  post {
    always {
      sh 'docker image prune -f || true'
    }
    failure {
      echo "Build failed. Check console output for details."
    }
  }
}
