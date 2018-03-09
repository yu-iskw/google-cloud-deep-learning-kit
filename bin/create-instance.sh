#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$CUDA_VERSION" == "8"  ] ; then
  # cuda8
  echo "Create an instance with cuda8."
  bash "${SCRIPT_DIR}/create-instance_cuda8.sh" $@
elif [ "$CUDA_VERSION" == "9" ] ||[ "$CUDA_VERSION" == "9.1" ] ; then
  # cuda9
  echo "Create an instance with cuda9."
  bash "${SCRIPT_DIR}/create-instance_cuda9.sh" $@
else
  # error
  echo "invalid"
  echo "Error: Invalid CUDA_VERSION."
  exit 1
fi
