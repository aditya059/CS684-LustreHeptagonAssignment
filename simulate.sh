#!/bin/bash
set -eE -o functrace
failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

opam switch 4.03.0
eval $(opam env)
# default values
node='display'
path='node.ept'
while getopts s:h:p: flag
do
    case "${flag}" in
        s) node=${OPTARG};;
        p) path=${OPTARG};;
        h) echo "Specify node with 's' and path of the heptagon file with 'p'.\nDefault is -s display -p node.ept";;
    esac
done

heptc -target c -s $node -hepts $path 
filename="${path##*/}";
filename="${filename%.*}"
filename="${filename,}"
if [[ -z "${filename}" ]]
then echo "Please enter a valid filepath!"; exit 0;
fi

echo $filename"_c/"
cd $filename"_c/"
gcc -Wall -c -I $(heptc -where)/c $filename".c" 
gcc -Wall -c -I $(heptc -where)/c _main.c 
gcc -o $node _main.o $filename".o" 
cd ..
# echo "${node}"
# echo "${filename^}"
hepts -mod "${filename^}" -node $node -exec $filename"_c/"$node
