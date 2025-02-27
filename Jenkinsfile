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
                    withCredentials([usernamePassword(credentialsId: 'docker_cred', passwordVariable: 'docker_pwd', usernameVariable: 'docker_user')]) {
                sh 'docker login -u ${docker_user} -p ${docker_pwd}' 
                }
                sh 'docker push sundayfagbuaro/simple-java-maven-app:latest'
            }
        }
    }
}
