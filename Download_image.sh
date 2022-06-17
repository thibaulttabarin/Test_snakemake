#!/bin/bash

# simple function to check http response code before downloading a remote file
# example usage:
# if `validate_url $url >/dev/null`; then dosomething; else echo "does not exist"; fi

url=$1

function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; 
  then
     echo "true";
  fi
}

function file_size(){
   length=`wget --spider $1 2>&1 | grep Length | awk '{print $2}'`
   echo "$length"
}

function Download_if(){
  if [ $(validate_url $1) = 'true' ]
  then
     if [ $(file_size $1) -gt 100 ]
     then
        wget -O $2 $1
     fi
  fi
}


Download_if $url $2
