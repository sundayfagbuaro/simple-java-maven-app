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
                    withCredentials([usernamePassword(credentialsId: 'docker_cred', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                sh 'docker login -u ${docker_user} -p ${docker_pass}' 
                }
                sh 'docker push sundayfagbuaro/simple-java-maven-app:latest'
            }
        }

        stage('Deploy container to Docker Host') {
            steps {
                echo "Deploying container to docker host"
                script {
                    sshagent(['remote-docker-host']) {
                    sh """ ssh -tt -o StrictHostKeyChecking=no bobosunne@192.168.1.158 << EOF
                        
                        docker run -d -p 8070:8070 --name deploy_test sundayfagbuaro/simple-java-maven-app:latest
                        exit
                        EOF"""                    
                }
                
                }
            }
        }
    }
}
