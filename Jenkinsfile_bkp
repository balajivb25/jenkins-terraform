pipeline {
  agent any
  options { skipDefaultCheckout() } // don't auto-checkout pipeline repo
  parameters {
    choice(name: 'ACTION', choices: ['init-plan', 'apply', 'destroy'],
           description: 'What to do when started manually')
    /*string(name: 'TF_REPO_URL', defaultValue: 'https://github.com/your-org/terraform-infra-repo.git',
           description: 'Terraform repo to operate on')
    string(name: 'TF_BRANCH', defaultValue: 'main', description: 'Branch to use')
    string(name: 'TF_DIR', defaultValue: '.', description: 'Working dir inside Terraform repo')
    booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Auto-approve apply/destroy')*/
  }

  /*environment {
    GIT_CREDS = 'github-cred'  // your GitHub cred ID
    AWS_CREDS = 'aws-creds'    // example cloud cred (if needed)
  }*/

  stages {
    /*stage('Resolve inputs') {
      steps {
        script {
          // Values possibly supplied by webhook via Generic Webhook Trigger
          // REF like "refs/heads/main" → branch is last token
          def refFromHook   = env.REF ?: ''
          def branchFromRef = refFromHook ? refFromHook.tokenize('/').last() : null

          env.EFF_REPO   = env.TF_REPO_URL ?: params.TF_REPO_URL
          env.EFF_BRANCH = branchFromRef ?: (env.TF_BRANCH ?: params.TF_BRANCH)
          env.EFF_DIR    = env.TF_DIR ?: params.TF_DIR
          env.EFF_ACTION = env.TF_ACTION ?: params.TF_ACTION
          env.EFF_COMMIT = env.TF_COMMIT ?: ''  // head sha from webhook

          echo ">> Using Repo=${env.EFF_REPO}"
          echo ">> Branch=${env.EFF_BRANCH} Commit=${env.EFF_COMMIT}"
          echo ">> Dir=${env.EFF_DIR} Action=${env.EFF_ACTION}"
        }
      }
    }

    stage('Checkout Terraform repo') {
      steps {
        script {
          // Use Jenkins 'git' step for branches; if a specific COMMIT is provided,
          // checkout branch first, then hard-checkout the commit.
          // (git step supports branch, not bare SHA directly.) :contentReference[oaicite:7]{index=7}
          if (env.EFF_COMMIT?.trim()) {
            checkout([
              $class: 'GitSCM',
              branches: [[name: env.EFF_BRANCH]],
              userRemoteConfigs: [[url: env.EFF_REPO, credentialsId: env.GIT_CREDS]]
            ])
            sh "git checkout -q ${env.EFF_COMMIT}"
          } else {
            git branch: env.EFF_BRANCH, url: env.EFF_REPO, credentialsId: env.GIT_CREDS
          }
        }
      }
    }
*/
    stage('Checkout') {
        steps {
            git branch: 'main', url: 'https://github.com/balajivb25/jenkins-terraform.git'
           }
    }
    stage('Show Terraform version') {
      steps { sh 'terraform version' }
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
