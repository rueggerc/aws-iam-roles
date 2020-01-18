pipeline {
    agent any
    environment {
        JOB_NAME = "Build AWS IAM Roles"
    }
    stages {
        stage ('Preconditions') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage ('Build Master Branch') {
            when { 
                branch 'master'
            }
            steps {
                echo "Building from master Branch"
            }
        }
        stage ('Build Feature Branch') {
            when { 
                not { 
                  branch 'master'
                }
            }
            steps {
                echo 'Building non-master branch'
            }
        }
        stage ('Deploy Application') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script {
                        def tfHome = tool name: 'terraform-0.12.10'
                        env.PATH = "${tfHome}:${env.PATH}"
                    }
                    // Run Terraform
                    dir("terraform") {
                        echo 'Terraform Stuff'
                        sh 'ls -l'
                        sh 'terraform --version'
                        sh 'terraform init'
                        sh 'terraform plan -var-file="vars/dev-us-east-1.tfvars" -out=plan'
                        sh 'terraform apply plan'
                    }
                }
 
            }
        }
    }
}
