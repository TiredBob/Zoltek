# Fortune Teller Bot

A Discord bot that tells your fortune.

## How it Works

The bot uses a d20 roll to determine the nature of the prophecy. If a Gemini API key is provided, the bot will use it to generate a more detailed and creative prophecy. Otherwise, it will provide a generic response.

## Setup

1.  **Create a virtual environment:**
    ```bash
    python -m venv .venv
    source .venv/bin/activate
    ```

2.  **Install dependencies:**
    ```bash
    pip install discord.py google-generativeai
    ```

3.  **Configure the bot:**
    - Open `config.py` and replace `"YOUR_BOT_TOKEN_HERE"` with your Discord bot token.
    - (Optional) If you have a Gemini API key, replace `"YOUR_GEMINI_API_KEY_HERE"` with your key to enable more detailed prophecies.
    - (Optional) You can change the command name by modifying the `COMMAND_NAME` variable in `config.py`. The default is `fortune`.
    - (Optional) You can set a command alias by modifying the `COMMAND_ALIAS` variable in `config.py`. The default is `ft`.

4.  **Run the bot:**
    ```bash
    python bot.py
    ```

## Important Configuration

### The Fortune Teller's Name

It is highly recommended that you change the `COMMAND_NAME` in `config.py`. This variable is used as the name of the fortune teller in the bot's output. The default value is `"fortune"`, which can lead to awkward phrasing like "fortune says:".

For a much better experience, change this to a name, for example:

```python
COMMAND_NAME = "Zoltar"
```

This will result in output like "Zoltar says:".

## Features

- **Rate Limiting:** The command is rate-limited to 3 uses per 60 seconds per user to prevent spam.
- **Input Limiting:** The user's question is limited to 200 characters.
- **Gemini Integration:** The bot can use the Gemini API to generate more detailed and creative prophecies.

## Running with startbot.sh

The `startbot.sh` script allows you to run the bot in a `tmux` session, so it will stay running in the background.

### Requirements

- **tmux:** You'll need to have `tmux` installed on your system. You can usually install it with your system's package manager (e.g., `sudo apt-get install tmux` on Debian/Ubuntu).

### Setup

1.  **Edit the script:**
    - Open `startbot.sh` and replace `/REPLACE/WITH/FULL/PATH` with the absolute path to the bot's directory.

### Usage

-   **Start the bot:**
    ```bash
    ./startbot.sh start
    ```
    The script will then print the bot's invite link to the console.
-   **Stop the bot:**
    ```bash
    ./startbot.sh stop
    ```
-   **Restart the bot:**
    ```bash
    ./startbot.sh restart
    ```
-   **Check the bot's status:**
    ```bash
    ./startbot.sh status
    ```
-   **Attach to the bot's tmux session:**
    ```bash
    ./startbot.sh attach
    ```

### Notes

- The script is designed to be run by a non-root user. If you run it with `cron` as `root`, the status checks may not work correctly.
- If you have trouble with the script, you can attach to the `tmux` session (`./startbot.sh attach`) and manually stop the bot with `Ctrl+C`.
