#!/bin/bash
Input="$1" # is read from input
# Path of your Btrfs Volume or Mountpoint >> MUST HAVE "/" AT THE END << (e.g "/home/" or "/mnt/data/")
PathToVolume=""

# function that actually deletes something
function DeleteFileOrFolder() {
    echo "Deleting ... $1"
    # Uncomment the following line to Actually delete something
    # rm -rf "$1"
    if [ $? -eq 0 ]; then
        echo "Deleted SUCCESSFULLY"
    fi
}


# Delete File on Normal/Live Filesystem First
if [ -d "$Input" ] || [ -f "$Input" ]; then
    DeleteFileOrFolder "$Input"
else
    echo "File or Folder not found in $Input"
fi

# Get all the btrfs Subvolumes
PathOfSubvolumes=$(btrfs subvolume list $PathToVolume | cut -d ' ' -f 9)

for Path in $PathOfSubvolumes; do
    # take away PathToVolume from Input
    RelInputPath=${Input##"$PathToVolume"}
    if [ -d "$PathToVolume$Path/$RelInputPath" ] || [ -f "$PathToVolume$Path/$RelInputPath" ]; then
        echo "$Input does exist in $PathToVolume$Path and is a directory or a file."
        snapshotPath="$PathToVolume$Path"
        echo "snapshotPath is: $snapshotPath"
        # Get the ro (readonly) Status of the Subvolume
        GetRoInfo=$(btrfs property get "$snapshotPath" ro)
        echo "GetRoInfo is: $GetRoInfo"
        # If it is a Readonly btrfs subvolume, make it writable, delete folder, make it readonly again.
        if [ "${GetRoInfo##*=}" = "true" ] ; then
            btrfs property set "$snapshotPath" ro false
            if [ $? -eq 0 ]; then
                echo "Sucessfully set subvolume to ro false"
            fi
            DeleteFileOrFolder "$PathToVolume$Path/$RelInputPath"
            btrfs property set "$snapshotPath" ro true
            if [ $? -eq 0 ]; then
                echo "Sucessfully set subvolume to ro true"
            fi
        else
            # if its not a readonly  subvolume - just delete the folder
            DeleteFileOrFolder "$PathToVolume$Path/$RelInputPath"
    
        fi
    else
        echo "File or Folder not found in $PathToVolume$Path"
    fi
    # print a new empty line to have a clearer output
    printf "\n"
done
