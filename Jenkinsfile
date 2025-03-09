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
    }
}
