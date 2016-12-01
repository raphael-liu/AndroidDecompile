#!/bin/bash

if [ ! -d dest ];then
    echo mkdir dest
    mkdir dest
else
    echo dest exist
fi

read -p 反编译"dest"目录下所有的apk文件资源/源码?[s]:源码[r]:资源[b]:源码+资源. choice

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
    echo 请再次确认是否已将需要反编译的apk拷贝至dest目录下?
fi
