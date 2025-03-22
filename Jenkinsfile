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
        stage('Build Docker Image from the artifact') {
            steps{
                echo "Building Docker Image"
                sh "docker build -t simple-maven-java-app-class-demo ."
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps{
               echo "Pushing Image to Docker Hub" 
               withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                    sh "docker login -u ${docker_user} -p ${docker_pass}"
                }

                sh "docker tag simple-maven-java-app-class-demo sundayfagbuaro/simple-maven-java-app-class-demo:v1"
            }
        }
        stage('Deploy Application to Docker Host') {
            steps{
                echo "Dep[loying Containter to Docker Host]"
                sshagent(['docker-lab-user']) {
                    sh """

                    ssh -tt -o StrictHostKeyChecking=no bobosunne@10.10.1.42 << EOF
                    docker run -d --name simple_maven -p 8080:8080 sundayfagbuaro/simple-maven-java-app-class-demo:v1
                    exit
                    EOF
                    """
                }
            }
            
        }

    }       
}

   