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
            sh "terraform apply -auto-approve"
            
        // Capture outputs
            sh 'terraform output -json > tf_output.json'
          }
        }
        // Read outputs into variables
        script {
          def tfOutput = readJSON file: "${env.TF_DIR}/tf_output.json"
          env.EC2_ID = tfOutput.ec2_id.value
          env.EC2_PUBLIC_IP = tfOutput.ec2_public_ip.value
          echo "EC2 ID: ${env.EC2_ID}"
          echo "EC2 Public IP: ${env.EC2_PUBLIC_IP}"
        }
      }
    }
    stage('Save TFState to Shared Folder') {
      steps {
        sh 'cp terraform/* /var/jenkins_shared/tfstate/'
      }
    }

  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}
