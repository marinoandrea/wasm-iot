#!/usr/bin/python3
'''
This script takes the result CSV for the experimental runs
and groups the results by the programming language and WASM runtime.
'''
import argparse
from dataclasses import dataclass
from os import PathLike
from typing import cast

import numpy as np
import pandas as pd


@dataclass
class Args:
    file_in: PathLike
    file_out: PathLike


def parse_args() -> Args:
    parser = argparse.ArgumentParser(
        prog="[green-lab] Merge Benchmarks Results Util",
        description="Merge the results for all benchmarks grouped by programming language and WASM runtime.")
    parser.add_argument('-i', '--input', dest='file_in')
    parser.add_argument('-o', '--output', dest='file_out')
    args = parser.parse_args()
    return cast(Args, args)


def main():
    args = parse_args()
    dataset = pd.read_csv(args.file_in, header=0, delimiter=',')
    dataset = dataset.groupby(['language', 'runtime']).aggregate(np.median)
    dataset.to_csv(args.file_out)


if __name__ == '__main__':
    main()
