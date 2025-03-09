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
        stage('Deploy Application to Docker Host') {
            steps{
                echo "Deploying Application To Docker Host"
                script{
                    sshagent(['Jenkins_docker_host']) {
                        sh """ 
                            ssh -tt -o StrictHostKeyChecking=no bobosunne@10.10.1.42 << EOF

                            docker run -d --name simple-maven-java-app -p 8070:8070 sundayfagbuaro/maven-java-app-build-demo:v1
                        """
                    }
                }
            }
        }
    }
}
