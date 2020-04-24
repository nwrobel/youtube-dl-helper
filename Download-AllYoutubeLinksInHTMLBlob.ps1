function Download-AllYoutubeLinksInHTMLBlob {
    param(
        [string]$HTMLFilepath
    )

    $ffmpegDir = Join-Path $PSScriptRoot -ChildPath 'dependencies\ffmpeg\bin'
    $youtubeDlFilepath = Join-Path $PSScriptRoot -ChildPath 'dependencies\youtube-dl.exe'

    $pythonLinkParserScriptFilepath = Join-Path $PSScriptRoot -ChildPath 'YoutubeLinkParser2.py'
    $linksOutputFilepath = Join-Path $env:TEMP -ChildPath 'links-out.txt'

    & python.exe $pythonLinkParserScriptFilepath $HTMLFilepath $linksOutputFilepath
 
    $youtubeDlArgs = @(
        '-f',
        'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio',
        '--merge-output-format',
        'mp4',
        '--output',
        '"%(uploader)s - %(title)s - YouTube [%(id)s]"', 
        '--ffmpeg-location',
        "$ffmpegDir"
    )

    $links = Get-Content $linksOutputFilepath
    $failedLinks = @()
    foreach ($videoUrl in $links) {
        $thisVideoDownloadArgs = $youtubeDlArgs + "$videoUrl"

        $process = Start-Process -FilePath $youtubeDlFilepath -ArgumentList $thisVideoDownloadArgs -PassThru -Wait -NoNewWindow
        #& "$youtubeDlFilepath" -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --output "%(uploader)s - %(title)s - YouTube [%(id)s]" --ffmpeg-location "$ffmpegDir" "$videoUrl"
        
        if ($process.ExitCode -ne 0) {
            $failedLinks += $videoUrl
        }
    }
    
    Write-Host "The following links failed to download:`n$($failedLinks)"
}

$htmlFilepath = "Z:\Development\Test Data\youtube-utils\src.txt"
Download-AllYoutubeLinksInHTMLBlob -HTMLFilepath $htmlFilepath

