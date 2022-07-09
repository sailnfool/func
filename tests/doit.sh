#!/bin/bash
pushd ~/github/func
make
popd
bash tester.func.hex2binfile.sh -b -f /tmp/saved 2>&1 | tee /tmp/debughex2file.txt

