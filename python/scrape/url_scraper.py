import asyncio
import os

import aiohttp
from bs4 import BeautifulSoup, SoupStrainer


def soup(text) -> BeautifulSoup:
    return BeautifulSoup(text,
                         parse_only=SoupStrainer('a'),
                         features='html.parser')


async def scrape_links(url, link_filter_f):
    async with aiohttp.ClientSession() as session:
        response = await session.get(url)
        text = await response.read()
        return [link.get("href") for link in soup(text) if link.has_attr('href') and link_filter_f(link.get("href"))]


async def scrape_urls(base_url, endpoint, link_filter_f):
    links = await scrape_links(f'{base_url}/{endpoint}', link_filter_f)
    return [f'{base_url}/{link[1:] if link.startswith("/") else link}' for link in links]


def first_rate_data_link_filter(url):
    return url.startswith("/datafile")


async def main():
    base_url = os.getenv('BASE_URL')
    endpoint = os.getenv('ENDPOINT')
    if 'firstratedata.com' in base_url:
        urls = await scrape_urls(base_url, endpoint, first_rate_data_link_filter)
        print(urls)


if __name__ == '__main__':
    asyncio.run(main())
