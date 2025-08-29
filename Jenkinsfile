pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['init-plan', 'apply', 'destroy'], description: 'Terraform action to run')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/balajivb25/terraform-projects.git'
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    dir('terraform') {
                        if (params.ACTION == 'init-plan') {
                            sh 'terraform init -input=false'
                            sh 'terraform plan -out=tfplan'
                        } /*else if (params.ACTION == 'apply') {
                            sh 'terraform apply -auto-approve tfplan'
                        } else if (params.ACTION == 'destroy') {
                            sh 'terraform destroy -auto-approve'
                        }*/
                        else if (params.ACTION == 'apply') {
                            sh 'terraform plan -out=tfplan'
                        } else if (params.ACTION == 'destroy') {
                            sh 'terraform plan -out=tfplan'
                        }
                    }
                }
            }
        }
    }
}
