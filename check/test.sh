#!/bin/bash
echo "Hello World"

export VAR="check"
#check file abc.txt exist and not empty, then print huhuhu
[ -s "abc.txt" ] && echo "huhhuuh"