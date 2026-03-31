pipeline {
    agent { label 'java' }

    environment {
        image_name = 'spring-petclinic'
        tag_name = "${BUILD_NUMBER}"
        ecr_repo = '003364515214.dkr.ecr.ap-south-1.amazonaws.com/spring-petclinic'
        region = 'ap-south-1'
    }

    stages {

        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/mud1221/spring-petclinic-.git', branch: 'main'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${image_name}:${tag_name} ."
            }
        }
        stage('Trivy Scan') {
            steps {
         sh '''trivy image spring-petclinic:${BUILD_NUMBER} || true'''
            }
       }

        stage('Push to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_repo}
                docker tag ${image_name}:${tag_name} ${ecr_repo}:${tag_name}
                docker push ${ecr_repo}:${tag_name}
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }
}