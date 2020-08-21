'''
Script that parses the HTML code of a Youtube playlist page and outputs a file containing the links
to all the videos in that playlist.
'''

import argparse
from bs4 import BeautifulSoup

from com.nwrobel import mypycommons
import com.nwrobel.mypycommons.file

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("inputFilepath", type=str, help=\
        '''The absolute filepath of the input file containing the desired playlist page's HTML code.'''
    )

    parser.add_argument("outputFilepath", type=str, help=\
        '''The absolute filepath of the where the output file, which has the found Youtube video links, should be saved.'''
    )
      
    args = parser.parse_args()

    soup = BeautifulSoup (open(args.inputFilepath, encoding='utf-8'), 'html.parser')

    playlistItemContainers = soup.find_all('a', {'class':['yt-simple-endpoint style-scope', 'ytd-playlist-video-renderer']})

    playlistVideoLinks = []
    for container in playlistItemContainers:
        link = container.attrs['href']
        videoId = link.split('&')[0]
        videoLink = "youtube.com{}".format(videoId)
        playlistVideoLinks.append(videoLink)

    mypycommons.file.writeToFile(args.outputFilepath, playlistVideoLinks)