import logging
import os

from apscheduler.schedulers.blocking import BlockingScheduler
from dotenv import load_dotenv

from project_deb_demo.jobs import demo_job

logger = logging.getLogger(__name__)

root_dir = os.path.realpath(os.path.dirname(os.path.realpath(__file__)) + "/..")
load_dotenv(dotenv_path=f"{root_dir}/.env")
logging.basicConfig(level=os.environ.get("LOGLEVEL", "INFO"))

scheduler = BlockingScheduler()


def main():
    scheduler.add_job(demo_job, "interval", seconds=int(os.getenv("DEMO_INTERVAL", "10")))
    logging.info("Press Ctrl+C to exit")

    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        pass


if __name__ == "__main__":
    main()
