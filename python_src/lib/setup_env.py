import os
import sys
from os.path import join, dirname
from dotenv import load_dotenv
import logging

LOGLEVEL = os.environ.get('LOGLEVEL', 'INFO').upper()
logging.basicConfig(level=LOGLEVEL)


# Declaring Environmental Variables
class EnvVariablesHandler:
    def __init__(self, dotenv_path):
        self.dotenv_path = dotenv_path
        if os.getenv('SKIP_LOGIN') != 'true':
            if os.getenv(os.getenv('ENVIRONMENT') + "_ARM_CLIENT_ID") == None:
                logging.error("TF variable for "+os.getenv('ENVIRONMENT')+" not defined")
                sys.exit()
            load_dotenv(self.dotenv_path)
        #elif os.getenv('SKIP_LOGIN') == 'true':
        if not os.getenv('ENVIRONMENT'):
            logging.info("Please define ENVIRONMENT variable")
            sys.exit()
        else:
            self.ENVIRONMENT=os.getenv('ENVIRONMENT')

        if not os.getenv('CODE_PATH'):
            logging.info("Please define CODE_PATH variable")
            sys.exit()
        else:
            self.CODE_PATH=os.getenv('CODE_PATH')

        if not os.getenv('CLOUD'):
            logging.info("Please define CLOUD variable")
            sys.exit()
        else:
            self.CLOUD=os.getenv('CLOUD')

        if os.getenv('OUTPUTFORMAT'):
            self.OUTPUTFORMAT="-" + os.getenv('OUTPUTFORMAT')
        else:
            self.OUTPUTFORMAT=None

    def setup_env(self):
        TF_CLI_ARGS_init="TF_CLI_ARGS_init=-backend-config=../../../environments/" + self.ENVIRONMENT + "/backends/" + self.CODE_PATH + "-backend.hcl" + "\n"
        if os.getenv('SKIP_LOGIN') != 'true':
            load_dotenv(self.dotenv_path)
            logging.debug("The dotenv path is " + self.dotenv_path)
            logging.debug("The Environment variable loaded for environment_ARM_CLIENT_ID is " + os.getenv(self.ENVIRONMENT + "_ARM_CLIENT_ID"))

            with open(self.dotenv_path, "w") as f:
                f.write("TF_CLI_ARGS_init=-backend-config=../../../environments/" + self.ENVIRONMENT + "/backends/" + self.CODE_PATH + "-backend.hcl" + "\n")
                f.write("ARM_CLIENT_ID" + "=" + os.getenv(self.ENVIRONMENT + "_" + "ARM_CLIENT_ID") + "\n")
                f.write("ARM_CLIENT_SECRET" + "=" + os.getenv(self.ENVIRONMENT + "_" + "ARM_CLIENT_SECRET") + "\n")
                f.write("ARM_TENANT_ID" + "=" + os.getenv(self.ENVIRONMENT + "_" + "ARM_TENANT_ID") + "\n")
                f.write("ARM_SUBSCRIPTION_ID" + "=" + os.getenv(self.ENVIRONMENT + "_" + "ARM_SUBSCRIPTION_ID") + "\n")
        else:
            logging.debug("Skipped login to service principal")