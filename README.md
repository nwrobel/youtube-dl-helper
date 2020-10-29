# youtube-dl-helper

This project is a script that adds to the functionality of the youtube-dl program by allowing the videos of entire Youtube playlists to be downloaded.

## System Requirements
- Windows with Powershell 5 installed
- ffmpeg downloaded on your system
- youtube-dl.exe downloaded on your system
- Python 3.6 or greater installed on your system and added to the PATH

## Installation
Run Setup.ps1 from a Powershell terminal. 

## Usage
- Go to the page of the Youtube playlist you want to download
- Scroll down far enough so that all the video thumbnails have been displayed on the page
- Open developer tools (F12 in Chrome) and copy the HTML code for the page and paste it into a file
- In the script `Run.ps1`, modify the input parameters used to call the downloader cmdlet to meet your needs. Use the path to the HTML code file you created earlier and the desired video output directory.
- Run this script
