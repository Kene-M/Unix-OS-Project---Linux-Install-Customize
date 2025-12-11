#!/bin/bash

# Select date using Zenity calender picker and store into a variable
# check to make sure date was selected
SEL_DATE=$(zenity --calendar --date-format="%Y-%m-%d" --title="Select Date for Cron Job")
if [ -z "$SEL_DATE" ]; then 
    zenity --error --text="No date selected. Exiting.";
    exit 1; 
fi

# Select time (12-hour format) with zenity using --entry with HH:MM format and store into a variable
# check to make sure a valid format was entered
SEL_TIME=$(zenity --entry --title="Select Time" --text="Enter time in 12 hr H:MM/HH:MM format:" --entry-text="12:00")
if [[ ! "$SEL_TIME" =~ ^(0?[1-9]|1[0-2]):[0-5][0-9]$ ]]; then # Regex for validating 12 hour format
    zenity --error --text="Invalid time format. Use H:MM/HH:MM (12-hour). Exiting."
    exit 1;
fi

# Select AM or PM with zenity --list and check to make sure it was selected
AMPM=$(zenity --list --column="Period" "AM" "PM" --title="AM or PM?" --height=200)
if [ -z "$AMPM" ]; then 
    zenity --error --text="No AM/PM selection made. Exiting."
    exit 1;
fi

# Convert 12-hour time to 24-hour time
# store the hour in a variable for hour
# store the minutes in a variable for minutes
HOUR_12=$(echo $SEL_TIME | cut -d: -f1) # use cut to select first field from zenity time picker (12-hour)
MINUTE=$(echo $SEL_TIME | cut -d: -f2) # use cut to select second field from zenity time picker (minute)

HOUR_24=$HOUR_12 
if [ "$AMPM" == "PM" ] && [ "$HOUR_12" -ne 12 ]; then
    HOUR_24=$((HOUR_12 + 12)) # convert to 24 hour by adding 12, if the time isn't 12:xxPM
elif [ "$AMPM" == "AM" ] && [ "$HOUR_12" -eq 12 ]; then
    HOUR_24=0 #AM times are ignored
fi

# Select script file using zenity and store it in a variable
# check to make sure it was selected 
SCRIPT_FILE=$(zenity --file-selection --title="Select Script to Schedule" --file-filter="*.sh")
if [ -z "$SCRIPT_FILE" ]; then 
    zenity --error --text="No script selected. Exiting.";
    exit 1; 
fi
# make sure it's executable
if [ ! -x "$SCRIPT_FILE" ]; then
    chmod +x "$SCRIPT_FILE" || true
fi

# Ask if the scheduled script needs DISPLAY and XAUTHORITY variables
# if you choose to use zenity to choose your files on the create_backup.sh you
# will need to use the display. Since the cronjob will run in the background
# you can use the DISPLAY and the XAURHORITY to display your gui
# use display="DISPLAY=:0" and xauthority="XAUTHORITY=/home/$USER/.Xauthority"
# to use your display
NEEDS_GUI=$(zenity --list --title="GUI/Display Needs" --text="Does this script require GUI (Display and XAUTHORITY variables)?" --radiolist --column "Select" --column "Option" TRUE "Yes" FALSE "No");
if [ "$NEEDS_GUI" = "Yes" ]; then
    ENV_VARS="DISPLAY=:0 XAUTHORITY=/home/$USER/.Xauthority";
else
    ENV_VARS="";
fi

# Select repetition schedule using Zenity --list and --column will be 
# Once a day, Once a week, Once a month, Once a year
REPETITION=$(zenity --list --column="Schedule" "Once a day" "Once a week" "Once a month" "Once a year" --height=250)
if [ -z "$REPETITION" ]; then 
    zenity --error --text="No repetition selected. Exiting.";
    exit 1; 
fi

# Calculate day and month for the initial run and store
# in a variable into day and variable for month
SEL_DAY=$(date -d "$SEL_DATE" +"%d")
SEL_MONTH=$(date -d "$SEL_DATE" +"%m")
SEL_WEEKDAY=$(date -d "$SEL_DATE" +"%w") # %w is weekday for cron: use 0-6 (Sunday=0)

# Use a case to define cron job schedule based on user's selection
# of the repetition selected from your Zenity list
# each selection would store in a variable the syntax for
# Every day at the selected time "$minute $hour * * *"
# Every week on the selected day of the week "$minute $hour * * $weekday"
# Every month on the selected day"$minute $hour $day * *"
# Every year on the selected date "$minute $hour $day $month *"
case "$REPETITION" in
    "Once a day")
        CRON_SCHED="$MINUTE $HOUR_24 * * *"
        ;;
    "Once a week")
        CRON_SCHED="$MINUTE $HOUR_24 * * $SEL_WEEKDAY"
        ;;
    "Once a month")
        CRON_SCHED="$MINUTE $HOUR_24 $SEL_DAY * *"
        ;;
    "Once a year")
        CRON_SCHED="$MINUTE $HOUR_24 $SEL_DAY $SEL_MONTH *"
        ;;
esac

# Add the cron job using the variable that was created in the case and the display as well as the script

# Define the full command string for the cronjob
cron_job="$CRON_SCHED $ENV_VARS $SCRIPT_FILE"
# Backup current crontab, append new job to existing crontab, and load it back
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -

# Show confirmation
zenity --info --text="Cron job scheduled:\n$cron_job"