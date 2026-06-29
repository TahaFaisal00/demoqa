pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup venv') {
            steps {
                bat """
                    python -m venv .venv
                    ".venv\\Scripts\\python.exe" -m pip install --upgrade pip
                    ".venv\\Scripts\\pip.exe" install -r requirements.txt
                    ".venv\\Scripts\\rfbrowser.exe" init
                """
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat """ ".venv\\Scripts\\robot.exe" -d log Tests """
            }
        }

        stage('Publish Results') {
            steps {
                robot outputPath: 'log',
                      outputFileName: 'output.xml',
                      logFileName: 'log.html',
                      reportFileName: 'report.html',
                      passThreshold: 100.0,
                      unstableThreshold: 0.0
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'log/**', allowEmptyArchive: true
        }
    }
}