#!/bin/bash
pactl set-card-profile alsa_card.pci-0000_05_00.0 output:analog-surround-50;pactl set-sink-port alsa_output.pci-0000_05_00.0.analog-surround-50 "analog-output-lineout;output-headphones";pactl set-card-profile alsa_card.pci-0000_05_00.0 pro-audio;sleep 2;pactl set-sink-volume @DEFAULT_SINK@ 13%
