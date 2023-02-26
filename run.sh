dotnet tool install --verbosity quiet --global unity-packer --version 2.1.3

shopt -s nocasematch
if [[ $INPUT_COMMAND == "pack" ]]; then
	if ! echo '$INPUT_PACK_MAP' | jq -e '.' > /dev/null; then
		echo "Error: The provided input 'pack-map' is invalid. Check for proper JSON format." >&2
        exit 1
	fi
	
	for entry in $(echo '$INPUT_PACK_MAP' | jq -c 'to_entries[]'); do
		KEY=$(echo $entry | jq -r '.key')
		VALUE=$(echo $entry | jq -r '.value')
		INPUTS+=" "$KEY" "$VALUE""
	done
	
	unity-packer pack "$INPUT_PACKAGE$INPUTS"
else if [[ $INPUT_COMMAND == "unpack" ]]; then
	unity-packer unpack $INPUT_PACKAGE $INPUT_UNPACK_DIRECTORY
else
	echo "Error: Command '$INPUT_COMMAND' is not an valid command, use command 'pack' or 'unpack'." >&2
	exit 1
fi