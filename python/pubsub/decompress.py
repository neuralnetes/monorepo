import asyncio
import io
from typing import Any, Dict, List
from zipfile import ZipFile
from zipfile import is_zipfile

import aiohttp
from gcloud.aio.storage import Storage, Bucket


async def decompress(bucket_name, input_path, output_path):
    async with aiohttp.ClientSession(timeout=None) as session:
        storage = Storage(session=session)
        bucket = storage.get_bucket(bucket_name)
        blob_names = await bucket.list_blobs(prefix=input_path)
        blobs = await asyncio.gather(*[
            bucket.get_blob(blob_name) for blob_name in blob_names
            if blob_name.endswith('.zip')
        ])
        blob_bytes = await asyncio.gather(*[
            blob.download(session=session) for blob in blobs
        ])
        bytes_ios = [io.BytesIO(bb) for bb in blob_bytes]
        upload_results = await asyncio.gather(*[
            unzip_and_upload(bucket, output_path, bytes_io)
            for bytes_io in bytes_ios
        ])
        return upload_results


async def unzip_and_upload(bucket, path_prefix, bytes_io) -> List[Dict[Any, Any]]:
    if is_zipfile(bytes_io):
        with ZipFile(bytes_io, 'r') as archive:
            file_infos = [archive.getinfo(file_name) for file_name in archive.namelist()]
            files = [file_info for file_info in file_infos if not file_info.is_dir()]
            dirs = [file_info for file_info in file_infos if file_info.is_dir()]
            print('files')
            print(files)
            print('dirs')
            print(dirs)
            # return await asyncio.gather(*[
            #     upload(bucket,
            #            f'{path_prefix}/{file_name}',
            #            archive.read(file_name))
            #     for file_name in archive.namelist()
            # ])
            await asyncio.sleep(5)
            return []
    return []


async def upload(session, bucket: Bucket, path: str, data: bytes) -> Dict[Any, Any]:
    blob = bucket.new_blob(path)
    return await blob.upload(data, session=session)


async def main():
    bucket_name = 'datasets-djwj'
    input_path = 'first-rate-data/input'
    output_path = 'first-rate-data/decompressed-python'
    results = await decompress(bucket_name, input_path, output_path)
    print(results)


if __name__ == '__main__':
    asyncio.run(main())
