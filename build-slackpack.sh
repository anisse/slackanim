#!/bin/bash

set -euo pipefail

PREFIX="anim-"

# Download all as gifs
./download_all.sh gif

mkdir -p slack_pack
cd slack_pack

# Generate import file
find ../data/gif/ -type f | jq -Rn '[
					inputs
					| (sub(".*/"; "") | sub("\\.[^.]*$"; "")) as $basename
					| { "src": ($basename + ".gif"), "name": ("'$PREFIX'" + $basename)}
				    ]' > emoji.json

# Generate aliases
jq -r '[
	.icons[]
	|.codepoint as $cp
	|.tags
	| map(
		(
			ascii_downcase
			| gsub("[\":\\[\\]!?]"; "")
			| gsub(" "; "-")
			) + (
				# Support skin tone variants
				$cp
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
		)
	)
	| .[0] as $name
	| .[1:]
	| map(select(. != ""))
	| map({
		"name": ("'$PREFIX'" + .),
		"is_alias": 1,
		"alias_for": ("'$PREFIX'" + $name)
	})
	| .[]
   ]' ../data/api.json > aliases.json

# Convert gifs with gifski
find ../data/gif/ -type f -print0 | xargs -0 -n1 "-P$(nproc)" ../gifski-slack

# Add preview html
echo -n *.gif | xargs -d\  -I{} echo '<img src="{}">' > preview.htm
