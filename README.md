# Noto Animation for Slack

This is a workspace of scripts to convert [Noto Animated Emoji](https://googlefonts.github.io/noto-emoji-animation/) for consumption by Slack.

# Download

[Download the pack here](TODO).

# Behind the scenes

As of 2025-11-22, the repo containing the data is [private](https://github.com/googlefonts/noto-emoji-animation); here is a set of scripts to download the data, convert it into a format acceptable by slack, and ready to be uploaded with [emojme](https://github.com/jackellenberger/emojme).

# Dependencies

 - [ffmpeg](https://www.ffmpeg.org/)
 - [gifski](https://github.com/ImageOptim/gifski), but [using my fork](https://github.com/anisse/gifski).
 - jq, curl, and other small tools.

# Preview

The pack contains 714 gifs. Here is a small preview:
![Pack preview](./assets/preview.gif)
