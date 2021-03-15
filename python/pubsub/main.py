import asyncio
import os

from pubsub import consume_pubsub_event

DATA_PROJECT_ID = os.getenv('DATA_PROJECT_ID')
TEST_PUBSUB_TOPIC = os.getenv('TEST_PUBSUB_TOPIC')


def entry(event, context):
    asyncio.run(consume_pubsub_event(event, context))
