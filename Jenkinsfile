pipeline {
    agent any
    
    options {
        withAWS(profile: 'S3 Bucket Access')
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
