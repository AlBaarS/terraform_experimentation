# Mancala terraform

## What is this project for?

This project is made by me (Alejandro Baars) as I discovered how to work with terraform. Here, I will try to document my findings for myself and (possibly) those that come after me. I may have missed some details, for which I will apologize in advance.

## What does this project do?

It launches two virtual machines (Ubuntu 22.04) on Daan's VSphere instance. That's it, so far. The goal is to deploy my (abysmal) Mancala implementation on those machines.

## What do I need to know to understand this project?

You need basic knowledge of Terraform, VSphere, and Gitlab CI/CD (including variables).

## What do the components in the project do?

The meat and bones of this README - a summary of my findings so far. To preface, my experience with Terraform has been quite positive, but it is not without its quirks. Then again, what computer programme/language is?

### Gitlab-ci.yml

...

### Terraform

#### backend.tf

This script configures one small but important thing: saving the state of the VM's launched by Terraform. Gitlab has a built-in API to store, read, destroy, etc. Terraform statefiles. The location listed is default, and for your own application, you likely need to change only one thing in the script itself. The four-digit ID must be exchanged for your own project ID.

This piece also relies on the environment variable "$GITLAB_ACCESS_TOKEN", which is passed as the password through an argument provided by the gitlab-ci.yml file. Make sure you have an access token with API access (nothing more). Set it to Hidden and Masked, but turn off Protected.

#### main.tf

This script contains the overall skeleton of the project