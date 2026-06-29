pipeline {
    agent any

    environment {
        VENV = 'C:\\development\\demoqa\\.venv\\Scripts'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat """
                    "%VENV%\\robot.exe" ^
                        -d log ^
                        Tests
                """
            }
        }
    }

    post {
        always {
            robot outputPath: 'log',
                  outputFileName: 'output.xml',
                  logFileName: 'log.html',
                  reportFileName: 'report.html',
                  passThreshold: 100.0,
                  unstableThreshold: 0.0

            archiveArtifacts artifacts: 'log/**', allowEmptyArchive: true
        }
    }
}