#!/usr/bin/env python3

import click
import os
from exif import Image
from multiprocessing import Pool


dir_exists = os.path.isdir


def log(msg):
    print(f'photo-organiser> {msg}')


def get_years(file_):
    with open(file_, 'rb') as file:
        img = Image(file)
        if hasattr(img, 'datetime_original'):
            return img.datetime_original.split(':')[0]
        return None


def walk(dir_):
    log(f'walking dir : {dir_}')
    for root, dirs, files in os.walk(dir_):
        for file in files:
            yield os.path.join(root, file)


@click.command()
@click.option('-s', '--src-root', type=str, required=True)
@click.option('-d', '--dest-root', type=str, required=True)
def main(src_root, dest_root):
    log(f'src root = {src_root}')
    log(f'dest root = {dest_root}')

    if not all([dir_exists(src_root), dir_exists(dest_root)]):
        log('Either src-root or dest-root is not present, Exiting')

    with Pool(5) as pool:
        log(set(pool.map(get_years, walk(src_root))))


if __name__ == '__main__':
    main()
