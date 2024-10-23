import subprocess
import os
from os.path import join, dirname
import logging

LOGLEVEL = os.environ.get('LOGLEVEL', 'INFO').upper()
logging.basicConfig(level=LOGLEVEL)
username = 'opsuser'
inventory_dir = join(os.getcwd(),"ansible_src/group_vars/all")

def ansible_ping(env_variables, ansible_argument):
    working_dir = join(os.getcwd(), "ansible_src")    
    ansible_command = ['ansible', 'all', '-i', inventory_dir, '-u', username, '-m', 'ping']
    logging.debug("In the Ansible play function " + working_dir)
    subprocess.run(ansible_command, check=True, cwd=working_dir)
    logging.info("Ansible command executed" + ansible_argument)

def ansible_play(env_variables, ansible_argument):
    working_dir = join(os.getcwd(), "ansible_src")
    playbook_dir = join(os.getcwd(), "ansible_src/site.yml")
    ansible_command = ['ansible-playbook','-i', inventory_dir, '-u', username, playbook_dir ]
    logging.debug("In the Ansible play function " + working_dir)
    subprocess.run(ansible_command, check=True, cwd=working_dir)
    logging.info("Ansible command executed" + ansible_argument)
