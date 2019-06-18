#!/bin/sh
#
# Deploy to AWS CloudFormation
#

set -ex

UPDATE_ONLY="${UPDATE_ONLY:-false}"

if [ -f "../../parameters/$JOB_BASE_NAME.sh" ]; then
	. "../../parameters/$JOB_BASE_NAME.sh"
fi

if [ -n "$vars" ]; then
	echo '[' >parameters.json

	for _v in $vars; do
		eval var="\$$_v"

		[ -n "$NOT_FIRST" ] && echo '	,' >>parameters.json

		cat >>parameters.json <<EOF
	{
		"ParameterKey": "$_v",
		"ParameterValue": "$var"
	}
EOF
		NOT_FIRST=y

	done
	echo ']' >>parameters.json
fi

if [ x"$UPDATE_ONLY" = x'false' ]; then
	if aws --output text --query "StackSummaries[?StackName == '$STACK_NAME' && StackStatus != 'DELETE_COMPLETE'].StackName" cloudformation list-stacks | grep -E "^$STACK_NAME$"; then
		# Stack exists

		# Empty bucket if it exists
		aws s3 ls "s3://$BucketName" && aws s3 rm --recursive "s3://$BucketName" || :

		# Delete stack
		aws cloudformation delete-stack --stack-name "$STACK_NAME"

		aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"
	fi

	aws cloudformation create-stack --template-body "file://$TEMPLATE" --parameters "file://$PWD/parameters.json" --stack-name "$STACK_NAME"

	aws cloudformation wait stack-create-complete --stack-name "$STACK_NAME"
fi

aws s3 sync --delete . s3://$BucketName/ --exclude '.git/*' --exclude .gitignore --exclude Jenkinsfile --exclude calculator-deploy.sh
