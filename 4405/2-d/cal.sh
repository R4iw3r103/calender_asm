#!/bin/bash

file="ncal-main.c div10.s divsub.s modsub.s monthlen.s monthwoffset.s mk1cal.s pdec.s pch.s"

gcc $file -o cal
./cal $1 $2 $3
rm ./cal
