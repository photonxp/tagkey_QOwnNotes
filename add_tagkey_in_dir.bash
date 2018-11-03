#!/bin/bash

# Intelligent institutes are all alike
#     every unintelligent institute 
#     is unintelligent in its own way."
#                           -- Colscoy

get_line_tag(){
    tagval="$1"
    fpath="$2"
    # unable to check $? for this gawk
    line_tag=$(gawk -v ptn="$tagval([[:space:]]|$)" '$0~ptn && NR >= 3 && NR <= 5 {print NR":"$0;exit;}' "$fpath")
    #echo "line_tag: $line_tag"
}

check_is_target_line_tag(){
    # return 0: is target tagline;
    # return 1: is NOT target tagline;

    line_tag="$1"

    # check "" line_tag result
    # gawk won't add line num to unmatched result
    if [ "y" == "y$line_tag" ]
        then
        return 1
    fi

    # check "tag:" part in line_tag
    printf "$line_tag" | grep -q 'tag:'
    retval_grep=$?
    if [ 0 -eq $retval_grep ]
        then
        return 1
    fi
    
    taglist_inline="$(echo ${line_tag##*:})"
    #echo "taglist_inline:" $taglist_inline

    arr_taglist_inline=($taglist_inline)
    length_arr_taglist_inline=${#arr_taglist_inline[@]}
  
    if [ 1 -eq $length_arr_taglist_inline ]
        then
        return 0
    fi
    
    match_tag_inline_to_infile(){
        tag_inline=$1
                
        flag_matched=1
        for tag_infile in "${arr_taglist_infile[@]}"
            do
            if [ "$tag_infile" == "$tag_inline" ]
                then
                flag_matched=0
                break
            fi
        done
    }

    match_first_2_tags_to_tagfile(){
        # 0: all tags are matched in tag file
        # 1: a tag is not matched in tag file

        flag_tagline=0
        for i in `echo 0 1`
            do
            match_tag_inline_to_infile ${arr_taglist_inline[$i]}
            if [ 1 -eq $flag_matched ]
                then
                flag_tagline=1
                break
            fi
        done
    }
    
    if [ 2 -le $length_arr_taglist_inline ]
        then
        match_first_2_tags_to_tagfile
        return $flag_tagline
    fi
}

add_tagkey_to_file(){
    fpath="$1"
    
    for tag_infile in "${arr_taglist_infile[@]}"
        do
        get_line_tag "$tag_infile" "$fpath"
        line_num="${line_tag%%:*}"
        check_is_target_line_tag "$line_tag"
        retval=$?
        #echo "line_tag:" $line_tag "retval: " $retval
        if [ 0 -eq $retval ]
            then         
            line_filter="$line_num"
            tagkey="tag:: "
            substitute_operation="s/(^.*$)/$tagkey\1/"
            sed_directive="$line_filter $substitute_operation"
            sed -r "$sed_directive" -i "$fpath"
            break
        fi
    done
}

main(){
    fpath_taglist="$1"
    dpath_data="$2"

    mapfile -t arr_fpath_list < <(find "$dpath_data" -maxdepth 1 -type f)
    mapfile -t arr_taglist_infile < <(cat "$fpath_taglist")

    for fpath in "${arr_fpath_list[@]}"
        do
        add_tagkey_to_file "$fpath"
    done
}

main "$@"


