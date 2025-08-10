#!/usr/bin/env python3
import discord
from discord.ext import commands
import asyncio
import logging
from config import TOKEN, COMMAND_NAME
from utils.logger import setup_logger

# Setup logging
logger = setup_logger()

# Initialize bot with all intents
intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents, case_insensitive=True)

# Load cogs
async def load_extensions():
    try:
        await bot.load_extension('cogs.fortune_teller_cog')
        logger.info('Successfully loaded all extensions')
    except Exception as e:
        logger.error(f'Failed to load extensions: {e}')
        raise

@bot.event
async def on_ready():
    logger.info(f'{bot.user} has connected to Discord!')
    logger.info(f'Invite link: {discord.utils.oauth_url(bot.user.id, permissions=discord.Permissions(send_messages=True, read_messages=True))}')
    await bot.change_presence(activity=discord.Game(name=f"!{COMMAND_NAME} for a prophecy"))

async def main():
    async with bot:
        await load_extensions()
        await bot.start(TOKEN)

if __name__ == "__main__":
    asyncio.run(main())
