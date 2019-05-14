pipeline {
	agent any

	stages {
		stage('Deploy') {
			steps {
				sh './calculator-deploy.sh $ENVIRONMENT'
			}
		}
	}
}

