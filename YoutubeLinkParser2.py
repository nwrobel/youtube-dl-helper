from bs4 import BeautifulSoup

htmlFilepath = "D:\\VM-Shared\\silicon\\src.txt"
soup = BeautifulSoup (open(htmlFilepath, encoding='utf-8'), 'html.parser')

#links = soup.find_all('ytd-playlist-video-renderer')
links = soup.find_all('a', {'class':['yt-simple-endpoint style-scope', 'ytd-playlist-video-renderer']})

for link in links:
    print(link)