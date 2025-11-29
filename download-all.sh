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

# jq -cr '.icons[] | [ .tags[0], .codepoint ]' < data/api.json \
# 	| tr -d '":][!?' \
# 	| tr " " "-" \
# 	| tr "[:upper:]" "[:lower:]" \
# 	| gawk -F "," '@load "ordchr"; {
# 		tag = $1;
# 		codepoint = $2;
#
# 		count = patsplit(codepoint, colors, /_1f3f./);
# 		color = "";
# 		for (i = 1; i <= count; i++) {
# 			switch (colors[i]) {
# 				case /_1f3fb/: color = color "-skin-2"; break;
# 				case /_1f3fc/: color = color "-skin-3"; break;
# 				case /_1f3fd/: color = color "-skin-4"; break;
# 				case /_1f3fe/: color = color "-skin-5"; break;
# 				case /_1f3ff/: color = color "-skin-6"; break;
# 			}
# 		}
# 		outname = tag color "'".$EXTENSION"'";
# 		system("echo "outname"; curl -LJ --silent --show-error --fail -o \"data/'"$DOWNLOAD_TYPE"'/"outname"\" https://fonts.gstatic.com/s/e/notoemoji/latest/"codepoint"/'"$FILENAME"' ; sleep 1");
# }'
