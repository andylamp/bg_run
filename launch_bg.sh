#!/usr/bin/env bash

# globals
parent_dir="~/"

## beautiful and tidy way to expand tilde (~) by C. Duffy.
expandPath() {
  case $1 in
    ~[+-]*)
      local content content_q
      printf -v content_q '%q' "${1:2}"
      eval "content=${1:0:2}${content_q}"
      printf '%s\n' "$content"
      ;;
    ~*)
      local content content_q
      printf -v content_q '%q' "${1:1}"
      eval "content=~${content_q}"
      printf '%s\n' "$content"
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}

## background launch
function bg_launch {

    ## now get the correct path
    parent_dir=$(expandPath ${parent_dir})

    if [[ $# = 0 ]]; then
        echo "Error -- no argument received, expected: cmd [stdout redir] [stderr redir] [pid kill loc]";
        exit 1;
    elif [[ $# = 1 ]]; then
        echo "Warning -- One argument received, stdout at: ~/out.log, stderr at: ~/err.log, kill pid at: ~/pid.kill";
        $1 1> ${parent_dir}/out.log 2> ${parent_dir}/err.log &
        #pid=$!
        echo "$!" > ${parent_dir}/pid.kill
    elif [[ $# = 2 ]]; then
        stdout_exp=$(expandPath $2)
        echo "Warning -- Two argument received, stdout at: $stdout_exp, stderr at: ~/err.log, kill pid at: ~/pid.kill";
        $1 1> ${stdout_exp} 2> ${parent_dir}/err.log &
        #pid=$!
        echo "$!" > ${parent_dir}/pid.kill
    elif [[ $# = 3 ]]; then
        stdout_exp=$(expandPath $2)
        stderr_exp=$(expandPath $3)
        echo "Three argument received, stdout at: $stdout_exp, stderr at: $stderr_exp, kill pid at: ~/pid.kill";
        $1 1> ${stdout_exp} 2> ${stderr_exp} &
        #pid=$!
        echo "$!" > ${parent_dir}/pid.kill
    elif [[ $# = 4 ]]; then
        stdout_exp=$(expandPath $2);
        stderr_exp=$(expandPath $3);
        pidkill=$(expandPath $4);
        echo "Three argument received, stdout at: $stdout_exp, stderr at: $stderr_exp, kill pid at: $pidkill";
        $1 1> ${stdout_exp} 2> ${stderr_exp} &
        #pid=$!
        echo "$!" > ${pidkill}
    else
        echo "Error -- too many arguments received...";
        exit 1;
    fi
    echo "Launching background command: $1";
}

## background kill (only after launch)
function bg_kill {
    ## now get the correct path
    parent_dir=$(expandPath ${parent_dir})
    if [[ $# = 0 ]]; then
        echo "Warning -- no argument supplied, trying default loc: ~/pid.kill"
        if [ ! -f ${parent_dir}/pid.kill ]; then
            echo "pid.kill not found in default location, bye!";
        else
            kill $(cat ${parent_dir}/pid.kill)
            echo "pid.kill found, process terminated if exists";
        fi
    elif [[ $# = 1 ]]; then
        echo "File location given is: $1"
        if [ ! -f $1 ]; then
            echo "No valid file found in specified location, bye!";
        else
            kill $(cat $1)
            echo "File found, process terminated if exists";
        fi
    fi
    echo "This script DOES NOT automatically remove pid.kill file, remove it yourself!";
    #return
}