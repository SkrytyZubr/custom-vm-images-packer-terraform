# Custom VM Image Pipeline: Packer + Ansible + Terraform (Azure)

## 📁 Repository Structure

```
├── .pkr.hcl             # Packer template using .hcl
├── ansible.pkr.hcl      # Packer template with ansible using .hcl  
├── ansible/             # Playbooks and roles for configuration  
├── clean.sh             # Cleanup script for the image (waagent)  
├── terraform/  
│   ├── compute.tf       # Deploy VM from custom image  
│   ├── variables.tf     # Predefine vars for rest of configuration
│   ├── network.tf       # Setup of vnet and subnet 
│   ├── provider.tf      # Selected azure as host
│   ├── rg.tf            # Resource group
│   └── terraform.tfvars # Sample values for variables  
└── README.md            # This file  
```

## 🚀 Project Goal

This project demonstrates:
1. Creating a **custom Linux image for Azure** using **Packer + Ansible**.
2. Deploying a VM using **Terraform**, based on that image.

Tools used:
- **Packer (HCL)** with `ansible-local` provisioner,
- **Ansible playbook** for OS configuration,
- **Terraform (azurerm)** for VM and resource deployment on Azure.

---

## 🧩 Prerequisites

- Azure account with **Contributor** or **Owner** access.
- Installed tools: `packer` (>= 1.7), `terraform` (>= 1.5), `az cli`.
- Azure Service Principal with:
  - `client_id`
  - `client_secret`
  - `tenant_id`
  - `subscription_id`

These should be exported as environment variables:

```bash
export ARM_CLIENT_ID=...
export ARM_CLIENT_SECRET=...
export ARM_TENANT_ID=...
export ARM_SUBSCRIPTION_ID=...
```

---

## 🧱 Building Image with Packer + Ansible

In the main directory:

1. Ensure your `.pkr.hcl` is configured and compatible with the Ansible plugin.
2. Run the following:
   ```bash
   cd ./packer/
   packer init .pkr.hcl
   packer validate .pkr.hcl
   packer build .pkr.hcl
   ```
3. The image will be created in a resource group (e.g., `rg_images` or as defined in the template).

---

## 🌐 Deploying Resources via Terraform

In the `terraform/` directory:

1. Update `terraform.tfvars` with required values (e.g., resource group name, location).
2. Deploy:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

---

## 🔁 Workflow Overview

1. Packer creates a managed image like `linuxWeb-0.0.x`.
2. Terraform provisions a VM from this image.
3. For new image versions:
   - Update the version in `.pkr.hcl`,
   - Rebuild the image with `packer build`,
   - Re-apply Terraform.

---
