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
        stage('Build Docker Image') {
            steps{
                echo "Building Docker Image From The Artifact"
                sh 'docker build -t sundayfagbuaro/maven-java-app-build-demo:v1 .'
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps{
                echo "Pushing Image to DockerHub"
                withCredentials([usernamePassword(credentialsId: 'docker-pat', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                     sh 'docker login -u ${docker_user} -p ${docker_pass}'
                }
                sh 'docker push sundayfagbuaro/maven-java-app-build-demo:v1'
            }
        }
    }
}
