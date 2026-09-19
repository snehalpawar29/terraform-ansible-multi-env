# 🛠️ Multi-Environment Infrastructure with Terraform & Ansible

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/Ansible-Configuration%20Management-EE0000?style=for-the-badge&logo=ansible&logoColor=white" />
  <img src="https://img.shields.io/badge/AWS-Cloud%20Infrastructure-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white" />
  <img src="https://img.shields.io/badge/Nginx-Web%20Server-009639?style=for-the-badge&logo=nginx&logoColor=white" />
  <img src="https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
</p>

<p align="center">
  <strong>Provision • Configure • Automate • Manage</strong>
</p>

<p align="center">
  Multi-environment AWS infrastructure automated using
  Terraform and Ansible.
</p>

---

## 📌 Project Overview

This project demonstrates how to provision and configure AWS infrastructure across multiple environments using **Terraform** and **Ansible**.

The infrastructure is organized around three environments:

- 🟢 **Development**
- 🟡 **Staging**
- 🔴 **Production**

Terraform is responsible for **infrastructure provisioning**, while Ansible is used for **server configuration and application setup**.

The project also demonstrates dynamic inventory generation, reusable Ansible roles, Nginx configuration, Terraform state management, and infrastructure cleanup.

---

# 🏗️ Project Architecture

<p align="center">
  <img src="images/Project-design.gif" alt="Terraform and Ansible Multi-Environment Architecture" width="900"/>
</p>

### 🔄 Automation Workflow

```text
                       👨‍💻 DevOps Engineer
                              │
                              ▼
                    ┌───────────────────┐
                    │     Terraform     │
                    │ Infrastructure as │
                    │       Code        │
                    └─────────┬─────────┘
                              │
                              ▼
                     ☁️ AWS Infrastructure
                              │
                ┌─────────────┼─────────────┐
                │             │             │
                ▼             ▼             ▼
              DEV          STAGING        PROD
                │             │             │
                └─────────────┼─────────────┘
                              │
                              ▼
                     Terraform Outputs
                              │
                              ▼
                  update_inventories.sh
                              │
                              ▼
                     Dynamic Inventories
                              │
                              ▼
                         ⚙️ Ansible
                              │
                              ▼
                    Nginx Configuration
                              │
                              ▼
                     🌐 Configured Servers
````

---

# 🎯 Project Objectives

The main objectives of this project were to practice:

* Infrastructure as Code using Terraform
* Multi-environment infrastructure management
* AWS resource provisioning
* Terraform modules
* Terraform state management
* Server configuration using Ansible
* Dynamic Ansible inventories
* Reusable Ansible roles
* Nginx installation and configuration
* Automation between Terraform and Ansible
* Infrastructure cleanup and recreation

---

# ☁️ AWS Infrastructure

Terraform is used to provision AWS resources for the different environments.

### Infrastructure Components

* 🖥️ Amazon EC2
* 🪣 Amazon S3
* 🗄️ Amazon DynamoDB
* 🔑 SSH key-based EC2 access

The Terraform configuration uses a reusable infrastructure module for the different environments.

---

# 🌎 Multi-Environment Setup

The project separates infrastructure into three environments:

```text
                    AWS Infrastructure
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
        DEV              STAGE             PROD
          │                │                │
          ▼                ▼                ▼
        EC2              EC2              EC2
        S3               S3               S3
        DynamoDB         DynamoDB         DynamoDB
```

The same infrastructure module can be reused for each environment while allowing environment-specific values such as:

* EC2 instance configuration
* AMI
* S3 bucket names
* DynamoDB table names

---

# 🏗️ Terraform Structure

The Terraform configuration is organized into a reusable infrastructure module.

```text
terraform/
│
├── infra/
│   ├── bucket.tf
│   ├── dynamodb.tf
│   ├── ec2.tf
│   ├── output.tf
│   └── variable.tf
│
├── main.tf
├── providers.tf
├── terraform.tf
├── terraform.tfstate
└── terraform.tfstate.backup
```

### `infra/`

Contains reusable infrastructure definitions for:

| File          | Purpose                    |
| ------------- | -------------------------- |
| `bucket.tf`   | S3 bucket configuration    |
| `dynamodb.tf` | DynamoDB configuration     |
| `ec2.tf`      | EC2 instance configuration |
| `output.tf`   | Terraform outputs          |
| `variable.tf` | Input variables            |

### Root Terraform Files

| File           | Purpose                                       |
| -------------- | --------------------------------------------- |
| `main.tf`      | Defines environment-specific module instances |
| `providers.tf` | AWS provider configuration                    |
| `terraform.tf` | Terraform/backend configuration               |

---

# ⚙️ Terraform Workflow

The infrastructure follows the standard Terraform workflow:

```text
terraform init
       │
       ▼
terraform plan
       │
       ▼
terraform apply
       │
       ▼
AWS Infrastructure
```

### Initialize

```bash
terraform init
```

### Review Changes

```bash
terraform plan
```

### Provision Infrastructure

```bash
terraform apply
```

After deployment, Terraform outputs the required infrastructure information, including EC2 public IPs used later by Ansible.

---

# 🔑 SSH Access

SSH keys are used to access the provisioned EC2 instances.

Example:

```bash
ssh-keygen -t rsa -b 2048 -f devops-key -N ""
```

This generates:

```text
devops-key
devops-key.pub
```

The private key should be protected appropriately:

```bash
chmod 400 devops-key
```

Example EC2 connection:

```bash
ssh -i devops-key ubuntu@<EC2_PUBLIC_IP>
```

> ⚠️ Never commit private SSH keys to a public repository.

---

# ⚙️ Ansible Configuration Management

After Terraform provisions the infrastructure, Ansible is used to configure the servers.

The Ansible setup contains:

* Environment-specific inventories
* Playbooks
* Ansible Galaxy role
* Nginx configuration
* Dynamic inventory generation

---

# 📂 Ansible Structure

```text
ansible/
│
├── inventories/
│   ├── dev
│   ├── stg
│   └── prod
│
├── playbooks/
│   ├── install_nginx_playbook.yml
│   │
│   └── nginx-role/
│       ├── README.md
│       ├── defaults/
│       ├── files/
│       │   └── index.html
│       ├── handlers/
│       ├── meta/
│       ├── tasks/
│       │   └── main.yml
│       ├── templates/
│       ├── tests/
│       └── vars/
│
└── update_inventories.sh
```

---

# 🌐 Dynamic Inventory Automation

One of the key automation components of this project is the `update_inventories.sh` script.

The script connects the Terraform and Ansible workflows.

```text
Terraform
   │
   │ Outputs EC2 IPs
   ▼
update_inventories.sh
   │
   ├── DEV inventory
   ├── STG inventory
   └── PROD inventory
            │
            ▼
         Ansible
```

The script:

1. Retrieves EC2 public IPs from Terraform outputs.
2. Updates the corresponding environment inventory.
3. Adds common Ansible variables.
4. Makes the infrastructure information available to Ansible playbooks.

Make the script executable:

```bash
chmod +x update_inventories.sh
```

Run it with:

```bash
./update_inventories.sh
```

---

# 📋 Environment Inventories

Separate inventories are maintained for each environment:

```text
inventories/
├── dev
├── stg
└── prod
```

Example inventory structure:

```ini
[servers]
server1 ansible_host=<SERVER_IP>
server2 ansible_host=<SERVER_IP>

[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=<PATH_TO_PRIVATE_KEY>
ansible_python_interpreter=/usr/bin/python3
```

This allows the same Ansible configuration to be used against different environments.

---

# 🌐 Nginx Automation

Ansible is used to install and configure **Nginx** across the environment servers.

The project uses an Ansible role named:

```text
nginx-role
```

The role manages:

* Nginx installation
* Nginx service configuration
* Custom `index.html`
* Web server setup

---

# 🧩 Ansible Role Structure

The Nginx role follows the standard Ansible Galaxy structure:

```text
nginx-role/
│
├── README.md
├── defaults/
│   └── main.yml
├── files/
│   └── index.html
├── handlers/
│   └── main.yml
├── meta/
│   └── main.yml
├── tasks/
│   └── main.yml
├── templates/
├── tests/
│   ├── inventory
│   └── test.yml
└── vars/
    └── main.yml
```

The role was initialized using:

```bash
ansible-galaxy role init nginx-role
```

---

# ▶️ Running Ansible Playbooks

After the inventories are updated, the Nginx playbook can be executed for each environment.

### Development

```bash
ansible-playbook -i inventories/dev install_nginx_playbook.yml
```

### Staging

```bash
ansible-playbook -i inventories/stg install_nginx_playbook.yml
```

### Production

```bash
ansible-playbook -i inventories/prod install_nginx_playbook.yml
```

The same configuration can therefore be applied consistently across the different environments.

---

# 🔄 End-to-End Automation

The complete workflow can be summarized as:

```text
        ┌─────────────────────┐
        │      Terraform      │
        │                     │
        │ Provision AWS       │
        │ Infrastructure      │
        └──────────┬──────────┘
                   │
                   ▼
            EC2 Public IPs
                   │
                   ▼
        ┌─────────────────────┐
        │ update_inventories  │
        │       .sh           │
        └──────────┬──────────┘
                   │
                   ▼
        ┌─────────────────────┐
        │       Ansible       │
        │                     │
        │ Configure Servers   │
        └──────────┬──────────┘
                   │
                   ▼
            Nginx Installed
                   │
                   ▼
          Custom Web Page
                   │
                   ▼
        🌐 DEV / STG / PROD
```

---

# 🧪 Validation

The implementation was validated by checking:

* ✅ Terraform initialization
* ✅ Terraform planning
* ✅ Terraform infrastructure provisioning
* ✅ EC2 instance creation
* ✅ S3 bucket creation
* ✅ DynamoDB table creation
* ✅ SSH connectivity
* ✅ Dynamic inventory generation
* ✅ Ansible playbook execution
* ✅ Nginx installation
* ✅ Nginx service configuration
* ✅ Web page accessibility across environments

---

# 📸 Project Evidence

The repository contains implementation screenshots under the `images/` directory.

Examples include:

* Terraform installation
* Ansible installation
* Terraform initialization
* Terraform plan
* Terraform apply
* AWS resources
* EC2 access
* Ansible execution
* Nginx configuration
* Final infrastructure cleanup

---

# 📁 Complete Project Structure

```text
.
├── README.md
│
├── ansible/
│   ├── inventories/
│   │   ├── dev
│   │   ├── prod
│   │   └── stg
│   │
│   ├── playbooks/
│   │   ├── install_nginx_playbook.yml
│   │   │
│   │   └── nginx-role/
│   │       ├── README.md
│   │       ├── defaults/
│   │       ├── files/
│   │       ├── handlers/
│   │       ├── meta/
│   │       ├── tasks/
│   │       ├── templates/
│   │       ├── tests/
│   │       └── vars/
│   │
│   └── update_inventories.sh
│
├── terraform/
│   ├── infra/
│   │   ├── bucket.tf
│   │   ├── dynamodb.tf
│   │   ├── ec2.tf
│   │   ├── output.tf
│   │   └── variable.tf
│   │
│   ├── main.tf
│   ├── providers.tf
│   └── terraform.tf
│
└── images/
```

---

# 🧹 Infrastructure Cleanup

Once the project is complete, the infrastructure can be removed using Terraform.

```bash
terraform destroy
```

Or:

```bash
terraform destroy --auto-approve
```

This removes the resources managed by the Terraform configuration.

> ⚠️ Use `terraform destroy` carefully. Destroying infrastructure can permanently remove resources and data.

---

# 🧠 Key DevOps Concepts Demonstrated

This project provided hands-on practice with:

### Infrastructure as Code

* Terraform
* Terraform modules
* Variables
* Outputs
* State management

### Configuration Management

* Ansible
* Ansible inventories
* Ansible playbooks
* Ansible Galaxy roles

### Cloud Infrastructure

* AWS EC2
* AWS S3
* AWS DynamoDB
* SSH-based server access

### Automation

* Dynamic inventory generation
* Terraform → Ansible workflow
* Automated Nginx configuration
* Multi-environment management

### Linux

* Ubuntu
* Package management
* SSH
* File permissions
* Shell scripting

---

# 🎯 Project Outcome

This project demonstrates an automated approach to managing infrastructure across **development, staging, and production environments**.

The key workflow is:

```text
Infrastructure Provisioning
          ↓
        Terraform
          ↓
      AWS Resources
          ↓
    Dynamic Inventories
          ↓
        Ansible
          ↓
   Server Configuration
          ↓
        Nginx
          ↓
    Multiple Environments
```

The combination of Terraform and Ansible provides a clear separation between:

**Infrastructure Provisioning → Configuration Management**

---

# 🛠️ Technologies Used

<p align="center">

<img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
<img src="https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white" />
<img src="https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white" />
<img src="https://img.shields.io/badge/EC2-orange?style=for-the-badge&logo=amazon-ec2&logoColor=white" />
<img src="https://img.shields.io/badge/S3-orange?style=for-the-badge&logo=amazon-s3&logoColor=white" />
<img src="https://img.shields.io/badge/DynamoDB-blue?style=for-the-badge&logo=amazondynamodb&logoColor=white" />
<img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" />
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
<img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white" />

</p>

---

# 👨‍💻 Author

## Snehal Pawar

**Aspiring DevOps Engineer | AWS | Terraform | Ansible | Linux**

<p>
  <a href="https://github.com/snehalpawar29">
    <img src="https://img.shields.io/badge/GitHub-snehalpawar29-181717?style=for-the-badge&logo=github" />
  </a>

  <a href="https://www.linkedin.com/in/snehalpawar29/">
    <img src="https://img.shields.io/badge/LinkedIn-Snehal%20Pawar-0A66C2?style=for-the-badge&logo=linkedin" />
  </a>
</p>

---

<p align="center">
  ⚙️ <strong>Provision. Configure. Automate.</strong> 🚀
</p>
