pipeline{
    agent any
    tools {
        maven 'maven-3.9.9'
        jdk   'jdk-21'
    }
    stages{
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
            }
        }
        stage('Build Docker Image from Artifact') {
            steps{
                echo "Building docker image"
                sh "docker build -t simple-java-maven-app-demo ."
    
            }
        }
        stage('Push Image to docker hub') {
            steps{
                echo "Pushing docker image to docker hub"
                withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                    sh "docker login -u ${docker_user} -p ${docker_pass}"
                }  
                sh "docker tab simple-java-maven-app sundayfagbuaro/simple-java-maven-app-demo:v1"
                sh "docker push sundayfagbuaro/simple-java-maven-app-demo:v1"

            }
        }
    }
        
}

   