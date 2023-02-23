#!/bin/bash -x
# DSP Innovations demo files - TWELP and MELPe

CODEC2=${HOME}/codec2
CODEC2_WAV=${CODEC2}/wav
PATH=$PATH:${CODEC2}/build_linux/src:${CODEC2}/build_linux/misc
DSPINI=${HOME}/Downloads/dspini
OUT_DIR=230222
gain=13
N0=-40

function extract() {
    sox $DSPINI/$1/a_eng_8.wav ${OUT_DIR}_${5}/${2}.wav trim $3 $4
}

function extract_hpf() {
    sox $DSPINI/$1 $OUT_DIR/$2
}

function c2_1200() {
    sox  $DSPINI/$1/a_eng_8.wav -t .s16 - trim $3 $4 | hpf | \
    c2enc 1200 - - | \
    c2dec 1200 - - | sox -t .s16 -r 8000 -c 1 - ${OUT_DIR}_1200/${2}.wav
}

function c2_700C() {
    sox  $DSPINI/$1/a_eng_8.wav -t .s16 - trim $3 $4 | hpf | \
    c2enc 700C - - | \
    c2dec 700C - - | sox -t .s16 -r 8000 -c 1 - ${OUT_DIR}_600/${2}.wav
}

# Approximation of Hilbert clipper type compressor.  Could do with some HF boost
function analog_compressor {
    input_file=$1
    output_file=$2
    gain=$3
    cat $input_file | ch - - 2>/dev/null | \
    ch - - --No -100 --clip 16384 --gain $gain 2>/dev/null | \
    # final line prints peak and CPAPR for SSB
    ch - - --clip 16384 |
    # manually adjusted to get similar peak levels for SSB and FreeDV
    sox -t .s16 -r 8000 -c 1 -v 0.5 - -t .s16 $output_file
}

function ssb_hi() {
    tmp1=$(mktemp)
    tmp2=$(mktemp)
    sox  $DSPINI/$1/a_eng_8.wav -t .s16 $tmp1 trim $3 $4
    analog_compressor $tmp1 $tmp2 $gain
    ch $tmp2 - --No -40 | sox -t .s16 -r 8000 -c 1 - ${OUT_DIR}_${5}/${2}.wav
}
 
function ssb_low() {
    tmp1=$(mktemp)
    tmp2=$(mktemp)
    sox  $DSPINI/$1/a_eng_8.wav -t .s16 $tmp1 trim $3 $4
    analog_compressor $tmp1 $tmp2 $gain
    ch $tmp2 - --No -30 --impulse 1000 | sox -t .s16 -r 8000 -c 1 - ${OUT_DIR}_${5}/${2}.wav
}
 
function process_sample() {
    n=$1
    st=$2
    en=$3

    extract p50_source ${n}_1 $st $en 1200
    extract melpe_1200 ${n}_2_melpe_1200 $st $en 1200
    extract twelp_1200 ${n}_3_twelp_1200 $st $en 1200
    c2_1200 p50_source ${n}_4_codec2_1200 $st $en
    ssb_hi p50_source ${n}_6_ssb $st $en 1200
    
    extract p50_source ${n}_1 $st $en 600
    extract melpe_600 ${n}_2_melpe_600 $st $en 600
    extract twelp_600 ${n}_3_twelp_600 $st $en 600
    c2_700C p50_source ${n}_4_codec2_700C $st $en
    ssb_low p50_source ${n}_6_ssb $st $en 600
}

mkdir -p ${OUT_DIR}_1200
mkdir -p ${OUT_DIR}_600

process_sample ship 0 3
process_sample tea 60 4
process_sample sickness 122 2.5
process_sample pickle 180 3
