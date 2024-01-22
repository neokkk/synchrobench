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
threads="24"
benchs="lockfree-nohotspot-skiplist"
seqbenchs=""
iterations=""
for i in `seq 1 1 5`; do # 1..5 with step 1
  iterations="$iterations $i"
done
updates=""
for i in `seq 0 5 100`; do # 0..100 with step 5
  updates="$updates $i"
done
sizes="5000"
deqbenchs=""
###

# set a memory allocator here
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# path to binaries
bin=./bin

if [ ! -d "./log" ]; then
  mkdir ./log	
fi

for size in ${sizes}; do
  # make the range twice as large as initial size to maintain size expectation 
  r=`echo "2*${size}" | bc`
  for upd in ${updates}; do 
    for thread in ${threads}; do
      for iter in ${iterations}; do
        for bench in ${benchs}; do 
          ${bin}/${bench} -u ${upd} -i ${size} -r ${r} -d 5000 -t ${thread} -f 0 > ./log/${bench}-n${thread}-i${size}-u${upd}.${iter}.log
        done
        echo "Done experimenting concurrent benchs for 5000 milliseconds each"
      done
    done
  done
done

# for sequential
for size in ${sizes}; do
  r=`echo "2*${size}" | bc`
  for upd in ${updates}; do 
    for iter in ${iterations}; do
      for bench in ${seqbenchs}; do 
        ${bin}/${bench} -u ${upd} -i ${size} -r ${r} -d 5000 -t 1 -f 0 > ./log/${bench}-i${size}-u${upd}-sequential.${iter}.log
      done
    done
  done
done

# for dequeue
for upd in ${updates}; do 
  for thread in ${threads}; do
    for iter in ${iterations}; do
      for bench in ${deqbenchs}; do
      ${bin}/${bench} -i 128 -r 256 -d 5000 -t ${thread} > ./log/${bench}-n${thread}.${iter}.log
      done
    done
  done
done

# for the lock-coupling linked list
#benchs="tcmalloc-spinlock-ll tcmalloc-spinlock-ht"
benchs=""
for size in ${sizes}; do
 r=`echo "2*${size}" | bc`
 for upd in ${updates}; do 
  for thread in ${threads}; do
   for iter in ${iterations}; do
    for bench in ${benchs}; do 
      ${bin}/${bench} -x2 -u ${upd} -i ${size} -r ${r} -d 5000 -t ${thread} -f 0 > ./log/${bench}-n${thread}-i${size}-u${upd}-lazy.${iter}.log
    done
   done
  done
 done
done
