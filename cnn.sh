#!/bin/bash

set -x

export ONEDNN_VERBOSE=0

if [[ -z "${DL_BENCH_ARGS}" ]]; then
  echo "Please, provide DL_BENCH_ARGS environment variable"
  exit 1
fi

CNNS=(vgg16 resnet18 resnet50 resnext50 resnext101 densenet121 mobilenet_v3l)
for DTYPE in float32 bfloat16
do
  for BS in 0001 0032 0128
  do
      for name in "${CNNS[@]}"
      do
          echo "Benchmark $name with BS=$BS and DTYPE=$DTYPE"
          benchmark-run -b cnn -p "name='${name}',batch_size='$BS'" --dtype "${DTYPE}" --benchmark_desc "${name}_bs$BS" ${DL_BENCH_ARGS} || echo Failed
      done
  done
done
