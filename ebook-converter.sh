#!/bin/bash

## TODO:
# remove spaces from filenames and dir names
#   https://stackoverflow.com/questions/2709458/how-to-replace-spaces-in-file-names-using-a-bash-script
# change the iteration code so that it doesnt use a a pipe (so that all runs in same process)
# generate a logfile
# generate a list of all books?

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
CREDIT="Janis Selis 2019.07.17"
VERSION="0.1.0"
DESCRIPTION="This is a book manager script for pdf, epub, mobi files. Uses calibre-convert for conversion"
SCRIPT_NAME="$(basename ${0})"
LOGFILENAME="log-$TIMESTAMP"

# text colors:
default="\033[0;00m"
blue="\033[1;34m"
green="\033[1;32m"
purple="\033[1;35m"
white="\033[1;37m"
red="\033[1;31m"
navy="\033[1;36m"

FINDDIR=$(pwd)
DELFILES=False
SPACEDASH=False
LOGFILE=False



#== usage functions ==#
usage() { 
    echo -e " SYNOPSIS"
    echo -e "    ${SCRIPT_NAME} [-hv] [-o[file]] args ..."
    echo -e ""
    echo -e " DESCRIPTION"
    echo -e "    $DESCRIPTION"
    echo -e ""
    echo -e " OPTIONS"
    echo -e "    -o \t\t  Set operation directory (default=pwd)"
    echo -e "    -f \t\t  Find files of type e.g. pdf, mobi, ebub, etc.."
    echo -e "    -c \t\t  Convert to filetype e.g. pdf, mobi, ebub, etc.."
    echo -e "    -d \t\t  Delete found file"
    echo -e "    -l \t\t  Create log file in the operation directory"
    echo -e "    -s \t\t  Replace spaces ' ' in filenames with dashes '-'"
    echo -e ""
    echo -e "    -x \t\t  Ignore if lock file exists"
    echo -e "    -h \t\t  Print this help"
    echo -e "    -v \t\t  Print version"
    echo -e ""
    echo -e " EXAMPLES"
    echo -e "    ${SCRIPT_NAME} -o library/unsorted -f epub -c pdf"
  }

# --- Options processing -------------------------------------------

if [ $# == 0 ] ; then
    usage
    exit 1;
fi

echo -e ""

while getopts ":o:f:c:ldsxhv" optname
  do
    case "$optname" in
    "o")FINDDIR=$OPTARG;;
    "f")FINDTYPE=$OPTARG;;
    "c")CONVTYPE=$OPTARG;;
    "s")SPACEDASH=$OPTARG;;
    "d")DELFILES=True;;
    "l")LOGFILE=True;;
    "v")
        echo "Version $VERSION"
        echo "$CREDIT"
        exit 0;
        ;;
    "h")
        usage
        exit 0;
        ;;
    "?")
        echo "error -$OPTARG: unknown option"
        exit 0;
        ;;
    ":")
        echo "error -$OPTARG: option requires an argument"
        exit 0;
        ;;
    *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

echo -e " - Operation directory set to: \t $green $FINDDIR $default"
echo -e " - Searching for filetype: \t $green $FINDTYPE $default"
echo -e " - Converting to filetype: \t $green $CONVTYPE $default"
echo -e " -$red Delete converted files: \t  $DELFILES $default"
echo -e " - Create a log in directory: \t $green $LOGFILE $default"

# --- Locks -------------------------------------------------------
# LOCK_FILE=/tmp/$SUBJECT.lock
# if [ -f "$LOCK_FILE" ]; then
#    echo "Script is already running"
#    exit
# fi

# trap "rm -f $LOCK_FILE" EXIT
# touch $LOCK_FILE

# ------------------------    MAIN BODY   -------------------------

echo -e ""
while true; do
    read -p "PROCEED?  (Y/N) " yn
    case $yn in
        [Yy]* ) 
            break;;
        [Nn]* )
            echo "Exiting..." 
            exit;;
        * ) echo "Please input y or n and press return";;
    esac
done


FILESFOUND=0
FILESCONVERTED=0
FILESDELETED=0

# ( cd books && for file in *.epub; do calibre-convert "$file" "${file%epub}pdf"; done )

echo ""
echo "Searching..."

#FILES=$(find $FINDDIR -type f -name *.$FINDTYPE)

find $FINDDIR -type f -name *.$FINDTYPE -print0 |
while IFS= read -r -d '' file; do 
    # printf '%s\n' "$file"
    echo -e " - $navy Found: \t $default $file";
    # ((FILESFOUND+=1));
    if [[ $SPACEDASH == True ]]; then
        #newfile = #rename it
        #file = $newfile # so that same var can be used even if this function was not called
        echo -e " - $purple Renamed: \t $default $file";
        # catch errors
        # ((FILESDELETED++));
    fi
    if [[ $CONVTYPE ]]; then
        #ebook-convert "$file" "${file%$FINDTYPE}$CONVTYPE";
        echo -e " - $green Created: \t $default ${file%$FINDTYPE}$CONVTYPE";
        # catch errors
        # ((FILESCONVERTED++));
    fi

    if [[ $DELFILES == True ]]; then
        #rm -f $file
        echo -e " - $red Deleted: \t $default $file";
        # catch errors
        # ((FILESDELETED++));
    fi
    
done


# -----------------------    end script    ------------------------

echo -e ""
echo -e "REPORT:"
echo -e " - Identified \t $green $FILESFOUND $default $FINDTYPE files"
echo -e " - Converted \t $green $FILESCONVERTED $default files to $CONVTYPE"
echo -e " - Deleted \t $green $FILESDELETED $default files"
echo -e " - Logfile: \t $green $FINDDIR$LOGFILENAME $default"
echo -e ""

exit
