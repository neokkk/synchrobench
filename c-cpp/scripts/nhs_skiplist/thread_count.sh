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
#threads="1 4 8 12 16 20 24 28 32"
threads="1 4 16 24"
#benchs="tcmalloc-lockfree-ll tcmalloc-spinlock-ht tcmalloc-estm-rt tcmalloc-estm-sl tcmalloc-fraser-sl tcmalloc-rotating-sl tcmalloc-spinlock-ll tcmalloc-estm-ll tcmalloc-estm-st tcmalloc-lockfree-ht tcmalloc-spinlock-sl tcmalloc-estm-ht tcmalloc-spinlock-btree"
benchs="lockfree-nohotspot-skiplist"
#lockfree-fraser-skiplist lockfree-rotating-skiplist lockfree-nohotspot-skiplist SPIN-skiplist"
#seqbenchs="tcmalloc-sequential-ll tcmalloc-sequential-rt tcmalloc-sequential-ht tcmalloc-sequential-sl"
seqbenchs=""
#iterations="1 2 3 4 5 6 7 8 9 10"
iterations="1"
#updates="0 100"
updates="10 50 100"
#size="1024 4096 8192 16384 32768 65536"
sizes="64 65536 2097152"
#range=""
ranges="128 1280000 128000000"
#deqbenchs="estm-dq tcmalloc-estm-dq tcmalloc-sequential-dq"
deqbenchs=""
###

# set a memory allocator here
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
echo "LD_PATH:" $LD_LIBRARY_PATH

# path to binaries
bin=./bin

if [ ! -d "./log" ]; then
	mkdir ./log	
fi

for size in ${sizes}; do
  # make the range twice as large as initial size to maintain size expectation 
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
