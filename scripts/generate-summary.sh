#/bin/bash

# This script will find summary words, and merge for output
# We still have to clear the gap between the words.
#

sound_dir=../src/justin-ios-client/sound
raw_dir=../mp3-raw

mkdir -p ${raw_dir}/accel

declare -a summary1=("eat" "mat" "bathroom" "fix" "walk" "music" "drink" "different")

exists()
{
    utilname=$1
    util=$(which $utilname)
    [[ ! -e ${util} ]] && {
	echo "${utilname} is not installed, or not found in the path."
	exit 1
    }
}
exists ffmpeg
exists mp3wrap     # Well, ffmpeg can also concat:  "search:  and find askubuntu.com" answer.
exists sox

accel_rate=1.8    # 80% faster
generate_accel()
{
    fname=$1
    [[ -z $fname ]] && {
	echo "Need parameter (abspath for raw-word mp3 file)"
	exit 2
    }
    word=$(basename ${fname})
    word=${word%.mp3}

    accelerated_word=${raw_dir}/accel/${word}.mp3
    if [[ ! -e ${accelerated_word} ]]; then
	sox --show-progress ${fname}  ${accelerated_word} tempo ${accel_rate}
    fi
}

abspath_summary1=
for mp3 in "${summary1[@]}"; do
    generate_accel ${raw_dir}/${mp3}.mp3
    abspath_summary1="${abspath_summary1}  ${raw_dir}/accel/${mp3}.mp3"
done
mp3wrap  ${sound_dir}/summary-1.mp3  ${abspath_summary1}
mv ${sound_dir}/{summary-1_MP3WRAP.mp3,summary-1.mp3}
