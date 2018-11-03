#!/bin/bash


spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/testf.bashlib

opt="-o"

init_script_extra(){
    "$swd"/prepare_data_for_test.bash
}

init_test_extra(){
    data_dir="$swd"/../data/Notes.sample.1.test
    fname1="200-earthquakes-detected-yellowstone..2018-02-21T19.09.09.md"
    fpath1=$data_dir/"$fname1"
}

sed_line_tag(){
    tag_line="$1"
    fpath="$2"
    sed -r "3s/^.*$/$tag_line/" -i "$fpath"
}

check_fpath(){
    tagval="$1"
    fpath="$2"
    head "$fpath"
    "$swd"/../check_is_tag_line.bash "$tagval" "$fpath"
}

test1(){
    sed_line_tag "bb vocabulary sciencealert" "$fpath1"
    rslt=$(check_fpath "vocabulary" "$fpath1")
    echo "$rslt"
    assert_in_str "flag_tagline:     1" "$rslt"
}

test2(){
    sed_line_tag "vocabulary bb sciencealert" "$fpath1"
    rslt=$(check_fpath "vocabulary" "$fpath1")
    echo "$rslt"
    assert_in_str "flag_tagline:     1" "$rslt"
}

test3(){
    sed_line_tag "vocabulary sciencealert bb" "$fpath1"
    rslt=$(check_fpath "vocabulary" "$fpath1")
    echo "$rslt"
    assert_in_str "flag_tagline:     0" "$rslt"
}

test4(){
    fname="50g宁夏生甘草茶2018-05-14T20.25.21.md"
    fpath=$data_dir/"$fname"
    sed_line_tag "中草药 甘草 bb" "$fpath"
    rslt=$(check_fpath "中草药" "$fpath")
    echo "$rslt"
    assert_in_str "flag_tagline:     0" "$rslt"
    head "$fpath"
}

test5(){
    fname="Clues_to_decode_a_Holocene_Mystery..2018-01-18T16.15.28.md"
    fpath=$data_dir/"$fname"
    sed -r "3s/^tag:: (.*)$/\1/" -i "$fpath"
    rslt=$(check_fpath "youtube" "$fpath")
    echo "$rslt"
    assert_in_str "flag_tagline:     " "$rslt"
    head "$fpath"
}

run_tests "test1" "test2" "test3" "test4" "test5"
#run_tests "test4"
#run_tests "test5"
