#!/bin/bash

# Use Zenity to prompt user to select the script (.sh file) to run and store in a variable
SCRIPT_FILE=$(zenity --file-selection --title="Select Script File")

# If no script is selected, exit
if [ -z "$SCRIPT_FILE" ]; then
    zenity --error --text="No file selected. Exiting."
    exit 1
fi

# Use Zenity to prompt user to select an image to use as the icon and store in a variable
ICON_FILEPATH=$(zenity --file-selection --title="Select Script Icon")

# If no image is selected, exit
if [ -z "$ICON_FILEPATH" ]; then
    zenity --error --text="No file selected. Exiting."
    exit 1
fi


# Use Zenity to prompt user to enter a name for the desktop entry and store in a variable
desktop_name=$(zenity --entry --title="Enter Icon Name")

# If no name is entered, use a default name
if [ -z "$desktop_name" ]; then
    zenity --error --text="No file selected. Exiting."
    exit 1
fi

# Define the path for the .desktop file (in the current directory) and store in a variable
# desktop_filename="$desktop_name.desktop"
DESKTOP_FILEPATH="$(pwd)/$desktop_name.desktop"

# Create the .desktop file using echo commands
# You can echo the content with the variables that you created
# using all the variables that were stored for path
# and zenity. The first line will be redirected >
# the following lines will be added with >>
echo "[Desktop Entry]" > "$DESKTOP_FILEPATH"
echo "Version=1.0" >> "$DESKTOP_FILEPATH"
echo "Type=Application" >> "$DESKTOP_FILEPATH"
echo "Name=$desktop_name" >> "$DESKTOP_FILEPATH"
echo "Comment=User made script shortcut made via icon.sh." >> "$DESKTOP_FILEPATH"
echo "Exec=$SCRIPT_FILE" >> "$DESKTOP_FILEPATH"
echo "Icon=$ICON_FILEPATH" >> "$DESKTOP_FILEPATH"
echo "Terminal=false" >> "$DESKTOP_FILEPATH"
echo "Categories=Utility;" >> "$DESKTOP_FILEPATH"
# Copy the .desktop file to the user's desktop
USR_DESKTOP_PATH="$HOME/Desktop/$desktop_name.desktop"
cp "$DESKTOP_FILEPATH" "$USR_DESKTOP_PATH"

# Make the .desktop file executable
chmod +x "$USR_DESKTOP_PATH"

# Use Zenity to notify user that the .desktop file has been created and moved
if [ -e "$USR_DESKTOP_PATH" ]; then
zenity --info --text="Desktop file $desktop_name has been created and moved to desktop"
else
zenity --warning --text="Desktop file $desktop_name has been created but couldn't be added to desktop"
fi
