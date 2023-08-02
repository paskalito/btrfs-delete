# btrfs-delete
Script to delete a File or Folder on a BTRFS Filesystem and in all its Snapshots/Subvolumes.

# Usage
Call the script and provide it with the path to the file or folder you with to delete
`bash ./btrfs-delete /Full/Path/to/your/file/or/folder`
watch your space freeing up

# Installation
- Download the Script
- make it executable (chmod +x /path/to/script)
- open the script and fill out `PathToVolume=`
- ! If you have dryrun the script, and checked it will delete the correct files or folders remove the # before the `rm -rf "$1"` so things get actually deleted (this is meant as a safety mecanism)


# Features / Known Limitations
This is basically a much improved solution for a problem "solved" here: https://www.suse.com/support/kb/doc/?id=000019594
- way way way faster
- supports files or Folders
- lets you provide your path with autocompletion (since it uses the full path)
- more robust design over all
- is tested with 2 diffrnet systems where there is snapper in use.
  - but it should work with any regular full filesystem snapshots/subvolumes
- Only for use with BTRFS 

Assumptions
- ! This scirpt assumes you have snapshots from the full filesystem (which i think is standatdparctise (or still the only option))
