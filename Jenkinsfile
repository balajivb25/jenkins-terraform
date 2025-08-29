pipeline {
  agent any

  environment {
    TF_DIR = "terraform"
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
          sh "terraform plan -out=tfplan"
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finished with ACTION=INIT"
    }
  }
}
