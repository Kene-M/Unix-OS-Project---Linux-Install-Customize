#!/bin/bash

    #predefined packages to update, bash is the base test package
PACKAGES=("curl" "vim" "git" "bash")

    #Create a formatted package list of all packages for display
LIST=$(printf '~ %s\n' "${PACKAGES[@]}")

    #Notify user that update is starting
zenity --info --text="Updating all packages in the list:\n\n$LIST\n\n" --timeout=5

    #Updating package list
sudo apt update 2>&1

    #Checking if the update failed or worked
if [ $? -ne 0 ]; then
    zenity --error --text="Failed to update package list."
    exit 1
fi

    #Initialize counters and failure log
SUCCESS=0
FAIL=0
FAILED_PACKAGES=""

    #Loop through each package and update it individually
for package in "${PACKAGES[@]}"; do

        #Notify user of current package being updated
    zenity --info --text="Updating: $package" --timeout=2 --width=500

        #Attempt to update the package, only upgrading if already installed
    sudo apt install --only-upgrade "$package" -y 2>&1
    
        #Check if the update was successful and update counters accordingly
    if [ $? -eq 0 ]; then
        ((SUCCESS++))
    else
        ((FAIL++))
            #Log the failed package for later display as a list
        FAILED_PACKAGES="$FAILED_PACKAGES\n~ $package"
    fi
done

    #Final notification to user about the update results
if [ $FAIL -eq 0 ]; then
    zenity --info \
        --title="Update Complete" \
        --text=" All packages updated successfully\n\nTotal packages updated: $SUCCESS" \
        --width=500
    #if there were failures, show a warning with details
else
    zenity --warning \
        --title="Update Complete with Warnings" \
        --text="Update finished with issues:\n\n Successful updates: $SUCCESS\n Failed updates: $FAIL\n\nFailed packages:$FAILED_PACKAGES" \
        --width=500
fi

exit 0