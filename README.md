# terraform

# Terraform

To begin login to your Google Account. Easy way of doing this running the following command:

Ensure yoi have already created a Project and retrieve the ProjectId

e.g sportsloop is my Project Id for this example.

```
gcloud auth login
```
## Setup terraform
To begin we need to create the remote state files for terrafrom.

````
 make setup-gcp-for-terraform PROJECT=sportsloop
````

This will create the Terraform State file in A Bucket in GCP

We need to create a service account which will grant access to the GCP APIs.
We will then download the keyfile in order to give us access to those API's so we can run terraform.

Execute the following command:

````
make generate-keyfile PROJECT=sportsloop  
````
## Usage

This project provides modules to create a private kubernetes cluster.
This is backed by static IP's and Subnets. There are 2 main commands which executes the provisioning of the clusters.

1. Network Creation
2. Cluster Creation

### Create the Networks

````
make apply NETWORK=us-central1 PROJECT=sportsloop
make apply NETWORK=prod PROJECT=sportsloop
````

if you would like to see detailed changes then use the following instead:

````
make plan NETWORK=dev PROJECT=sportsloop
make plan NETWORK=prod PROJECT=sportsloop
````

### Create the Clusters

````
make apply CLUSTER=dev PROJECT=sportsloop
make apply CLUSTER=prod PROJECT=sportsloop
````

if you would like to see detailed changes then use the following instead:

````
make plan CLUSTER=dev PROJECT=sportsloop
make plan CLUSTER=prod PROJECT=sportsloop
````

### Create Databases

````
make apply DATABASE=dev PROJECT=sportsloop
make apply DATABASE=prod PROJECT=sportsloop
````

if you would like to see detailed changes then use the following instead:

````
make plan DATABASE=dev PROJECT=sportsloop
make plan DATABASE=prod PROJECT=sportsloop
````

### Create All
````
make apply-skip PROJECT=sportsloop && \
make apply-skip  NETWORK=dev PROJECT=sportsloop && \
make apply-skip  NETWORK=prod PROJECT=sportsloop && \
make apply-skip  CLUSTER=dev PROJECT=sportsloop && \
make apply-skip  CLUSTER=prod PROJECT=sportsloop && \
make apply-skip  DATABASE=dev PROJECT=sportsloop && \
make apply-skip  DATABASE=prod PROJECT=sportsloop
````

### Destroy

The following commands are similar to creating the Networks and Clusters

#### Destroy Clusters
````
make destroy CLUSTER=dev PROJECT=sportsloop
make destroy CLUSTER=prod PROJECT=sportsloop
````

#### Destroy Networks
````
make destroy NETWORK=dev PROJECT=sportsloop
make destroy NETWORK=prod PROJECT=sportsloop
````

#### Destroy Databases
````
make destroy DATABASE=dev PROJECT=sportsloop
make destroy DATABASE=prod PROJECT=sportsloop
````

### Destroy All
````
make destroy-skip DATABASE=dev PROJECT=sportsloop && \
make destroy-skip DATABASE=prod PROJECT=sportsloop && \
make destroy-skip CLUSTER=dev PROJECT=sportsloop && \
make destroy-skip CLUSTER=prod PROJECT=sportsloop && \
make destroy-skip NETWORK=dev PROJECT=sportsloop && \
make destroy-skip NETWORK=prod PROJECT=sportsloop && \
make destroy-skip PROJECT=sportsloop
````

## TO-DO
- Reserve a static address in google
- Create Billing Export & Enable Big Data Query
- Global Ingress (Not Done)

## Notes
- n1-standard-1 (1vCPU, 3.75GB) on both clusters.
- Node Upgrades are not disabled
- Create Cloud Functions for Notifications (Especially since Google updates the Control Plane)
- 2 Node Pools (Default is for Apps, Core is for Cluster Management e.g Prometheus)
- dev cluster is in 1 Zone, Prod Cluster in 2 Zones
- Both Dev and Prod DB's are HA and have 3 replicas. Dev does not have to be HA as assuming you would want many of these

# Setup terraform

### To setup a GCP project for terraform:
````
 make setup-gcp-for-terraform PROJECT=<..>
````

# Use terraform

### Retrieve keyfile to use for terraform commands:
````
make generate-keyfile   
````

# Creatre docker repo creds file

### To pull and push to our docker registry, create .docker dir and add creds into file:
````
mkdir .docker && touch .docker/config.json   
````

# Features

# Project commands

### Show detailed changes:
````
make plan PROJECT=<..>
````

### Show modules that will be changed:
````
make plans PROJECT=<..>
````

### Apply changes:
````
make apply PROJECT=<..>
````

### Show what will be destroyed:
````
make plan-destroy PROJECT=<..>
````

### Destroy:
````
make destroy PROJECT=<..>
````
# Network commands

### Show detailed changes:
````
make plan NETWORK=<..> PROJECT=<..>
````

### Show modules that will be changed:
````
make plans NETWORK=<..> PROJECT=<..>
````

### Apply changes:
````
make apply NETWORK=<..> PROJECT=<..>
````

### Show what will be destroyed:
````
make plan-destroy NETWORK=<..> PROJECT=<..>
````

### Destroy:
````
make destroy NETWORK=<..> PROJECT=<..>
````


# Cluster commands

Must have ENV variable GITLAB_TOKEN set.

### Show detailed changes:
````
make plan CLUSTER=<..> PROJECT=<..>
````

### Show modules that will be changed:
````
make plans CLUSTER=<..> PROJECT=<..>
````

### Apply changes:
````
make apply CLUSTER=<..> PROJECT=<..>
````

### Show what will be destroyed:
````
make plan-destroy CLUSTER=<..> PROJECT=<..>
````

### Destroy:
````
make destroy CLUSTER=<..> PROJECT=<..>
````