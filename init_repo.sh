#!/bin/bash
# This should be run the first time you generate a todo.md file. It greps
# through the entire repo, so it may take a LONG time to run, depending on the
# size of your repo

echo "Are you in the root of your repo? (y/n)"
read advance

if [[ $advance != 'y' ]] && [[ $advance != 'Y' ]] && [[ $advance != 'yes' ]]; then
    echo -n "You should run this from the root of your repo, or you will "
    echo -n "either TODO items or you will include TODO items from outside "
    echo    "your repo"
    exit 1
fi

echo "## To Do" > todo.md

current_file=''
IFS=$'\r\n' tasks=($($(which git) grep -Iin --full-name TODO))
# -I - don't search binary files
# -i - ignore case
# -n - include line numbers
# --full-name - the full path (starting from the repo root)

for task in ${tasks[@]}; do
    file=$(echo $task | cut -f1 -d':')
    line=$(echo $task | cut -f2 -d':')
    item=$(echo $task | cut -f3- -d':' | sed s/.*TODO//g)

    if [[ $file != $current_file ]]; then
        if [ $current_file ]; then
            echo >> todo.md
        fi
        current_file=$file
        echo "### \`\`$current_file\`\`" >> todo.md
    fi
    echo "(line $line) $item" >> todo.md
    echo >> todo.md
done

echo "######Generated using [todo.md](https://github.com/charlesthomas/todo.md)" >> todo.md
