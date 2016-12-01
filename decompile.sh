#!/bin/bash

if [ ! -d dest ];then
    echo mkdir dest
    mkdir dest
else
    echo dest exist
fi

read -p Decompile the apk files of dest directory?[s]ource,[r]esource,[b]oth. choice

source=false
resource=false

if [ $choice = b ];then
    source=true
    resource=true
elif [ $choice = r ];then
    resource=true
else
    source=true
fi

cd dest
count=0

for file in `ls`
do
    if [ ${file##*.} = apk ];then
        let count++
        echo ${count}: ${file} ————————————————————————————————————————————————
        root=${file%.*}
        if [ $resource = true ];then
            ../library/apktool d -f $file
        fi
        if [ $source = true ];then
            unzip $file classes.dex -d $root
            cd $root
            sh ../../library/dex2jar-2.0/d2j-dex2jar.sh classes.dex
            rm classes.dex
            open -a jdgui classes-dex2jar.jar
            cd -
        fi
    else
        echo $file is not a apkfile.suffix:${file##*.}
    fi
done

if [ $count -eq 0 ];then
    echo Make sure the apk files are in the dest directory!
fi
