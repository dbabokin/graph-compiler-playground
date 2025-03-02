#!/bin/bash

set -x

export ONEDNN_VERBOSE=0

if [[ -z "${DL_BENCH_ARGS}" ]]; then
  echo "Please, provide DL_BENCH_ARGS environment variable"
  exit 1
fi

# for size in size5_bn_gelu
for DTYPE in float32 bfloat16
do
  echo "DTYPE=${DTYPE}"
  for size in size2 size3 size4 size5 size5_sigm size5_tanh size5_gelu size5_linear size5_inplace size5_bn size5_bn_gelu size5_drop_gelu 100@512 25@1024 4@16384 2@16384
  do
      echo "Benchmark $size"
      benchmark-run -b mlp -p "name='${size}'" --dtype "${DTYPE}" --benchmark_desc "${size}_bs1024" ${DL_BENCH_ARGS} || echo Failed
  done

  size="size5"
  for BATCH_SIZE in 1 16 256 2048 8196
  do
      echo "Batch size $BATCH_SIZE"
      echo "Benchmark $size"
      BATCH_SIZE_TXT=$(printf "%04d" $BATCH_SIZE)
      benchmark-run -b mlp -p "name='${size}',batch_size=${BATCH_SIZE}" --dtype "${DTYPE}" --benchmark_desc "${size}_bs${BATCH_SIZE_TXT}" ${DL_BENCH_ARGS} || echo Failed
  done
done
