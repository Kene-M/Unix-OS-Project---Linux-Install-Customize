# Unix-OS-Project---Linux-Install-Customize

**Team**: Goofy Goobers

**Contributors**: Alianna Card, Nolan Haag, Blade Hagman, Kene Maduabum 

**Project Overview**: This project demonstrates the creation of a fully portable, customized Linux operating system installed on an external drive. It features a specific partition scheme, a customized Desktop Environment (KDE Plasma), and a suite of integrated automation tools powered by Bash and Zenity.

## Project Presentation
Full walkthrough and demonstration on YouTube: [https://youtu.be/6Ff-JxJYibQ]

## Full Documentation
Here is the full documentation for the project: `Project Documentation - Full.docx` | [https://github.com/Kene-M/Unix-OS-Project---Linux-Install-Customize/blob/master/Project%20Documentation%20-%20Full.docx]

## System Customizations
We moved beyond the standard Ubuntu installation to create a user-friendly and familiar environment:
- **Core OS**: Ubuntu LTS installed on an external USB drive (Boot/Swap/Root manual partitioning).
- **Desktop Environment**: KDE Plasma was chosen to replicate a Windows-like interface, ensuring familiarity for all team members.
- **Software Management**: GNOME Software was implemented to provide a robust GUI app store for general-purpose applications.

## Automation Suite (Scripts)
To extend system functionality, we developed five custom Bash scripts utilizing Zenity for graphical user interaction.

| Script Name | Function |
| --- | --- |
| `icon.sh` | Creates desktop shortcuts for scripts |
| `cronjobs.sh` | GUI-based cron job scheduler |
| `create_backup.sh` | Directory backup with compression
| `update_packages.sh` | Automated package updates
| `update_network.sh` | Network diagnostics & updates
