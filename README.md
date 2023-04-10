# Codec 2 Samples

A repo to capture snapshots of Codec 2 samples, together with reference samples from COTs codecs. Used for informal listening tests and as a record as the codec evolves.  

To listen to them on my Ubuntu Linux machine I arrange them in file browser window with all samples from one speaker on the same row, and [click on each file](https://www.rowetel.com/?p=7884) to play.

![file browser](file_browser.png)

# 230221 - AMBE and Codec 2 at 2400 bits/s

Using just two demo samples from the DVSI web site.  It would be nice to augment these with AMBE samples processed from independent source material.

Codec 2 is designed for digital radio applications that use small speakers (e.g. a HF radio or walkie talkie).  The loudspeakers in these radios do not pass low frequencies, with typical -3dB points of 300-500Hz.  Many analog radio systems (SSB and FM) filter speech between 300 and 3000 Hz.  These frequencies are not required for intelligible speech (e.g. telephone networks remove them). Arguably there is no point in spending precious bits to preserve these frequencies.  The LPC modelling used in the current 1200-3200 Codec 2 modes struggle with low frequencies, sometimes leading to unpleasant artefacts.  We are therefore proposing to add a high pass filter to Codec 2 to define it's frequency response to match our use case.
 
AMBE and other commercial codecs (e.g. MELP and TWELP) have been designed to encode low frequencies.  This can make them sound preferable when using a wide frequency response loudspeaker or good quality headphones, in particular with male speakers that have significant low frequency energy.  So this set of samples includes AMBE with and without a 200Hz (-6dB) cut off high pass filter to simulate using a small loudspeaker.

Try listening to them through a small loudspeaker, such as a laptop, as well as good quality headphones.

Sample 5 is an experimental candidate for a new 2400 bit/s mode, using a 3 stage VQ of the re-sampled log spectra from the `dr-papr` branch 9c78ca81 (`230204_three_dec experiment` in `ratek_resampler.sh`).  The spectrum is quantised with 27 bits every 20ms, or 1350 bits/s. It would be roughly 1900 bit/s when the side information (pitch and energy) is fully quantised.

# 230221 - MELPe, TWELP and Codec 2 at 1200 and 600/700 bits/s

MELPe and TWELP samples from the DSP Innovations web site.  The COTs codecs try to code the full 4 kHz, whereas the Codec 2 samples have a 200 Hz (-6dB) High Pass Filter as discussed above. The COTs codec samples have been left unfiltered in these examples.  Especially at low bit rates, we feel it is efficient to allocate bits to parts of the spectrum that will actually leave the loudspeaker in a typical use case.

Sample 5 in `230222_1200` uses an experimental 3 stage VQ to quantised with 27 bits every 30ms (900 bits/s), which with side information (pitch and energy) would result in a 1200 bits/s codec.

Sample 5 in the `230222_600` uses a single stage 12 bit VQ updated every 30ms to quantise the spectrum at 400 bits/s.  With side information (pitch and energy) a candidate 600-700 bits/s codec.

Sample 6 in both directories is a rough simulation of SSB in an AWGN channel, about 20dB SNR for the 1200 directory, and 8dB for the 600 directory, which also includes a simulation of impulse noise.  Both SSB signals are (Hilbert) compressed.  Very high SNR SSB (e.g. several S points above the noise) is effectively the codec input source material - this will be very hard to beat as model based codecs always introduce artefacts due to approximations in the model.  At high SNR it will come down to personal preference - those who tolerate the codec artefacts versus those who prefer the analog signal with it's background noise.

# 230410 - MELPe, TWELP and Codec 2 at 1200 and 600/700 bits/s

As per 230221, with some debugging of clicks, energy normalisation, 4 bit energy quantisation in sample 5. Pitch still unquantised. Sample 6 is sample 5 with Hilbert Compression (HC).  Note it sounds louder but there are no unpleasant clipping artefacts. From Codec 2 Git `92eaa5a`, samples 5 & 6 generated with `../script/ratek_resampler.sh vq_test_230331`


