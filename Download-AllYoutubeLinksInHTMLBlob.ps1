function Download-AllYoutubeLinksInHTMLBlob {
    param(
        [string]$HTMLFilepath,
        [string]$VideoOutputDir
    )

    $ffmpegDir = Join-Path $PSScriptRoot -ChildPath 'dependencies\ffmpeg\bin'
    $youtubeDlFilepath = Join-Path $PSScriptRoot -ChildPath 'dependencies\youtube-dl.exe'
    $pythonLinkParserScriptFilepath = Join-Path $PSScriptRoot -ChildPath 'YoutubeLinkParser2.py'

    $linksOutputFilepath = Join-Path $env:TEMP -ChildPath 'links-out.txt'

    & python.exe $pythonLinkParserScriptFilepath $HTMLFilepath $linksOutputFilepath
 
    Start-Process $youtubeDlFilepath -ArgumentList @('--rm-cache-dir') -Wait -NoNewWindow

    $youtubeDlArgs = @(
        '-f',
#        'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio',
        'bestvideo+bestaudio/best',
        '--merge-output-format',
        'mp4',
        '--output',
        "`"$VideoOutputDir/%(uploader)s - %(title)s - YouTube [%(id)s]`"", 
        '--ffmpeg-location',
        "`"$ffmpegDir`""
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
            Start-Process -FilePath $youtubeDlFilepath -ArgumentList $thisVideoDownloadArgs -Wait -NoNewWindow
            
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


$htmlFilepath = "D:\VM-Shared\silicon\src.txt"
$videoOutputDir = "D:\Downloads\yt"
Download-AllYoutubeLinksInHTMLBlob -HTMLFilepath $htmlFilepath -VideoOutputDir $videoOutputDir

