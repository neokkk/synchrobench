#!/bin/bash

###
# This script runs synchrobench c-cpp with different data structures
# and synchronization techniques as 'benchs' executables, with thread
# counts 'threads', initial structure sizes 'sizes', update ratio 'updates'
# sequential benchmarks 'seqbenchs', dequeue benchmarks 'deqbenchs' and 
# outputs the throughput in separate log files 
# './log/${bench}-n${thread}-i${size}-u${upd}.${iter}.log'
#
# Select appropriate parameters below
#
threads="1 4 16 24"
benchs="lockfree-nohotspot-skiplist"
iterations="1"
updates="25 75"
sizes="64 65536 2097152"
ranges="128 1280000"
###

# set a memory allocator here
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# path to binaries
bin=./bin

if [ ! -d "./log" ]; then
  mkdir ./log	
fi

for size in ${sizes}; do
  for range in ${ranges}; do
    if [ ${range} -lt ${size} ]; then
      continue
    fi
    for upd in ${updates}; do
      for thread in ${threads}; do
        for iter in ${iterations}; do
          for bench in ${benchs}; do 
            ${bin}/${bench} -u ${upd} -i ${size} -r ${range} -d 5000 -t ${thread} -f 0 > ./log/${bench}-n${thread}-r${range}-i${size}-u${upd}.${iter}.log
          done
          echo "Done experimenting concurrent benchs for 5000 milliseconds each"
        done
      done
    done
  done
done
