import argparse
from bs4 import BeautifulSoup


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("inputFilepath", type=str, help=\
        '''The absolute filepath of the input file containing the HTML blob data to parse and find links in.'''
    )

    parser.add_argument("outputFilepath", type=str, help=\
        '''The absolute filepath of the where the output file containing the found Youtube video links should be saved.'''
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

    with open(args.outputFilepath, mode='w', encoding='utf-8') as f:
        for link in playlistVideoLinks:
            f.write("{}\n".format(link))