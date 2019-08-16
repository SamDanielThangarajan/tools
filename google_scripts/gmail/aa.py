#!/usr/bin/env python3
import os.path


from oauth2client import (
    file,
    client,
    tools
)

######
# Authenticate an user and get Authorizaton tokens.
#
# Note: Parameters are allergic to the GMAIL AA module.
# Get the information as environment variables.
# Env to be set:
# - GMAIL_SECRET_FILE
# - GMAIL_TOKEN_FILE
######

scopes = ['https://www.googleapis.com/auth/gmail.readonly']


def _aa(secret_file, token_file):
    if not os.path.isfile(secret_file):
        print(f'secret file [{secret_file}]: Not found')
        exit(1)

    store = file.Storage(token_file)
    creds = None

    if os.path.isfile(token_file):
        creds = store.get()

    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets(secret_file, scopes)
        creds = tools.run_flow(flow, store)
        store.locked_put(creds)
    exit(0)


def gmail_aa():
    _aa(os.environ['GMAIL_SECRET_FILE'],
        os.environ['GMAIL_TOKEN_FILE'])


if __name__ == '__main__':
    if 'GMAIL_SECRET_FILE' not in os.environ:
        print ('ENV GMAIL_SECRET_FILE not set')
        exit(1)
    if 'GMAIL_TOKEN_FILE' not in os.environ:
        print ('ENV GMAIL_TOKEN_FILE not set')
        exit(1)
    _aa(os.environ['GMAIL_SECRET_FILE'],
        os.environ['GMAIL_TOKEN_FILE'])
