import argparse

def getVideoLinksFromHTML(htmlFilepath):
    with open(htmlFilepath, mode='r', encoding='utf-8') as f:
        htmlLines = f.readlines()
    
    htmlLines = [line.strip() for line in htmlLines]

    videoIds = []

    for line in htmlLines:
        keyString = 'href=\"/watch?v='
        if keyString in line:
            idPart = line.split(keyString)[1]

            if '&amp' in idPart:
                vidId = idPart.split('&amp')[0]
                videoIds.append(vidId)

    videoIds = set(videoIds)
    videoLinks = ['https://youtube.com/watch?v={}'.format(vidId) for vidId in videoIds]
    
    return videoLinks


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("inputFilepath", type=str, help=\
        '''The absolute filepath of the input file containing the HTML blob data to parse and find links in.'''
    )

    parser.add_argument("outputFilepath", type=str, help=\
        '''The absolute filepath of the where the output file containing the found Youtube video links should be saved.'''
    )
      
    args = parser.parse_args()

    videoLinks = getVideoLinksFromHTML(args.inputFilepath)

    with open(args.outputFilepath, mode='w', encoding='utf-8') as f:
        for link in videoLinks:
            f.write("{}\n".format(link))




