#!/usr/bin/env python3
import os
import subprocess
import sys

# Ensure python-dotenv is installed
try:
    from dotenv import load_dotenv
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "python-dotenv"])
    from dotenv import load_dotenv

from os.path import join, dirname
import argparse
import python_src.lib.setup_env as setup_env
import python_src.lib.terraform_handler as terraform
import python_src.lib.ansible_handler as ansible
import logging

LOGLEVEL = os.environ.get('LOGLEVEL', 'INFO').upper()
logging.basicConfig(level=LOGLEVEL)

dotenv_path = join(dirname(__file__), '.env')

def main():

    parser = argparse.ArgumentParser(description='CLI for deploying and managing Backstage infrastructure')
    parser.add_argument("--terraform", help="Terraform options")
    parser.add_argument("--ansible", help="Ansible options")
    # Parse the command-line arguments

    args = parser.parse_args()
    if not vars(args):
        parser.print_help()
        return

    terraform_argument = args.terraform
    ansible_argument = args.ansible
    # if os.getenv('SKIP_LOGIN') == 'false':
    #     env_variables = setup_env.EnvVariablesHandler(dotenv_path)
    #     env_variables.setup_env()
    # elif os.getenv('SKIP_LOGIN') == 'true':
    #     env_variables = setup_env.EnvVariablesHandler('/dev/null')
    #     env_variables.setup_env()
    env_variables = setup_env.EnvVariablesHandler(dotenv_path)
    env_variables.setup_env()
    if terraform_argument:
        if terraform_argument == "init":
            terraform.terraform_init(env_variables, terraform_argument)
        elif terraform_argument == "plan":
            terraform.terraform_plan(env_variables, terraform_argument)
        elif terraform_argument == "apply":
            terraform.terraform_apply(env_variables, terraform_argument)
        elif terraform_argument == "destroy":
            terraform.terraform_destroy(env_variables, terraform_argument)
        elif terraform_argument == "import":
            terraform.terraform_import(env_variables, terraform_argument)
        elif terraform_argument == "state":
            terraform.terraform_state(env_variables, terraform_argument)
        elif terraform_argument == "output":
            terraform.terraform_state(env_variables, terraform_argument)
        elif terraform_argument == "taint":
            terraform.terraform_taint(env_variables, terraform_argument)            
        else:
            print("Error: The terraform argument is incorrect. Possible values are - init, plan, apply, import, state")
    
    if ansible_argument:
        if ansible_argument == "play":
            ansible.ansible_play(env_variables, ansible_argument)
        elif ansible_argument == "ping":
            ansible.ansible_ping(env_variables, ansible_argument)
        else:
            print("Error: The ansible argument is incorrect. Possible values are - ping, play")

if __name__ == '__main__':
    main()