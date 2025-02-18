# Mancala terraform ![status](https://git.sogyo.nl/abaars/mancala-terraform/badges/main/pipeline.svg?ignore_skipped=true)

## What is this project for?

This project is made by me (Alejandro Baars) as I discover how to work with terraform. Here, I will try to document my findings for myself and (possibly) those that come after me. I may have missed some details, for which I will apologize in advance.

## What does this project do?

It launches two virtual machines (Ubuntu 22.04) on Daan's VSphere instance. That's it, so far. The goal is to deploy my (abysmal) Mancala implementation on those machines.

## What do I need to know to understand this project?

You need basic knowledge of Terraform, VSphere, and Gitlab CI/CD (including variables).

## What do the components in the project do?

The meat and bones of this README - a summary of my findings so far. Each file already has its
own documentation as to what each part does. Here, in the README, I will quickly summarize what
each script does and what environment variables need to be set (and when).

### Gitlab-ci.yml

This YAML file takes care of the pipeline to validate and launch the vsphere cluster using Terraform. The first two stages,
terraform-validate and terraform-plan, are triggered automatically, as they take care of validation and preperation. The next stages only trigger on the 'main' branch. terraform-apply has a manual trigger in gitlab which you can access in the pipelines overview. The subsequent ansible step follows when the terraform-apply step has completed.

The final step, terraform-destroy, is not triggered automatically. This step only triggers when the environment variable "$DESTROY_ENABLED" is set to true. **Do not** include this variable as a standard variable. Instead, create a new pipeline in the
gitlab pipeline overview and add the variable there. With this variable, gitlab will only run the terraform-validate and terraform-destroy steps.

You also need to pass on authentification for gitlab (to store the Terraform state), VSphere (to access your cluster), and a public key to enable connecting to your VMs. You need the following environment variables with their respective values:

* **TF_VAR_public_key** --> the public key. Can be found in your home directory on linux under `.ssh/id_ed25519.pub`. In this variable, you must only include the middle part of random numbers and letters.

* **TF_VAR_email** --> your e-mail, which is passed as part of the public key.

* **VSPHERE_USER** --> your VSphere user name.

* **VSPHERE_PASSWORD** --> your VSphere password.

* **GITLAB_ACCESS_TOKEN** --> A gitlab access token with API access only.

All variables must be **Masked and Hidden** and only run on **Protected** branches. This means that they will be unavailable when you test things on a testing branch. Make sure to mark your testing branches as **Protected** as well to keep your information secure.

### Terraform

#### backend.tf

This script configures saving the state of the VM's launched by Terraform. Gitlab has a built-in API to store, read, destroy, etc. which we use. There are ways to store the statefiles in a different location though, if that is your wish.

#### datasources.tf

This script collects the necessary data for Terraform to function. It contains the configuration to connect to the correct VSphere instance (the one on the farm), but also configures the network it attaches the VMs to and the Kubernetes instance it is hosted on. Finally, it also provided the Ubuntu image used to construct the VMs.

#### dependencies.tf

This script lists and configures the required Terraform providers (VSphere and random).

#### main.tf

This script brings the loose elements together. It creates a random password (which is not stored for security) and creates the VMs based on the set criteria (OS, guest user, resources, etc.).

#### variables.tf

This script takes care of the variables used by Terraform. Most of these do not have a default, as they are set using the '-var' command-line flag. It also