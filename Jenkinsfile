pipeline {
    agent any
    
    options {
    	withAWS(credentials: 'S3 Access')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mozaic-services/javascript-calculator'
            }
        }
        stage('Deploy to Test') {
            steps {
                s3Upload(
                    bucket: env.S3_BUCKET_TEST,
                    includePathPattern: '**/*',
                    excludePathPattern: 'Jenkinsfile'
                )
            }
        }

        stage('Wait for approval') {
            steps {
                snDevOpsChange()
            }
        }

        stage('Deploy to Production') {
            steps {
                s3Upload(
                    bucket: env.S3_BUCKET_TEST,
                    includePathPattern: '**/*',
                    excludePathPattern: 'Jenkinsfile'
                )
            }
        }
    }
}
