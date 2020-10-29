. (Join-Path $PSScriptRoot -ChildPath 'Download-AllYoutubeLinksInHTMLBlob.ps1')

# Usage of the project script
# Use your own values here
$params = @{
    HtmlFilepath = 'D:\VM-Shared\silicon\youtube-dl-helper\src.txt'
    VideoOutputDir = 'D:\VM-Shared\silicon\youtube-dl-helper\out'
    ffmpegDirectory = Join-Path $PSScriptRoot -ChildPath 'dependencies\ffmpeg\bin'
    youtubeDlFilePath = Join-Path $PSScriptRoot -ChildPath 'dependencies\youtube-dl.exe'
}
Download-AllYoutubeLinksInHTMLBlob @params