#!/bin/bash

# Select a source directory or
# Use Zenity to select a source directory
SOURCE_DIR=$(zenity --file-selection --directory --title="Select Source Directory for Backup")

# Select the destination folder
# Use Zenity to select the destination folder
DEST_DIR=$(zenity --file-selection --directory --title="Select Destination Folder for Backup")

# If using Zeinty check if the user canceled the dialog
if [[ -z "$SOURCE_DIR" || -z "$DEST_DIR" ]]; then
    zenity --error --text="Directory selection for either source or dest canceled. Exiting."
    exit 1
fi

# Create a tarball of the source folder and backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S") # Create timestamp for unique backup filename - Format: YYYY-MM-DD_HH-MM-SS
BACKUP_NAME="backup_$(basename "$SOURCE_DIR")_$TIMESTAMP.tar.gz" # Get name of src dir and define backup filename with timestamp
# Compresses the source directory into a gzip-compressed tarball using relative paths.
tar -czf "$DEST_DIR/$BACKUP_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# If using Zenity display the success or failure of the backup
if [ $? -eq 0 ]; then
    zenity --info --text="Backup successfully created:\n$DEST_DIR/$BACKUP_NAME"
else
    zenity --error --text="Backup failed."
fi