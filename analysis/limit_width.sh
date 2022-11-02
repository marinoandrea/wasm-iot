#!/bin/bash
sed -i 's/\\begin{tabular}/\\resizebox{\\columnwidth}{!}{\\begin{tabular}/' $1
sed -i 's/\\end{tabular}/\\end{tabular}}/' $1
