pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['init', 'plan', 'apply', 'destroy'], description: 'Terraform action to perform')
  }

  environment {
    TF_DIR = "terraform"
    TFSTATE_BACKUP = "terraform.tfstate.backup"
    ARTIFACTS_DIR = "artifacts"   // folder inside Jenkins workspace for state backups
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      when { anyOf { environment name: 'ACTION', value: 'init'; environment name: 'ACTION', value: 'plan'; environment name: 'ACTION', value: 'apply'; environment name: 'ACTION', value: 'destroy' } }
      steps {
        dir(env.TF_DIR) {
          sh "terraform init -input=false"
        }
      }
    }

    stage('Terraform Plan') {
      when { environment name: 'ACTION', value: 'plan' }
      steps {
        dir(env.TF_DIR) {
          sh "terraform plan -out=tfplan"
        }
      }
    }

    stage('Terraform Apply') {
      when { environment name: 'ACTION', value: 'apply' }
      steps {
        dir(env.TF_DIR) {
          sh "terraform apply -auto-approve tfplan || terraform apply -auto-approve"

          // backup tfstate to artifacts
          sh """
            mkdir -p ../${ARTIFACTS_DIR}
            cp terraform.tfstate ../${ARTIFACTS_DIR}/terraform.tfstate.\$(date +%F-%H-%M-%S)
          """
          archiveArtifacts artifacts: "${ARTIFACTS_DIR}/terraform.tfstate.*", fingerprint: true
        }
      }
    }

    stage('Terraform Destroy') {
      when { environment name: 'ACTION', value: 'destroy' }
      steps {
        dir(env.TF_DIR) {
          // restore last saved tfstate
          sh """
            if [ -f ../${ARTIFACTS_DIR}/terraform.tfstate.* ]; then
              latest=\$(ls -t ../${ARTIFACTS_DIR}/terraform.tfstate.* | head -1)
              cp \$latest terraform.tfstate
            fi
          """
          sh "terraform destroy -auto-approve"
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finished with ACTION=${params.ACTION}"
    }
  }
}
