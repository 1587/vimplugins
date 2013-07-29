#!/bin/sh
CURRENT_DIR=`pwd`
DB_FILE=~/.vim/vimrc/cscopedb.vimrc
make_cscope () {
    DIR=`pwd`
    find . -name "*.h" -o -name "*.c"  > cscope.files
    if [ $? != 0 ];then
        echo "make $DIR/cscope.files Failed!"
        exit 1
    fi
    cscope -bkq -i cscope.files
    if [ $? != 0 ];then
        echo "make $DIR/cscope.out Failed!"
        exit 1
    fi
    ctags -R
    if [ $? != 0 ];then
        echo "make $DIR/tags Failed!"
        exit 1
    fi
    echo ":cs add $DIR/cscope.out $DIR" >> $DB_FILE
    if [ $? = 0 ];then
        echo "Tag $DIR Successed!"
    else
        echo "Tag $DIR Failed!"
        exit 1
    fi
}

if [ $# = 0 ];then
    make_cscope
else
    for i in $*
    do
        cd $i
        if [ $? = 0 ];then
            make_cscope
            cd $CURRENT_DIR
        fi
    done
fi
