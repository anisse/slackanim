# Noto Animation for Slack

This is a workspace of scripts to convert [Noto Animated Emoji](https://googlefonts.github.io/noto-emoji-animation/) for consumption by Slack.

# Download

[Download the pack here](https://github.com/anisse/slackanim/releases/download/v0.0.1/slackanim-v0.0.1.zip).

# Behind the scenes

As of 2025-11-22, the repo containing the data is [private](https://github.com/googlefonts/noto-emoji-animation); here is a set of scripts to download the data, convert it into a format acceptable by slack, and ready to be uploaded with [emojme](https://github.com/jackellenberger/emojme).

# Dependencies

 - [ffmpeg](https://www.ffmpeg.org/)
 - [gifski](https://github.com/ImageOptim/gifski), but [using my fork](https://github.com/anisse/gifski).
 - jq, curl, and other small tools.

# Preview

The pack contains 714 gifs. Here is a small preview:
![Pack preview](./assets/preview.gif)

# Import into Slack

You can import them one by one, or use [emojme](https://github.com/jackellenberger/emojme) to import them:
```sh
# Get slack token with the following code in the browser slack js console: JSON.parse(localStorage.localConfig_v2).teams[document.location.pathname.match(/^\/client\/([TE][A-Z0-9]+)/)[1]].token
# Get the slack cookie by going into devtools and getting the "d" cookie
#
# Import all emojis. They will all have an anim- prefix to prevent collisions
npx emojme upload --subdomain <your slack subdomain-> -token <slack token starting with xoxc-> --cookie <slack cookie starting with xoxd-> --src emoji.json
# Import aliases. They will also have the anim- prefix
npx emojme upload --subdomain <your slack subdomain> --token <slack token starting with xoxc-> --cookie <slack cookie starting with xoxd-> --src aliases.json
