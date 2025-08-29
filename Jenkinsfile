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

    stage('Terraform Init & Plan') {
      steps {
        withAWS(credentials: 'aws-creds', region: 'ap-south-1'){
          dir(env.TF_DIR) {
            sh "terraform init -input=false"
            sh "terraform plan -out=tfplan"
          }
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}
