#!/bin/bash
SEARCHTEXT="TODO"
ROOT=$(git rev-parse --show-toplevel)
FILE="todo.md"

while getopts "ohf:t:" option; do
    case $option in
        'o' )
            STDOUT=true
        ;;
        'h' )
            echo "$(basename $0) - generate a todo file based on your code"
            echo "---"
            echo "  -h - display this help"
            echo "  -o - print output to STDOUT"
            echo -n "  -f - write to this file (defaults to todo.md and path "
            echo "starts at the repo's root)"
            echo "  -t - text to search for (defaults to TODO)"
            exit
        ;;
        'f' )
            FILE=$OPTARG
        ;;
        't' )
            SEARCHTEXT=$OPTARG
        ;;
    esac
done

OUTFILE="$ROOT/$FILE"
if [ -z $STDOUT ]; then
    exec 1>$OUTFILE
fi

echo "## To Do"

current_file=''
IFS=$'\r\n' tasks=($($(which git) grep -In --full-name $SEARCHTEXT $ROOT | grep -v $FILE))
# -n - include line numbers
# --full-name - the full path (starting from the repo root)

for task in ${tasks[@]}; do
    file=$(echo $task | cut -f1 -d':')
    line=$(echo $task | cut -f2 -d':')
    item=$(echo $task | cut -f3- -d':' | sed "s/.*$SEARCHTEXT *//g")

    if [[ $file != $current_file ]]; then
        if [ $current_file ]; then
            echo
        fi
        current_file=$file
        echo "### \`\`$current_file\`\`"
    fi
    echo "(line $line) $item"
    echo
done

echo "######Generated using [todo.md](https://github.com/charlesthomas/todo.md)"
