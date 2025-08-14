import os
from dotenv import load_dotenv

load_dotenv()

TOKEN = os.getenv("DISCORD_BOT_TOKEN")
COMMAND_NAME = "fortune" # This is the furtune tellers name as well as the command. Update this.
COMMAND_ALIAS = "ft" # An alias to the command. Useful if you name the fortune teller something ridicular or hard to type.
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")