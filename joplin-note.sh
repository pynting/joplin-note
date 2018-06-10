#!/bin/bash
defbook="unsorted"
helpstring="usage: ./joplin-note.sh [-h] [-s] [-f] [-b notebook_name] [+<tag>] note_title note description [+<tag>]...
    -h                  This help text.
    -s                  Syncs after your note entry.
    -f                  Silent mode, does not return anything unless some error occur
                        and simply creates a notebook if the one specified does not exist.
    -b <notebook_name>  Specify a notebook to add the note to (default is \"$defbook\").
                        It will ask you wheter you would like to create a new book if it 
                        does not already exist.
    +<tag>              Add tags anywhere by starting the tag with a plus sign.
                    "


syncornot=0
silentmode=0
while getopts ":hsfb:" opt; do
  case $opt in
    h)
      printf '%s\n' "$helpstring"
      exit 0
      ;;
    s)
      syncornot=1
      ;; 
    f)
      silentmode=1
      ;;    
    b)
      defbook=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      printf '\n%s\n' "$helpstring"
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))
#echo "after shift $@"
array=( "$@" )
tags=( )

for (( i=0; i<${#array[@]}; i++ )) do
     if [ $(echo ${array[$(echo $i)]} | cut -c1 -) = "+" ]
     then
         #echo "${array[$i]:1} is a tag"
         tags=("${tags[@]}" ${array[$i]:1})
         unset array[$i]
   fi
done
array=( "${array[@]}" )
#echo "after tags removed ${array[@]}"
if [ $# != 0 ]
then
    notetitle="${array[0]}"
elif [ $syncornot = 1 ]
    then
    if [ $silentmode = 1 ]
    then
        joplin sync > /dev/null
    else
        joplin sync
    fi
    exit 0
else
    printf "ERROR: No data entered. try -h for usage examples"
    exit 1 # terminate and indicate error
fi

tmpfile=$(mktemp /tmp/$notetitle.XXXXXXXXXXXX)

echo "${array[@]:1}" >> $tmpfile
if [ $silentmode = 0 ]
then
    echo "Note title: $notetitle"
    echo "Note desc: $(cat $tmpfile)"
fi

bookCheck="$(joplin use $defbook | cut -c1-6 -)x"
if [ $bookCheck = "Cannotx" ]
    then
    if [ $silentmode = 1 ]
    then
        joplin mkbook $defbook > /dev/null
    else
        echo -n "Notebook $defbook not found, create it? [y/n]: "
        read ans
        if [ $ans = "y" ]
            then
            joplin mkbook "$defbook"
        else
            echo "OK... exiting."
            exit 0
        fi
    fi
elif [ $bookCheck = "x" ]
    then    
    if [ $silentmode = 0 ]
    then
        echo "Added to notebook: $defbook"
    fi
fi

if [ $silentmode = 1 ]
then
    joplin import --format md $tmpfile $defbook > /dev/null
else
    joplin import --format md $tmpfile $defbook
fi

rm $tmpfile

if [ -n "$tags" ]; then
    noteCode=$(joplin ls -l | head -1 | cut -c1-5)
    if [ $silentmode = 0 ]
    then
        echo "Tags added: ${tags[@]}"
    fi
    for i in "${tags[@]}"; do
    #echo $i
    joplin tag add $i $noteCode
    done
fi



if [ $syncornot = 1 ]
    then
    if [ $silentmode = 1 ]
    then
        joplin sync > /dev/null
    else
        joplin sync
    fi
fi
exit 0
