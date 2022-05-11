.ONESHELL:

AWS_REGION  ?= us-east-1
AWS_PROFILE ?= dev
APP_NAME	?= read-app-sam
S3_PREFIX    = YT/read-app-sam # used to organize the build artifacts in S3

STACK_NAME = $(APP_NAME)-stack

LOG_RETENTION_QA = 14

################## Development ##################

validate-template:
	sam validate --template-file template.yaml

sync:
	npm update

	sam sync --beta-features --template-file template.yaml --watch --stack-name $(STACK_NAME) --region $(AWS_REGION) --profile $(AWS_PROFILE)

build-local-functions:
	rm -Rf .aws-sam/build/
	sam build --beta-features --template-file template.yaml

################## Development getAllOrdersFunction ##################

invoke-get-all-orders:
	sam local invoke getAllOrdersFunction --template-file template.yaml --event events/get-all-orders.json --region $(AWS_REGION)

################## Deployment ##################

deploy:
	rm -Rf node_modules
	rm -Rf .aws-sam
	cd src && npm install --only=prod
	
	sam deploy --template-file template.yaml --stack-name $(STACK_NAME) --resolve-s3 --s3-prefix $(S3_PREFIX) --capabilities CAPABILITY_IAM --region $(AWS_REGION) --profile $(AWS_PROFILE)

logs:
	sam logs --beta-features --stack-name $(STACK_NAME) --tail --region $(AWS_REGION) --profile $(AWS_PROFILE)

destroy:
	sam delete --stack-name $(STACK_NAME) --region $(AWS_REGION) --profile $(AWS_PROFILE)