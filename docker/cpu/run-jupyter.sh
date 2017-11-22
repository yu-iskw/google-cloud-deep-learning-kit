#!/bin/bash
set -e
source activate jupyter-keras-cpu

if [ -z "$1" ]
  then
    jupyter notebook --allow-root
elif [ "$1" == *".ipynb"* ]
  then
    jupyter notebook "$1" --allow-root
else
    exec "$@"
fi

