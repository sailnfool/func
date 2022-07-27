#!/bin/bash
file1=/tmp/tmpfile1_$$.txt
cat > ${file1} <<EOF1
00a abc
00b def
00c ghi
EOF1
file2=/tmp/tmpfile2_$$.txt
cat > ${file2} <<EOF2
00d jkl
00e mno
00f pqr
EOF2
file3=/tmp/tmpfile3_$$.txt
cat > ${file3} <<EOF3
000 rst
001 uvw
002 xyz
EOF3

declare -A assoc1
declare -A assoc2
declare -A assoc3

for i in 1 2 3
do
  eval filename=/tmp/tmpfile${i}_$$.txt
  echo "filename=${filename}"
  while read key value
  do
    echo "filename=${filename}, key=${key}, value=${value}"
    eval assoc${i}+=\(["${key}"]="${value}"\)
  done < ${filename}
  declare -n old=assoc${i}
  for nkey in "${!old[@]}"
  do
    echo "old[$nkey]=${old[${nkey}]}"
  done
done
rm -f /tmp/tmpfile?_$$.txt
