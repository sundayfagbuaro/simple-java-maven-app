pipeline {
    agent any
    tools { 
      maven 'maven-3.9.9' 
      jdk 'jdk-21' 
    }
    stages {
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

        stage('Build Docker Image') {
            steps {
                echo "Building the image"
                sh 'docker build -t sundayfagbuaro/simple-java-maven-app:latest .'
            }
        }

        stage ("Push Docker Image") {
            steps {
                    echo "Pushing the built image to docker hub"
                    withCredentials([usernameColonPassword(credentialsId: 'docker_cred_demo', variable: 'docker_cred')]) {
                sh 'docker login -u sundayfagbuaro -p ${docker_cred}' 
                }
                sh 'docker push sundayfagbuaro/simple-java-maven-app:latest'
            }
        }
    }
}
