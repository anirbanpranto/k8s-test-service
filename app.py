import logging
import time
from alertbot.alertbot import Alertbot
from alertbot.utils import load_secret_from_aws_sm, get_channels_from_yaml

bot = Alertbot.get_alertbot_instance(
    channels=get_channels_from_yaml("config.yaml"),
    token=load_secret_from_aws_sm("alertbot/slack"),
    enviroment="dev",
    client_type="slack",
    cloudwatch=False
)

@bot.error_alert("alert_channel")
def listen(self):
        x = 1/0

listen()

logging.basicConfig(
    level=logging.INFO, format="[%(levelname)s] %(asctime)s --  %(message)s"
)
logger = logging.getLogger(__name__)

def wait(in_seconds: int):
    """Wrapper to wait for x seconds after the function being decorated is executed."""

    def _wait(fn):
        def wrapper(*args, **kwargs):
            res = fn(*args, **kwargs)
            logger.info(f"Waiting for {in_seconds}s ...")
            time.sleep(in_seconds)
            return res

        return wrapper

    return _wait


class Service:
    @bot.error_alert("alert_channel")
    @wait(120)
    def listen(self):
        return "foo"

s = Service()
while True:
    r = s.listen()
    print(r)
