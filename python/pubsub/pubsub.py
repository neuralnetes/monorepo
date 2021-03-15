import asyncio
import base64
import datetime
import json
from typing import Dict, List

import aiohttp
from gcloud.aio.pubsub import PublisherClient
from gcloud.aio.pubsub import PubsubMessage


async def publish_pubsub_event(project_id,
                               topic_name,
                               pubsub_messages: List[PubsubMessage]):
    async with aiohttp.ClientSession() as session:
        client = PublisherClient(session=session)
        topic = client.topic_path(project_id, topic_name)
        return await client.publish(topic, pubsub_messages)


def decode_pubsub_event_data(event: Dict[str, any], encoding='utf-8'):
    return base64.b64decode(event['data']).decode(encoding)


def encode_pubsub_event_data(data, encoding='utf-8') -> bytes:
    return to_json(data).encode(encoding)


def to_json(obj: object):
    return json.dumps(obj,
                      default=default_serializer,
                      sort_keys=True,
                      indent=4)


def default_serializer(obj):
    if type(obj) == datetime.datetime:
        return default_datetime_serializer(obj)
    return obj.__dict__


def default_datetime_serializer(datetime_obj: datetime.datetime) -> str:
    return datetime_obj.isoformat()


def get_test_pubsub_messages() -> List[PubsubMessage]:
    data = encode_pubsub_event_data(
        {
            'ticker': 'xlm',
            'open': 1.0,
            'close': 1.0,
            'high': 1.0,
            'low': 1.0,
            'datetime': datetime.datetime.now(),
        }
    )
    attributes = {
        'test': 'test1'
    }
    return [
        PubsubMessage(
            data,
            **attributes
        )
    ]


async def consume_pubsub_event(event, context):
    print(event)
    print(context)
    decoded_data_string = decode_pubsub_event_data(event)
    print(json.loads(decoded_data_string))
    print(event.get('attributes', {}))
    return await asyncio.sleep(5)


async def test_publish_pubsub_event(project_id, topic):
    pubsub_messages = get_test_pubsub_messages()
    return await publish_pubsub_event(project_id,
                                      topic,
                                      pubsub_messages)
