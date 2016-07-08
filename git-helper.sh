#!/bin/bash

# Prints the name of the current local branch.
function git_current_branch {
    # "git branch" prints a list of local branches, the current one being marked with a "*". Extract it.
    echo "`git branch | grep '*' | sed 's/* //'`"
}

# Prints the name of the remote branch (subversion trunk, branch or tag) tracked by the current local branch.
function git_current_remote_branch {
    # This is the current remote URL corresponding to the local branch
    current_url=`git svn info --url`
    # Obtain the URL parts corresponding to the base repository address, and the prefixes for the trunk, the branches, and the tags
    base_url=`git config --list | grep "svn-remote.svn.url" | cut -d '=' -f 2`
    trunk_url=$base_url/`git config --list | grep "svn-remote.svn.fetch" | cut -d '=' -f 2 | sed 's/:.*//'`
    branches_url=$base_url/`git config --list | grep branches | sed 's/.*branches=//' | sed 's/*:.*//'`
    tags_url=$base_url/`git config --list | grep tags | sed 's/.*tags=//' | sed 's/*:.*//'`
    # Check if the current URL matches the trunk URL
    if [ $trunk_url == $current_url ]; then
        if [ "$1" == "-s" ]; then
            echo "trunk"
        else
            echo "You are on trunk"
        fi
    # ...or has the branches URL as a prefix
    elif [ `echo $current_url | grep $branches_url` ]; then
        # Escape / in order to use the URL as a regular expression in sed
        escaped_prefix=`echo $branches_url | sed 's/\//\\\\\//g'`
        if [ "$1" == "-s" ]; then
            echo `echo $current_url | sed "s/$escaped_prefix//"`
        else
            echo You are on branch `echo $current_url | sed "s/$escaped_prefix//"`
        fi
    # ...or has the tags URL as a prefix
    elif [ `echo $current_url | grep $tags_url` ]; then
        # Escape / in order to use the URL as a regular expression in sed
        escaped_prefix=`echo $tags_url | sed 's/\//\\\\\//g'`
        if [ "$1" == "-s" ]; then
            echo `echo $current_url | sed "s/$escaped_prefix//"`
        else
            echo You are on tag `echo $current_url | sed "s/$escaped_prefix//"`
        fi
    else
        if [ "$1" == "-s" ]; then
            echo "unknown"
        else
            echo "You are on an unknown remote branch"
        fi
    fi
}

# Merge the changes from the current branch into another branch (either an existing local branch or a remote branch) and
# commit them to the remote server. After that, switch back to the original branch.
function git_svn_transplant_to {
    current_branch=`git_current_branch`
    git checkout $1 && git merge $current_branch && git svn dcommit && git checkout $current_branch
}

function elementExists() {
	if [ -z "$1" ]
	then
		return
	fi

	for i in ${excluded[@]}
	do
		if [ $i == $1 ]
		then
		return 1
		fi
	done

	return 0
}


function git_check_methods {

	# set input field separator $IFS to end-of-line
	ORIGIFS=$IFS
	IFS=`echo -en "\n\b"`

	if [ $1 == '-u' ]
	then
		unused=1;
		file=$2
	else
		unused=0;
		file=$1
	fi

	excluded=( __construct __destruct initialize select update delete setId getId)

	for i in `egrep -o "function [A-Za-z0-9_]+\(" $file | awk '{print $2}' | sed 's/($//'`
	do
		runGrep=1;
		for j in ${excluded[@]}
		do
			if [ $i == $j ]
			then
				runGrep=0;
			fi
		done

		lines='';
		countLines=0

		if [ $runGrep -eq 1 ]
		then
			for line in `git --no-pager grep -i "$i("`
			do
				let "countLines += 1";
				lines="${lines}\n${line}";
			done

			if [ $unused -eq 1 -a $countLines -eq 1 -o $unused -eq 0 ]
			then
				echo; echo; echo $i;
				echo "------------------------------------";
				echo -e $lines;
			fi
		fi
	done

	# reset IFS
	IFS=$ORIGIFS

}


function git_search_replace {
	for i in `git grep -il "$1"`
	do
		echo $i;
		sed -i "s/$1/$2/g" $i
	done
}

function git_pick() {
	~/bin/git_pick $1 $2
}
