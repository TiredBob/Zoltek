# Fortune Teller Bot

A friendly Discord bot that can tell your fortune!

## What is a Discord Bot?

A Discord bot is like a helpful robot that you can add to your Discord server. It can do all sorts of things, like play music, moderate your server, or in this case, tell your fortune! You can interact with it by typing special commands in your chat.

## How it Works

This bot uses a bit of magic (and a random 20-sided die roll) to decide what kind of fortune to give you. 

If you have a special "Gemini API key" (think of it as a key to a library of powerful magic), the bot can give you very detailed and creative fortunes. If you don't have this key, no worries! The bot will still give you a fun, general fortune.

## Getting Started: Bringing the Bot to Life

This guide will walk you through the steps to get the Fortune Teller Bot running on your own computer.

### Step 1: Getting Your Bot's Secret Token

Before you can run the bot, you need to create a "bot account" on Discord and get a secret "token" for it. This token is like a password for your bot, so keep it safe!

1.  **Go to the Discord Developer Portal:** Open your web browser and go to [https://discord.com/developers/applications](https://discord.com/developers/applications).
2.  **Create a New Application:** Click the "New Application" button. Give it a name (like "My Fortune Teller") and click "Create".
3.  **Go to the "Bot" Tab:** On the left side of the screen, click on the "Bot" tab.
4.  **Create a Bot:** Click the "Add Bot" button and confirm by clicking "Yes, do it!".
5.  **Get Your Token:** You'll now see a "token" for your bot. Click the "Copy" button to copy it. You'll need this in a moment.

### Step 2: Setting up the Bot on Your Computer

Now that you have your bot's token, it's time to get the bot's files ready on your computer.

1.  **Open the `config.py` file:** This file is in the same folder as this `README.md` file. You can open it with any text editor.
2.  **Add Your Token:** Inside this file, you'll see a line that says `TOKEN = "YOUR_BOT_TOKEN_HERE"`. Replace `"YOUR_BOT_TOKEN_HERE"` with the token you copied from the Discord Developer Portal. Make sure to keep the quotation marks!
3.  **(Optional) Get a Gemini API Key:** If you want the bot to give you more detailed fortunes, you can get a Gemini API key. You can find instructions on how to get one by searching for "Google AI Studio" on the web. Once you have your key, replace `"YOUR_GEMINI_API_KEY_HERE"` in the `config.py` file with your key.
4.  **(Optional) Give Your Fortune Teller a Name:** You can change the name of the fortune teller by changing the `COMMAND_NAME` in the `config.py` file. For example, you could change it to `COMMAND_NAME = "Zoltar"`. This will make the bot's messages look like "Zoltar says:" instead of "fortune says:".
5.  **(Optional) Set a Command Shortcut:** You can also set a shortcut for the bot's command by changing the `COMMAND_ALIAS` in the `config.py` file. For example, you could set it to `COMMAND_ALIAS = "ft"`.

### Step 3: Running the Bot

Now for the exciting part! It's time to start the bot.

1.  **Open a terminal or command prompt:** This is a program on your computer that lets you type in commands.
2.  **Navigate to the bot's folder:** Use the `cd` command to go to the folder where you saved the bot's files.
3.  **Install the bot's dependencies:** Type the following command and press Enter:
    ```bash
    pip install discord.py google-generativeai
    ```
4.  **Start the bot:** Type the following command and press Enter:
    ```bash
    python bot.py
    ```

You should see a message in your terminal that says the bot has connected to Discord. You'll also see an invite link that you can use to add the bot to your Discord server!

## Features

*   **Rate Limiting:** To prevent spam, you can only use the fortune command 3 times every 60 seconds.
*   **Input Limiting:** Your question must be less than 200 characters long.
*   **Gemini Integration:** The bot can use the Gemini API to give you more interesting and creative fortunes.

## Running the Bot in the Background (for advanced users)

If you want the bot to keep running even after you close your terminal, you can use a tool to run it in the background.

**For Linux and macOS users**, the included `startbot.sh` script is a convenient way to manage the bot. It uses a program called `tmux` to run the bot in a persistent session.

**For Windows users**, the included `startbot.bat` script provides a powerful way to start, stop, and manage the bot in the background without needing to keep a command prompt window open.

### `startbot.sh` (Linux/macOS)

#### Requirements

*   **tmux:** You'll need to have `tmux` installed on your system. You can usually install it with your system's package manager (e.g., `sudo apt-get install tmux` on Debian/Ubuntu).

#### Setup

1.  **Edit the script:** Open the `startbot.sh` file and replace `/REPLACE/WITH/FULL/PATH` with the full path to the bot's folder.

#### Usage

*   **Start the bot:** `./startbot.sh start`
*   **Stop the bot:** `./startbot.sh stop`
*   **Restart the bot:** `./startbot.sh restart`
*   **Check the bot's status:** `./startbot.sh status`
*   **Attach to the bot's session:** `./startbot.sh attach`

### `startbot.bat` (Windows) # This script was generated by AI and as of 8/11 is untested.

#### Setup

1.  **Edit the script:** Open the `startbot.bat` file in a text editor.
2.  **Set the bot directory:** Find the line `set "BOT_DIR=C:\path\to\bot"` and replace `C:\path\to\bot` with the full path to your bot's folder. To easily get the path, you can right-click the folder in Windows Explorer and select "Copy as path".

#### Usage

You can run the script from Command Prompt or PowerShell.

*   **Start the bot:** `.\startbot.bat start`
*   **Stop the bot:** `.\startbot.bat stop`
*   **Restart the bot:** `.\startbot.bat restart`
*   **Check the bot's status:** `.\startbot.bat status`
*   **Get the invite link:** `.\startbot.bat invite` (This will also copy it to your clipboard)
*   **View the log file:** `.\startbot.bat viewlog` (This opens the log in Notepad)

## Troubleshooting

*   **"Invalid Token" error:** This usually means that the token in your `config.py` file is incorrect. Double-check that you copied the token correctly from the Discord Developer Portal.
*   **The bot isn't responding:** Make sure the bot is running in your terminal and that you've invited it to your server. You can also try restarting the bot.
*   **"command not found" error:** If you get an error like "pip: command not found" or "python: command not found", it means that Python is not installed or not in your system's PATH. You can download Python from the official Python website.
