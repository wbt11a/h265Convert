#!/bin/bash
#source $HOME/.bash_profile

outputDir="h265vids"
CRF="22"
PROCESS_PATH="/plex/plex/adult/tv/"
cd "$PROCESS_PATH"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

[ ! -d "$outputDir" ] && mkdir -p "$outputDir"

#echo "testing " "$outputDir/completed.lock"
if [ -f "$outputDir/completed.lock" ]; then
        echo "area already converted.  Exiting"
        exit 0
fi

for f in `find . -type f -name "*.avi" -o -name "*.mp4" -o -name "*.mkv" -not -path ${PROCESS_PATH}${outputDir}`;
do
        audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
        videoformat=$(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
        if [ "$videoformat" = "hevc" ]; then
                        echo "${f} is already hevc encoded - skipping."
                continue
        fi
        MYFILE=$(basename "$f")
        if [ "$audioformat" = "aac" ]; then
                #/usr/bin/ffmpeg -y -i "$f" -c:v libx265 -x265-params crf="$CRF" -c:a copy "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
                /usr/local/bin/ffpb -y -i "$f" -c:v libx265 -x265-params crf="$CRF" -c:a copy "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
        else
                #/usr/bin/ffmpeg -y -i "$f" -c:v libx265 -x265-params crf="$CRF" -c:a aac "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
                /usr/local/bin/ffpb -y -i "$f" -c:v libx265 -x265-params crf="$CRF" -c:a aac "$PROCESS_PATH""$outputDir"/"${MYFILE%.*}.x265.mkv"
        fi

        echo "running mv ${PROCESS_PATH}${outputDir}/${MYFILE%.*}.x265.mkv" $(dirname "$f")
        mv "$PROCESS_PATH""$outputDir/""${MYFILE%.*}.x265.mkv" $(dirname "$f")
        echo "running mv ${f} ${PROCESS_PATH}${outputDir}"
        mv "$f" "$PROCESS_PATH""$outputDir"
done
touch "$outputDir/completed.lock"
IFS=$SAVEIFS
