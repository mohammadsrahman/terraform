.PHONY: setup init plans plan apply plan-destroy destroy clean

export GOOGLE_CLOUD_KEYFILE_JSON=$(shell pwd)/terraform-gke-sportsloop-keyfile.json

SERVICE_ACCOUNT_NAME ?= terraform-service-account
BUCKET_NAME = ${PROJECT}-terraform-state
CREDENTIALS_FILE = terraform-gke-${PROJECT}-keyfile.json

ifeq (${DATABASE},)
ifeq (${CLUSTER},)
ifeq (${NETWORK},)
	OUTPUT_TEXT = " PROJECT: ${PROJECT}"
	TEMP_DIR = .tmp/.tmp-project-${PROJECT}/
	MODULE_PATH = modules/custom/project
	PREFIX = project/terraform/state
	VAR_FILE = ${PROJECT}-project.tfvars
else
	OUTPUT_TEXT = " NETWORK: ${NETWORK}  -  PROJECT: ${PROJECT}"
	TEMP_DIR = .tmp/.tmp-network-${NETWORK}/
	MODULE_PATH = modules/custom/network
	PREFIX = ${NETWORK}-network/terraform/state
	VAR_FILE = ${NETWORK}-network.tfvars
endif
else
	OUTPUT_TEXT = " CLUSTER: ${CLUSTER}  -  PROJECT: ${PROJECT}"
	TEMP_DIR = .tmp/.tmp-cluster-${CLUSTER}/
	MODULE_PATH = modules/custom/cluster
	PREFIX = ${CLUSTER}-cluster/terraform/state
	VAR_FILE = ${CLUSTER}-cluster.tfvars
endif
else
	OUTPUT_TEXT = " DATABASE: ${DATABASE}  -  PROJECT: ${PROJECT}"
	TEMP_DIR = .tmp/.tmp-postgresql-${CLUSTER}/
	MODULE_PATH = modules/custom/postgresql
	PREFIX = ${DATABASE}-postgresql-ha/terraform/state
	VAR_FILE = ${DATABASE}-postgresql.tfvars
endif

check:
	@[ "${PROJECT}" ] || ( echo ">> PROJECT is not set"; exit 1 )


###################
# SETUP COMMANDS  #
###################

setup-gcp-for-terraform: check
	@make create-terraform-service-account
	@make generate-keyfile
	@make create-remote-state-bucket
	@make create-service-account-permissions
	@make set-bucket-permissions

create-terraform-service-account: check
	@gcloud iam service-accounts describe ${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com || gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} --project=${PROJECT}

create-service-account-permissions: check
	@gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/container.admin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/compute.admin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/dns.admin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountUser && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountAdmin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountKeyAdmin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin && \
	gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/storage.objectAdmin && \
	gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/storage.admin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/pubsub.admin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/cloudsql.admin && \
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com --role roles/servicenetworking.networksAdmin

generate-keyfile: check
	gcloud iam service-accounts keys create ${CREDENTIALS_FILE} --iam-account=${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com

create-remote-state-bucket: check
	@(gsutil ls -p ${PROJECT} gs://${BUCKET_NAME} || gsutil mb -p ${PROJECT} gs://${BUCKET_NAME}/) && \
    gsutil versioning set on gs://${BUCKET_NAME}/

set-bucket-permissions: check
	@gsutil iam ch serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com:legacyBucketWriter gs://${BUCKET_NAME}/

#######################
# TERRAFORM COMMANDS  #
#######################
setup: check
	@rm -rf ${TEMP_DIR}
	@mkdir -p ${TEMP_DIR}
	@cp ${MODULE_PATH}/* ${TEMP_DIR}
	@cp config/${VAR_FILE} ${TEMP_DIR}
	@cp ${CREDENTIALS_FILE} ${TEMP_DIR}

clean:
	@rm -rf .tmp*

init: setup
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  initialising from state file ${PREFIX}/${BUCKET_NAME}"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform init \
		-input=false \
    	-force-copy \
    	-upgrade \
		-backend-config="credentials=${CREDENTIALS_FILE}" \
		-backend-config="bucket=${BUCKET_NAME}" \
		-backend-config="prefix=${PREFIX}"

plan: init
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  creating change plan report"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform plan \
    	-input=false \
    	-refresh=true \
		-var-file="${VAR_FILE}"

apply: init fmt validate
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  applying changes"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform apply \
    	-refresh=true \
		-var-file="${VAR_FILE}"

plan-destroy: init
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  creating destroy planning report"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-var-file="${VAR_FILE}"

destroy: init
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  destroying"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform destroy \
		-refresh=true \
		-var-file="${VAR_FILE}"


fmt:
	@echo "-----------------------------------------"
	@echo "| ACTION:  Format Files"
	@echo "-----------------------------------------"
	@terraform fmt -recursive -diff

validate:
	@echo "-----------------------------------------"
	@echo "| ACTION:  Validate Files"
	@echo "-----------------------------------------"
	@terraform validate


apply-skip: init fmt validate
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  applying changes"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform apply \
    	-refresh=true \
		-var-file="${VAR_FILE}" \
		-auto-approve

destroy-skip: init
	@echo "-----------------------------------------"
	@echo "|${OUTPUT_TEXT}"
	@echo "| ACTION:  destroying"
	@echo "-----------------------------------------"

	@cd ${TEMP_DIR} && GOOGLE_CLOUD_KEYFILE_JSON=${CREDENTIALS_FILE} && terraform destroy \
		-refresh=true \
		-var-file="${VAR_FILE}" \
		-auto-approve