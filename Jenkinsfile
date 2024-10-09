pipeline {
    agent {
        label 'jenkins'  // Use the label you assigned to your EC2 node
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose down'
                sh 'docker compose up -d --build'
            }
        }
    }

    // post {
    //     always {
    //         sh 'docker ps'
    //     }
    // }
}
