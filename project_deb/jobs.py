import logging
import os
from datetime import datetime

logger = logging.getLogger(__name__)


def demo_job():
    logging.info("=== Demo job run ==============================================================")
    logging.info("Tick! The time is: %s", {datetime.now()})
    logging.info("Message=%s", os.getenv("DEMO_MESSAGE", "(default) Hello World!!!"))
