# Running a Vault Proof of Value Session

## Steps

### Prerequisites

- Create an ssh key
  [Linux/Mac terminal instructions](https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-putty-to-connect-to-a-vps)

  [Putty instructions](https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-putty-to-connect-to-a-vps)

  Make sure to save the private and public key somewhere you can find them.


- Create a Terraform Enterprise account by navigating to this link and following the instructions: https://app.terraform.io/account/new

- Notify the instructor of your Terraform Enterprise user name.

- Log into the appropriate Terraform Enterprise organization.
  - The appropriate Terraform Enterprise organization will have an OAuth link that allows it to create a workspace using this repository.
  - Steps
    - Click 'Create Workspace'
    - Name your workspace
    - Choose `TheHob/vault-pov-training` as the repository to which you'd like to link.
    - Choose `master` as the branch to which you'd like to attach your workspace.
    - Populate the below variables on the 'Variables' tab
    ```
    # Terraform variables
    public_key = # Value: Contents of your personal SSH public key
    my_name    = # Your name or the name you'd like to apply to your environment

    # Environment variables
    AWS_ACCESS_KEY_ID     = # Value: Your AWS access key ID
    AWS_SECRET_ACCESS_KEY = # Value: Your AWS secret access key
    ```
    - Once populated, queue a plan.
    - Once plan completes, confirm it.
    - Use the outputs to connect to your VM. You should see something like the below.
    ```
    ssh -i ec2-user@<Public DNS of your VM>
    ```




- export AWS_DEFAULT_REGION=us-east-1
- export TF_VAR_public_key=$(cat ~/.ssh/id_rsa.pub)
