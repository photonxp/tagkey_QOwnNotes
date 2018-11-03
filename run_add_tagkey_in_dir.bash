#!/bin/bash

# use opt=-o to overwrite the check on test dir

spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/test/testf.bashlib

opt="-o"

test1(){
    "$swd"/add_tagkey_in_dir.bash "$fpath_taglist" "$dpath_data"
}

fpath_taglist="$swd"/tag_list.txt
dpath_data="$swd"/data/Notes.sample.1.test

run_tests "test1"


