#!/bin/bash

NETWORK=$1

DTYPE_OP="bnorm"
DTYPE="fp32"
DTYPE_FLAG=""

if [ -z "$2" ]
then
  DTYPE="fp16"
  DYPE_OP="bnormfp16"
  DTYPE_FLAG="--fp16 1"
fi

LOG_FILE="conf_$NETWORK_$DTYPE.log"
MIOPEN_ENABLE_LOGGING_CMD=1 python micro_benchmarking_pytorch.py --network $NETWORK $DTYPE_FLAG 2>&1 | tee $LOG_FILE
grep $DTYPE_OP $LOG_FILE | awk '{$1=""; $2=""; $3=""; print}' | sed 's/^ *//g' | sort | uniq -c | sort -r | sed 's/^ *//g' | sed -rn 's%(^[0-9]*) %\1;'"${DTYPE_OP}"';%p'
