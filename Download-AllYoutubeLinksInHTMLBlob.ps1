function Download-AllYoutubeLinksInHTMLBlob {
    param(
        [string]$HTMLFilepath
    )

    $ffmpegDir = Join-Path $PSScriptRoot -ChildPath 'dependencies\ffmpeg\bin'
    $youtubeDlFilepath = Join-Path $PSScriptRoot -ChildPath 'dependencies\youtube-dl.exe'

    $pythonLinkParserScriptFilepath = Join-Path $PSScriptRoot -ChildPath 'YoutubeLinkParser.py'
    $linksOutputFilepath = Join-Path $PSScriptRoot -ChildPath 'YoutubeLinkParser-links-output.txt'

    & python.exe $pythonLinkParserScriptFilepath $HTMLFilepath $linksOutputFilepath
 
    $links = Get-Content $linksOutputFilepath
    foreach ($videoUrl in $links) {
        & "$youtubeDlFilepath" -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --output "%(uploader)s - %(title)s - YouTube [%(id)s]" --ffmpeg-location "$ffmpegDir" "$videoUrl"
    }  
}

