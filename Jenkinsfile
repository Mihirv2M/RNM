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
        stage('Email Notification'){
            mail bcc: '', body: '''Hi Welcome to Jenkins Build Complete!
            Thanks from
            Devops Team''', cc: '', from: '', replyTo: '', subject: 'jenkins', to: 'mihirv.brainerhub@gmail.com'
        }
    }

    post {
        always {
            sh 'docker ps'
        }
    }
}
