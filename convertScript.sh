#!/bin/bash
#source $HOME/.bash_profile

outputDir="./h265vids/"
CRF="22"
FILE_TYPES=("avi" "mp4" "mkv")
PROCESS_PATH="/plex/plex/adult/tv/" #MAKE SURE YOU HAVE / AT END
EXCLUDE_DIRS=("./Greatest Events of WWII in Colour/")
cd "$PROCESS_PATH"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

[ ! -d "$outputDir" ] && mkdir -p "$outputDir"

#echo "testing " "$outputDir/completed.lock"
if [ -f "$outputDir/completed.lock" ]; then
		echo "area already converted.  Exiting"
		exit 0
fi

FILE_FLAGS=""
len=${#FILE_TYPES[@]}
last=$((len-1))

for ((i=0; i<$len;i++))
do
	
		if [ "$len" -eq "1" ]; then
			FILE_FLAGS="${FILE_FLAGS} -name \"*.${FILE_TYPES[i]}\""
			continue
		fi

		if [ "$i" -eq "$last" ]; then
			FILE_FLAGS="${FILE_FLAGS} -name \"*.${FILE_TYPES[i]}\""
		else
			FILE_FLAGS="${FILE_FLAGS} -name \"*.${FILE_TYPES[i]}\" -o"
		fi
done


IGNORE_DIR_FLAGS=""
IGNORE_DIR_FLAGS="-not -path \"${outputDir}*\" -prune"

#parse exclude dirs array into find command arguments
for i in "${EXCLUDE_DIRS[@]}"
do
		IGNORE_DIR_FLAGS="${IGNORE_DIR_FLAGS} -not -path \"${i}*\" -prune"
done

MY_COMMAND="/usr/bin/find . -type f ${FILE_FLAGS} ${IGNORE_DIR_FLAGS} -print0 | sort"
echo "My command = ${MY_COMMAND}"
#/usr/bin/find . -type f  -name "*.avi" -o -name "*.mp4" -o -name "*.mkv" -not -path "./Greatest Events of WWII in Colour/*" -prune -not -path "./h265vids/*" -prune -print0

MY_RESULTS=("")
mapfile -d $'\0' MY_RESULTS < <(eval "$MY_COMMAND")

#for f in `find . -type f -name "*.avi" -o -name "*.mp4" -o -name "*.mkv" -not -path ${PROCESS_PATH}${outputDir} | sort`;
for f in "${MY_RESULTS[@]}"
do
  	audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
		videoformat=$(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")

  	if [ "$videoformat" = "hevc" ]; then
			echo "${f} is already hevc encoded - skipping."
			continue
		fi

		MYFILE=$(basename "$f")
		FILESIZE=$(stat -c%s "$f")
		echo "Base filesize: ${FILESIZE}"
		
		if [ "$audioformat" = "aac" ]; then
			#/usr/bin/ffmpeg -y -i "$f" -c:v libx265 -x265-params crf="$CRF" -c:a copy "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
			/usr/local/bin/ffpb -y -i "$f" -map_chapters 0 -map_metadata 0 -c:s copy -c:v libx265 -x265-params crf="$CRF" -c:a copy "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
		else
			#/usr/bin/ffmpeg -y -i "$f" -c:v libx265 -x265-params crf="$CRF" -c:a aac "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
			/usr/local/bin/ffpb -y -i "$f" -map_chapters 0 -map_metadata 0 -c:s copy -c:v libx265 -x265-params crf="$CRF" -c:a aac "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
		fi

		#echo "running mv ${outputDir}${MYFILE%.*}.x265.mkv" $(dirname "$f")

		myDir=$(dirname "$f")
		NEWFILESIZE=$(stat -c%s "${outputDir}${MYFILE%.*}.x265.mkv")
		echo "New filesize: ${NEWFILESIZE}"
		CMD="mv ${outputDir}${MYFILE%.*}.x265.mkv \"${myDir}\""
		echo "Running ${CMD}"
		eval "$CMD"
		#  mv "$PROCESS_PATH""$outputDir/""${MYFILE%.*}.x265.mkv" $(dirname "$f")
		CMD="mv \"${f}\" ${outputDir}"
		echo "Running ${CMD}"
		eval "$CMD"

		if [ "$FILESIZE" -lt "$NEWFILESIZE" ]; then
			echo "WARNING: ${f} is smaller than its converted form." >> CONVERTFILE.WARNINGS.txt
		fi

		#  mv "$f" "$PROCESS_PATH""$outputDir"
done

touch "$outputDir/completed.lock"
IFS=$SAVEIFS
