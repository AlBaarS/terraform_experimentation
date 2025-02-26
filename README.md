# Mancala terraform ![status](https://git.sogyo.nl/abaars/mancala-terraform/badges/main/pipeline.svg?ignore_skipped=true)

## What is this project for?

This project is made by me (Alejandro Baars) as I discover how to work with terraform. Here, I will try to document my findings for myself and (possibly) those that come after me. I may have missed some details, for which I apologize.

## What does this project do?

It launches two virtual machines (Ubuntu 22.04) on Daan's VSphere instance. That's it, so far. The goal is to deploy my (abysmal) Mancala implementation on those machines.

## What do you need to know to understand this project?

You need basic knowledge of Terraform, VSphere, and Gitlab CI/CD (including variables).

## What do the components in the project do?

The meat and bones of this README - a summary of my findings so far. Each file already has its own documentation as to what each part does. Here, in the README, I will quickly summarize what each script does and what environment variables need to be set (and when).

### Gitlab-ci.yml

This YAML file takes care of the pipeline to validate and launch the vsphere cluster using Terraform. It contains two pipelines; one that plans and launches the VM's on Daan's kubernetes cluster and one to destroy it.

#### Infrastructure construction

The first part of the pipeline creates the virtual machines. It consists of the terraform-vm-validate, terraform-vm-plan, and terraform-vm-apply steps. These steps validate the terraform scripts, plan the changes to perform, and apply the changes respectively. The apply step needs manual activation in gitlab CI/CD pipelines.

Since this does not rely on any environmental variables to trigger, it runs by default when a change is pushed/merged. It assumes you have

It will add the ip addresses of your virtual machines to your Infisical vault under the key "VM_IP_<number>" and assumes that those keys are not occupied upon creation.

#### Infrastructure destruction

The thsecondird part of the pipeline destroys existing virtual machines. It consists of the terraform-vm-validate and terraform-vm-destroy steps. These steps validate the terraform scripts and destroy the existing infrastructure respectively. The apply step needs manual activation in gitlab CI/CD pipelines.

This pipeline only runs with the "$DESTROY_ENABLED" variable set to true. **Do not** include this variable in the standard variables. Instead, create a new pipeline where you enter the variable so it only applies to that run.

The destruction of the existing infrastructure will remove the terraform state files stored in gitlab (see `backend.tf`), but also remove the IP addresses from your Infisical vault. Other secrets stored in the vault are not affected.

#### Authentification through environment variables

You also need to pass on authentification for gitlab (to store the Terraform state), VSphere (to access your cluster), and Infisical (to access your VM password and IPs). You need the following environment variables with their respective values:

* **INFISICAL_CID** --> your Infisical Universal Auth client ID

* **INFISICAL_CS** --> your Infisical Universal Auth client secret

* **INFISICAL_PID** --> your Infisical project ID

* **VSPHERE_USER** --> your VSphere user name.

* **VSPHERE_PASSWORD** --> your VSphere password.

All variables must be **Masked and Hidden**.

### Terraform

#### backend.tf

This script configures saving the state of the VM's launched by Terraform. Gitlab has a built-in API to store, read, destroy, etc. which we use. There are ways to store the statefiles in a different location though, if that is your wish.

#### datasources.tf

This script collects the necessary data for Terraform to function. It contains the configuration to connect to the correct VSphere instance (the one on the farm), but also configures the network it attaches the VMs to and the Kubernetes instance it is hosted on. Finally, it also provided the Ubuntu image used to construct the VMs.

#### dependencies.tf

This script lists and configures the required Terraform providers (VSphere, random, and Infisical).

#### main.tf

This script brings the loose elements together. It creates a random password (which is not stored for security) and creates the VMs based on the set criteria (OS, guest user, resources, etc.).

#### variables.tf

This script takes care of the variables used by Terraform. Most of these do not have a default, as they are set using the '-var' command-line flag by gitlab-ci.yml.