#!/bin/bash
echo "Hello World"

export VAR="check"
[ -s "abc.txt" ] && echo "huhhuuh"  #check file abc.txt exist and not empty, then print huhuhu