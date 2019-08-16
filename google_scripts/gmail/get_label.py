#!/usr/local/bin/python3
import click

from oauth2client import file
from httplib2 import Http
from googleapiclient.discovery import build
from google.auth.transport.requests import Request


scopes = 'https://www.googleapis.com/auth/gmail.readonly'


@click.command()
@click.option('-t', '--token-file', required=True, type=str, help='token file')
@click.option('-l', '--label', required=True, type=str, help='label')
@click.option('-f', '--field', required=False, type=str, help='field')
def get_unread_count(token_file, label, field):
    store = file.Storage(token_file)
    creds = store.get()
    if not creds or creds.invalid:
        if creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            exit(1)
    service = build('gmail', 'v1', http=creds.authorize(Http()))
    response = service.users().labels().get(userId='me', id=label).execute()
    if response:
        if field:
            print(response[field])
        else:
            print(response)
        exit(0)
    exit(1)


if __name__ == '__main__':
    get_unread_count()
