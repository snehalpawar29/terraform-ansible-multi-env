#!/bin/bash

TERRAFORM_OUTPUT_DIR="/home/ubuntu/terraform-ansible-multi-env/terraform"
ANSIBLE_INVENTORY_DIR="/home/ubuntu/terraform-ansible-multi-env/ansible/inventories"

cd "$TERRAFORM_OUTPUT_DIR" || { echo "Teraa Dir Not Found"; exit 1; }

DEV_IPS=$(terraform output -json dev_infra_instance_public_ips | jq -r '.[]')
STG_IPS=$(terraform output -json stg_infra_instance_public_ips | jq -r '.[]')
PROD_IPS=$(terraform output -json prod_infra_instance_public_ips | jq -r '.[]')

update_inventory_file() {
    local ips="$1"
    local inventory_file="$2"
    local env="$3"

    > "$inventory_file"

    echo "[servers]" >> "$inventory_file"

    local count=1
    for ip in $ips; do
        echo "server${count} ansible_host=$ip" >> "$inventory_file"
        count=$((count + 1))
    done

    echo " " >>"$inventory_file"
    echo "[servers:vars]" >> "$inventory_file"
    echo "ansible_user=ubuntu" >> "$inventory_file"
    echo "ansible_ssh_private_key_file=/home/ubuntu/terraform-ansible-multi-env/terraform/snehal-devops-key" >> "$inventory_file"
    echo "ansible_python_interpreter=/usr/bin/python3" >> "$inventory_file"

    echo "Update $env inventory: $inventory_file"
}

update_inventory_file "$DEV_IPS" "$ANSIBLE_INVENTORY_DIR/dev" "dev"
update_inventory_file "$STG_IPS" "$ANSIBLE_INVENTORY_DIR/stg" "stg"
update_inventory_file "$PROD_IPS" "$ANSIBLE_INVENTORY_DIR/prod" "prod"

echo "All inventory files updated successfully!"

