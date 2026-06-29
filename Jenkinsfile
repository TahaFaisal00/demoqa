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
                // call the venv's robot by full path — no activation needed
                bat """
                    "%VENV%\\robot.exe" ^
                        --listener allure_robotframework:allure-results ^
                        -d log ^
                        Tests
                """
            }
        }
    }

    post {
        always {
            // Allure report on the build page (needs plugin + configured tool)
            allure includeProperties: false,
                   jdk: '',
                   results: [[path: 'allure-results']]

            // keep Robot's native output too
            archiveArtifacts artifacts: 'log/**', allowEmptyArchive: true
        }
    }
}