pipeline {
    agent { label 'SPC' }

    parameters {
        choice(name: 'goals', choices: ['package', 'clean install', 'verify'], description: 'Pick something')
    }
    environment {
        image_name = 'spc'
        tag_name = '1.0'
    }



    stages {

        stage('git checkout') {
            steps {
                git url: 'https://github.com/longflewtinku/spring-petclinic.git', branch: 'main'
            }
        }

        // stage('build and scan') {
        //     steps {
        //         withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
        //             withSonarQubeEnv('SONAR') {
        //                 sh """
        //                 mvn ${params.goals} sonar:sonar \
        //                 -Dsonar.projectKey=longflewtinku_spring-petclinic \
        //                 -Dsonar.organization=longflewtinku \
        //                 -Dsonar.host.url=https://sonarcloud.io/ \
        //                 -Dsonar.login=$SONAR_TOKEN
        //                 """
        //             }
        //         }
        //     }
        // }

        // stage('Binary file store') {
        //     steps {
        //         rtUpload(
        //             serverId: 'JFROG',
        //             spec: '''{
        //                 "files": [
        //                     {
        //                         "pattern": "target/*.jar",
        //                         "target": "spcjava-spc/"
        //                     }
        //                 ]
        //             }'''
        //         )

        //         rtPublishBuildInfo(serverId: 'JFROG')
        //     }
        // }

       
        stage('Image push to the ECR and pulling from dockerhub') {
            steps {
                sh """docker image pull nginx:1.29 && \
                      aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 003364515214.dkr.ecr.ap-south-1.amazonaws.com && \
                      docker tag ${image_name}:${tag_name} 003364515214.dkr.ecr.ap-south-1.amazonaws.com/dev/nginx:latest && \
                      docker images && \
                      docker push 003364515214.dkr.ecr.ap-south-1.amazonaws.com/dev/nginx:latest"""
            }
        }
    }
}