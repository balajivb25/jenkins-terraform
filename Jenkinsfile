pipeline {
  agent any
  parameters {
        choice(
            name: 'ACTION',
            choices: ['PLAN', 'APPLY', 'DESTROY'],
            description: 'Choose Terraform action to perform'
        )
    }
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
      when { expression { return params.ACTION in ['PLAN', 'APPLY', 'DESTROY'] } }
      steps {
        dir(env.TF_DIR) {
          withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
            sh 'terraform init -input=false'
          }
        }
      }
    }
    stage('Terraform Validate & Format') {
      when { expression { return params.ACTION in ['PLAN', 'APPLY', 'DESTROY'] } }
      steps {
        dir(env.TF_DIR) {
          withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
            sh '''
              terraform fmt -check
              terraform validate
            '''
          }
        }
      }
    }
    stage('Terraform Plan') {
      when { expression { return params.ACTION in ['PLAN', 'APPLY'] } }
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
      when { expression { params.ACTION == 'APPLY' } }
      steps {
        try {
          input "Approve Terraform Apply?"
          dir(env.TF_DIR) {
            withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
              if (!fileExists('tfplan')) {
                echo "tfplan not found, regenerating..."
                sh 'terraform plan -out=tfplan'
              }
              sh 'terraform apply -auto-approve tfplan'
              }
          }
        } catch (Exception e) {
            echo "Terraform apply failed: ${e}"
            currentBuild.result = 'FAILURE'
            error("Stopping pipeline due to Terraform failure")
        }
      }
    }
    stage('Terraform Destroy') {
      when { expression { params.ACTION == 'DESTROY' } }
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
