todo.md
-------

Generate a todo.md file based on TODO comments in your git repo.

Add as a git hook to automatically update the todo.md file every time you commit!

Usage
=====

    todo.md.sh - generate a todo file based on your code
      -h - display this help
      -l - LIVE MODE this will add the generated file to your staged changes.
           Use this in the git hook. Off by default for playing around in the terminal
      -o - print output to STDOUT
      -f - write to this file (defaults to todo.md and path starts at the repo's root)
      -t - text to search for (defaults to TODO)

Examples
========

## Vanilla
	todo.md.sh
Finds all records matching "TODO" **(always case insensitive)**, and generates a file in the repo root titled ``todo.md``. Does ***NOT*** add this file to your repo's staged changes.

## Different Search Term
	todo.md.sh -t FIXME
Finds all records matching "FIXME" **(still case insensitive)**, and generates a file called ``todo.md``.

## Print to Screen
	todo.md.sh -o
Finds all records matching "TODO" and prints to ``STDOUT``.

## Custom File
	todo.md.sh -f please_fix_me.txt
Finds all records matching "TODO" and writes them to the repo root in a file named ``please_fix_me.txt``. You can also provide a path here, and it will write to that path, starting from the repo root. IE ``todo.md.sh -f static/todo.md`` will write the output to a file called ``$repo_root/static/todo.md``.

## LIVE MODE
	todo.md.sh -l
Finds all "TODO" records, writes them to todo.md, **and stages todo.md for the next **``git commit``.

## LIVE MODE + STDOUT
	todo.md.sh -o -l
This will print a message to ``STDERR`` telling you this doesn't work, and ignores LIVE MODE, running as if only ``-o`` was passed. To reiterate: using ``-o`` and ``-l`` ***will not*** stage anything.

Adding the git hook
===================

If you want this file to be auto-generated every time you commit, add this to ``.git/hooks/pre-commit``:

	path/to/todo/script/todo.md.sh -l

You can pass any options **other than -o and -h** to this command. However, if you want the todo.md file itself to be inclued in the commit automatically, you **must** include ``-l`` (and **not** ``-o``).

### You probably don't want to do this for HUGE repos, or it will significantly slow down the amount of time it takes to run ``git commit``.

### Make sure ``todo.md.sh`` has executable permissions or it won't work inside the hook.