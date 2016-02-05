#!/bin/bash

# posix only! no perl so no \w or \d
# https://www.debuggex.com/r/qR-a2o6k5Ykqqr-9
readonly regex='(https?://github.com/)([A-Z|a-z|0-9|-]+)(/)([A-Z|a-z|0-9|-]+)(/)?'

if [[ $1 =~ $regex ]] ; then
	readonly url=$1
	readonly owner=${BASH_REMATCH[2]}
	readonly repository=${BASH_REMATCH[4]}
	readonly ownerUrl=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
	
	readonly json=$(curl -is "https://api.github.com/repos/$owner/$repository")
	readonly description=$(echo -e "$json" | grep -Po '"description":.*?[^\\]",' | cut -c 17- | rev | cut -c 3- | rev)

	echo "[$repository]($url) - $description (by [@$owner]($ownerUrl))"
else
	echo "${1} is not valid"
	echo "Usage: ./attrithub.sh https://github.com/{owner}/{repository}" 