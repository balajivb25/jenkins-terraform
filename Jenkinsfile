pipeline {
  agent any

  environment {
    TF_DIR = "terraform"
    AWS_REGION = "ap-south-1"
    RUN_APPLY = "true"
  }

  tools {
    git 'Default'
  }

  triggers {
    githubPush()   // Automatically runs on GitHub push
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        dir(env.TF_DIR) {
          withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
            sh 'terraform init -input=false'
          }
        }
      }
    }
    stage('Terraform Plan') {
      steps {
        dir(env.TF_DIR) {
          withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
            sh 'terraform plan -out=tfplan'
          }
        }
      }
      post {
        success {
          archiveArtifacts artifacts: "${env.TF_DIR}/tfplan", fingerprint: true
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        input "Approve Terraform Apply?"
        dir(env.TF_DIR) {
          withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
            sh 'terraform apply -auto-approve tfplan'
          }
        }
      }
    }
    stage('Terraform Destroy') {
      steps {
        input "Approve Terraform Destroy?"
        dir(env.TF_DIR) {
          withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
            sh 'terraform destroy -auto-approve -lock=false'
          }
        }
      }
    }
  }

  post {
    always {
      echo "✅ Pipeline finished"
    }
    failure {
      echo "❌ Pipeline failed. Check logs in Jenkins console output."
    }
  }
}
