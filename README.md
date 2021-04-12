# Ebook bulk converter

## Purpose

This script searches through a specified directory and it's subdirectories for any valid ebooks with the specified extension and converts them to any other desired format. You have the option to keep or delete the original files and replace spaces with "-" to make things run smoother across systems.


It is very useful for bulk conversion where you want to convert your whole library to EPUB so that you can read it on your phone or just to keep all books in the same file format.

<br/>

## Usage

1. Make sure that the Calibre's "ebook-convert" is installed and on path. Get it from [Calibre download page](https://calibre-ebook.com/download)
2. Save this shell script to any location on your hard drive. I recommend the root folder of your book library or in the new downloads directory.
3. Then make the script executable by running ```chmod +x ./ebook-converter.sh```.


```
    SYNOPSIS
       ./ebook-converter.sh [-hv] [-o[dir]] args ...

    DESCRIPTION
       This is a book manager script for pdf, epub, mobi files. Uses calibre-convert for conversion

    OPTIONS

       -h  Print this help
       -v  Print version

       -o  Set operation directory (default=pwd)
       -f  Find files of type e.g. pdf, mobi, ebub, etc..
       -c  Convert to filetype e.g. pdf, mobi, ebub, etc..
       -d  Delete found file
       -l  Create log file in the operation directory
       -s  Replace spaces ' ' in filenames with dashes '-'

       -x  Ignore if lock file exists
```
