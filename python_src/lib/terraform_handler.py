import subprocess
import os
from os.path import join, dirname
import logging

LOGLEVEL = os.environ.get('LOGLEVEL', 'INFO').upper()
logging.basicConfig(level=LOGLEVEL)



def terraform_init(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT + "/variables.tfvars.json"
    terraform_command = ['terraform', 'init']
    logging.debug("In the Terraform init function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_plan(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT + "/variables.tfvars.json"
    if setup_env.OUTPUTFORMAT:
        terraform_command = ['terraform', 'plan', '-var-file', terraform_var_file, "-compact-warnings", setup_env.OUTPUTFORMAT]
    else: 
        terraform_command = ['terraform', 'plan', '-var-file', terraform_var_file, "-compact-warnings"]
    logging.debug("In the Terraform plan function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_apply(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT + "/variables.tfvars.json"
    terraform_command = ['terraform', 'apply', '-auto-approve', '-var-file', terraform_var_file, "-compact-warnings"]
    logging.debug("In the Terraform apply function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_destroy(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT + "/variables.tfvars.json"
    terraform_command = ['terraform', 'destroy', '-var-file', terraform_var_file, "-compact-warnings"]
    logging.debug("In the Terraform destroy function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_import(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT + "/variables.tfvars.json"
    print("Enter the resource address:")
    resource_address = input()
    print("Enter the correspoding resource id:")
    resource_id = input()
    terraform_command = ['terraform', 'import', '-auto-approve', '-var-file', terraform_var_file, "-compact-warnings", resource_address, resource_id]
    logging.debug("In the Terraform apply function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_state(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT + "/variables.tfvars.json"
    terraform_command = ['terraform', 'state', 'list']
    logging.debug("In the Terraform State function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_output(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT 
    terraform_command = ['terraform', 'state', 'list']
    logging.debug("In the Terraform State function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)

def terraform_taint(setup_env, terraform_argument):
    terraform_working_dir = join(os.getcwd(), "cloud-infra/" + setup_env.CLOUD + "/" + setup_env.CODE_PATH)
    terraform_var_file = "../../../environments/" + setup_env.ENVIRONMENT
    print("Enter the resource address:")
    resource_address = input()
    terraform_command = ['terraform', 'taint', resource_address]
    logging.debug("In the Terraform State function " + terraform_argument)
    subprocess.run(terraform_command, check=True, cwd=terraform_working_dir)