pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'  
        ECR_REPO_URI = '627562689753.dkr.ecr.eu-north-1.amazonaws.com/node'
        ECS_CLUSTER = 'node_cluster'
        ECS_SERVICE = 'node_service'
        
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-username/your-repository.git'
            }
        }
        }

     
        stage("Docker Build & Push to ECR") {
                    steps {
                        script {
                            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                                sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL"
                                sh " docker build -t node:latest   ."
                                sh "docker tag node:latest $ECR_URL:${env.BUILD_NUMBER}"

                                sh "docker push $ECR_URL:${env.BUILD_NUMBER}"
                            }
                        }
                    }
                }


        stage('Deploy to ECS') {
            steps {
                script {
                    sh """
                    aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
