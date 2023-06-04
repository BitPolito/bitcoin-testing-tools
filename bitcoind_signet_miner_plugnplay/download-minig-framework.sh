#!/bin/bash

# Set the GitHub repository and subfolder
repo="bitcoin/bitcoin"
subfolder="test/functional/test_framework"
branch="master"

# Set the default output directory to the current directory
output_dir="/bitcoind/test/functional/test_framework"

# parse command line options
while getopts ":r:s:b:d:" opt; do
    case ${opt} in
        r ) repo="$OPTARG"
        ;;
        s ) subfolder="$OPTARG"
        ;;
        b ) branch="$OPTARG"
        ;;
        d ) output_dir="$OPTARG"
        ;;
        \? ) echo "Usage: download_repo.sh [-r <repo>] [-s <subfolder>] [-b <branch>] [-d <dest_folder>]"
            echo "Using default values:"
            echo "Repository: $repo"
            echo "Subfolder: $subfolder"
            echo "Branch: $branch"
            echo "Destination folder: $output_dir"
            exit 1
        ;;
    esac
done
shift $((OPTIND -1))

# Create output directory if it doesn't exist
if [ ! -d "$output_dir" ]; then
    echo "Creating output directory: $output_dir"
    mkdir -p "$output_dir"
fi

# Download all files in the subfolder
download_files() {
    curl -s "https://api.github.com/repos/$repo/contents/$1" |
    jq -r '.[] | select(.type == "dir").path' |
    while read dir; do
        download_files "$dir" "$2/$1"
    done
    
    curl -s "https://api.github.com/repos/$repo/contents/$1" |
    jq -r '.[] | select(.type == "file").path' |
    while read path; do
        filename=$(basename "$path")
        url="https://raw.githubusercontent.com/$repo/$branch/$path"
        curl -L -o "$2/$filename" "$url"
    done
}

# Call the function to download all files in the subfolder
download_files "$subfolder" "$output_dir"
