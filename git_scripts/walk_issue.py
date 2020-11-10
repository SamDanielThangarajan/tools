#!/usr/bin/env python3

import asyncio
import click
import subprocess
from prompt_toolkit.eventloop import use_asyncio_event_loop
from prompt_toolkit.application import Application
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.widgets import TextArea
from prompt_toolkit.layout.layout import Layout
from prompt_toolkit.filters import Condition
from prompt_toolkit.layout.containers import (
    HSplit,
    VSplit,
    Window,
    WindowAlign,
    ConditionalContainer
)
from prompt_toolkit.application import get_app
from prompt_toolkit.layout.controls import FormattedTextControl


use_asyncio_event_loop()
kb = KeyBindings()
application = None
shutdown = asyncio.Event()
commits_field = TextArea(multiline=True, scrollbar=True)
content_field = TextArea(multiline=True, scrollbar=True)


class State(object):
    Commits = None
    CurrentCommit = None
    CurrentCommitDesc = None
    CachedCommits = {}


@kb.add('c-c')
@kb.add('c-d')
def exit_(event):
    shutdown.set()
    event.app.exit()


def commit_selector(buf):
    content_field.buffer = str(buffer)
    get_app().layout.focus(output_field)

def get_header():
    return 'this is the header text'

def get_commit_desc():
    return 'this is the commit desc.'

commits_field.accept_handler = commit_selector


body = HSplit([
    Window(FormattedTextControl(get_header)),
    Window(height=1, char='-', style='class:line'),
    # Main play area
    VSplit([
        commits_field,
        Window(width=1, char='|', style='class:line'),
        content_field
    ]),
    Window(height=1, char='-', style='class:line'),
    Window(FormattedTextControl(get_commit_desc))
])


application = Application(layout=Layout(body),
                          key_bindings=kb,
                          full_screen=True)

async def start():
    commits_field.buffer.text = '\n'.join(State.Commits.keys())
    await application.run_async().to_asyncio_future()


@click.command()
@click.option('-t', '--topic', required=True, type=str, help='git topic')
def it_all_begins_here(topic):
    process = subprocess.getoutput(' '.join(['git', 'log', '--grep=ISKY-213:',
                              '--abbrev-commit',
                              '--format=format:"%h %s"',
                              '--reverse']))
    State.Commits = {}
    for line in process.split('\n'):
        tup = line.partition(' ')
        State.Commits[tup[0]] = tup[2]

    asyncio.get_event_loop().run_until_complete(start())


if __name__ == '__main__':
    it_all_begins_here()
