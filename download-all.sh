#!/bin/bash

#set -x
DOWNLOAD_TYPE=${1:-avif}

curl --retry 3 --silent --show-error --fail --time-cond data/api.json --continue-at - --location --remote-time --output data/api.json "https://googlefonts.github.io/noto-emoji-animation/data/api.json"

case "$DOWNLOAD_TYPE" in
	lottie)
		FILENAME="lottie.json"
		EXTENSION="json"
		;;
	gif|webp|avif)
		FILENAME="512.$DOWNLOAD_TYPE"
		EXTENSION="$DOWNLOAD_TYPE"
		;;
	all)
		"$0" gif
		"$0" webp
		"$0" avif
		"$0" lottie
		exit 0
		;;
	default)
		echo "Unknown download type $DOWNLOAD_TYPE"
		return 1
esac
mkdir -p "data/$DOWNLOAD_TYPE"
jq -r '.icons[] |
  .codepoint + " " +
  (
    # Simplify tag
    .tags[0]
    | ascii_downcase
    | gsub("[\":\\[\\]!?]"; "")
    | gsub(" "; "-")
  ) + (
    # Support skin tone variants
    .codepoint
    | ascii_downcase
    | reduce scan("_1f3f[b-f]") as $match ("";
        . + {
          "_1f3fb": "-skin-2",
          "_1f3fc": "-skin-3",
          "_1f3fd": "-skin-4",
          "_1f3fe": "-skin-5",
          "_1f3ff": "-skin-6"
        }[$match]
      )
  )' data/api.json | xargs -n2 /bin/bash -c "echo \$1; curl -LJ --silent --show-error --fail -o \"data/$DOWNLOAD_TYPE/\$1.$EXTENSION\" https://fonts.gstatic.com/s/e/notoemoji/latest/\$0/$FILENAME ; sleep 1"
