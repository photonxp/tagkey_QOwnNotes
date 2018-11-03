#!/bin/bash


spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/testf.bashlib

opt="-o"

sed_line_tag(){
    tag_line="$1"
    fpath="$2"
    sed -r "3s/^.*$/$tag_line/" -i "$fpath"
}

test1(){
    fname1="200-earthquakes-detected-yellowstone..2018-02-21T19.09.09.md"
    fpath1=$dir_data/$fname1
    fname2="115-million-year-old-theropod-footprint-vandalised-australia-dinosaur-dreaming..2017-12-21T17.51.23.md"
    fpath2=$dir_data/$fname2
    fname3="50g宁夏生甘草茶2018-05-14T20.25.21.md"
    fpath3=$dir_data/$fname3
    fname4="Clues_to_decode_a_Holocene_Mystery..2018-01-18T16.15.28.md"
    fpath4=$dir_data/$fname4
    fname5="2017 P&G Championships - Women - Day 2 - NBC Broadcast..2018-01-11T17.33.58.md"
    fpath5=$dir_data/$fname5
    sed_line_tag "bb vocabulary sciencealert" "$fpath1"
    sed_line_tag "vocabulary bb sciencealert" "$fpath2"
    sed_line_tag "中草药 甘草 bb" "$fpath3"
    sed -r "3s/^tag:: (.*)$/\1/" -i "$fpath4"
    sed_line_tag "vocabulary sciencealert" "$fpath5"
    "$script_add_tagkey" "$fpath_taglist" "$dir_data"
    head "$fpath1"
    head "$fpath2"
    head "$fpath3"
    head "$fpath4"
    head "$fpath5"
}

test2(){
    fname="Clues_to_decode_a_Holocene_Mystery..2018-01-18T16.15.28.md"
    fpath=$dir_data/$fname
    sed -r "3s/^tag:: (.*)$/\1/" -i "$fpath"
    head "$fpath"
    "$script_add_tagkey" "$fpath_taglist" "$dir_data"
    head "$fpath"
}

test3(){
    dir_data=./data/Notes.sample.1.test
    fname="200-earthquakes-detected-yellowstone..2018-02-21T19.09.09.md"
    fpath=$dir_data/"$fname"
    "$script_add_tagkey" "$fpath_taglist" "$dir_data"
    head "$fpath"
}

"$swd"/prepare_data_for_test.bash
fpath_taglist="$swd"/../tag_list.txt
dir_data="$swd"/../data/Notes.sample.1.test
script_add_tagkey="$swd/../add_tagkey_in_dir.bash"

run_tests "test1"
#run_tests "test2"
#run_tests "test3"


