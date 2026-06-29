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

}