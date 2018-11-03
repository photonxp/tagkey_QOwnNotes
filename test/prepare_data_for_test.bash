#!/bin/bash


spath=$(realpath "$0")
swd=${spath%/*}

data_dir="$swd"/../data
data_orig=$data_dir/Notes.sample.1.orig
data_test=$data_dir/Notes.sample.1.test

[ -d $data_test ] && rm -r $data_test
cp -r $data_orig $data_test
