pipeline {
    agent any
    parameters {
        string(name: 'CITY', defaultValue: 'London', description: 'Enter the name of the city')
        string(name: 'API_KEY', defaultValue: 'your_openweathermap_api_key', description: 'Enter your OpenWeatherMap API key')
    }
    environment {
        API_KEY = "${params.API_KEY}"
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository containing the weather_checker.sh script
                git branch: 'master', url: 'https://github.com/osll1/weatherAPI.git'
            }
        }
        stage('Run Weather Checker Script') {
            steps {
                script {
                    sh 'chmod +x weather_checker.sh'
                    sh './script.sh "${CITY}"'
                }
            }
        }
        stage('Archive Report') {
            steps {
                archiveArtifacts artifacts: 'weather_report.html', allowEmptyArchive: true
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed!'
        }
    }
}
