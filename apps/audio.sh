#!/usr/bin/env sh
# Enables sound
amixer cset name='Headphone Switch' on
amixer cset name='Speaker Switch' on
amixer cset name='Headphone Playback Volume' 10,10
amixer cset name='Right Headphone Mixer Right DAC Switch' on
amixer cset name='Left Headphone Mixer Left DAC Switch' on
amixer cset name='DAC Playback Volume' 999,999
amixer cset name='Headphone Mixer Volume' 999,999

# Enables micro
amixer sset "Dmic0" 70
amixer sset "Dmic1 2nd" 70
