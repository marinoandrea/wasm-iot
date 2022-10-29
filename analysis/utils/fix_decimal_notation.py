#!/usr/bin/python3
'''
This script formats a CSV in a way that prevents
floating point scalars to be represented with a varying number
of characters, this allows for consistent parsing in third party
software tools like Excel.
'''
import argparse
from dataclasses import dataclass
from os import PathLike
from typing import cast

import pandas as pd


@dataclass
class Args:
    file_in: PathLike
    file_out: PathLike


def parse_args() -> Args:
    parser = argparse.ArgumentParser(
        prog="[green-lab] Fix Decimal Notation",
        description="Export an equivalent dataset with fixed floating point precision.")
    parser.add_argument('-i', '--input', dest='file_in')
    parser.add_argument('-o', '--output', dest='file_out')
    args = parser.parse_args()
    return cast(Args, args)


def main():
    args = parse_args()
    dataset = pd.read_csv(args.file_in)
    dataset.to_csv(args.file_out, float_format='%.5f')


if __name__ == '__main__':
    main()
