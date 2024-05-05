#/bin/bash

sound_dir=../src/justin-ios-client/sound
raw_dir=../mp3-raw

set -e

mkdir -p ${raw_dir}/accel

declare -a summary1=("eat" "music" "bathroom" "drink" "stop" "toy" "go" "different")

exists()
{
    utilname=$1
    util=$(which $utilname)
    [[ -z ${util} ]] && {
	echo "${utilname} is not installed, or not found in the path."
	exit 1
    }
}
# We can generate summary, from Linux box and check-in.
exists ffmpeg
exists mp3wrap     # Well, ffmpeg can also concat:  "search:  and find askubuntu.com" answer.
exists sox

#accel_rate=1.6    # 60% faster
accel_rate=2       # twice as fast
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
for mp3 in "${arr[@]}"; do
    generate_accel ${raw_dir}/${mp3}.mp3
    abspath_summary1="${abspath_summary1}  ${raw_dir}/accel/${mp3}.mp3"
done
mp3wrap  ${sound_dir}/summary-1.mp3  ${abspath_summary1}
