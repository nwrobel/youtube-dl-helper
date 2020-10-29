<#
.SYNOPSIS
Downloads a list of Youtube videos.

.DESCRIPTION
This cmdlet parses the HTML code of a Youtube playlist page to find the video links and downloads
each video using "youtube-dl".

.PARAMETER HTMLFilepath
The absolute filepath of the input file containing the desired playlist page's HTML code

.PARAMETER VideoOutputDir
Path of where the videos should be saved to

.PARAMETER ffmpegDirectory
Path of the "bin" folder of the Windows program ffmpeg on the system

.PARAMETER youtubeDlFilePath
Path of the "youtube-dl.exe", the youtube-dl program 

.NOTES
This cmdlet uses ffmpeg and youtube-dl as dependencies and requires that you pass their paths on the
system as parameters. Python version 3.6 or later must also be installed on the system and added
to the PATH.

#>
function Download-AllYoutubeLinksInHTMLBlob {
    param (
        [string]$HTMLFilepath,
        [string]$VideoOutputDir,
        [string]$ffmpegDirectory,
        [string]$youtubeDlFilePath
    )

    $pythonLinkParserScriptFilepath = Join-Path $PSScriptRoot -ChildPath 'youtube-link-parser.py'
    $linksOutputFilepath = Join-Path $env:TEMP -ChildPath 'links-out.txt'

    & python.exe $pythonLinkParserScriptFilepath $HTMLFilepath $linksOutputFilepath
 
    Start-Process $youtubeDlFilePath -ArgumentList @('--rm-cache-dir') -Wait -NoNewWindow

    $youtubeDlArgs = @(
        '-f',
        'bestvideo+bestaudio/best',
        '--merge-output-format',
        'mp4',
        '--output',
        "`"$VideoOutputDir/%(uploader)s - %(title)s - YouTube [%(id)s]`"", 
        '--ffmpeg-location',
        "`"$ffmpegDirectory`""
    )

    $links = Get-Content $linksOutputFilepath
    $failedLinks = @()

    foreach ($videoUrl in $links) {
        $videoLinkSplit = $videoUrl -split 'v='
        $videoId = $videoLinkSplit[1]

        $thisVideoDownloadArgs = $youtubeDlArgs + "$videoUrl"
        $retryCount = 0
        $videoDownloadSuccessful = $false

        do {
            Start-Process -FilePath $youtubeDlFilePath -ArgumentList $thisVideoDownloadArgs -Wait -NoNewWindow
            
            $downloadedVideo = Get-ChildItem $VideoOutputDir | Where-Object { $_.Name -like "*$($videoId)].mp4" }
            if ($downloadedVideo) {
                $videoDownloadSuccessful = $true
            }

            $retryCount += 1

        } while (-not $videoDownloadSuccessful -and $retryCount -le 2)

        if (-not $videoDownloadSuccessful) {
            $failedLinks += $videoUrl
        }        
    }
    
    Write-Host "The following links failed to download:"
    $failedLinks
}

