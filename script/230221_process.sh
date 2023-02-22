#!/bin/bash -x

CODEC2=${HOME}/codec2
CODEC2_WAV=${CODEC2}/wav
PATH=$PATH:${CODEC2}/build_linux/src:${CODEC2}/build_linux/misc
OUT_DIR=230221

function orig() {
    cp $CODEC2_WAV/$1 $OUT_DIR/$2
}

function ambe_2400() {
    cp $CODEC2_WAV/$1 $OUT_DIR/$2
}

# same freq response as Codec 2 sample, simulating small speaker
function ambe_2400_hpf() {
    sox $CODEC2_WAV/$1 -t .s16 - | hpf | sox -t .s16 -r 8000 -c 1 - $OUT_DIR/$2
}

function c2_2400() {
    sox $CODEC2_WAV/$1 -t .s16 - | hpf | c2enc 2400 - - | \
    c2dec 2400 - - | sox -t .s16 -r 8000 -c 1 - $OUT_DIR/$2
}

orig          morig.wav morig_1.wav
ambe_2400     m2400.wav morig_2_ambe_2400.wav
ambe_2400_hpf m2400.wav morig_3_ambe_2400_hpf.wav
c2_2400       morig.wav morig_4_c2_2400.wav

orig          forig.wav forig_1.wav
ambe_2400     f2400.wav forig_2_ambe_2400.wav
ambe_2400_hpf f2400.wav forig_3_ambe_2400_hpf.wav
c2_2400       forig.wav forig_4_c2_2400.wav

