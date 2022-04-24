#!/bin/bash

test_address=$((0x$(readelf -s hidden | grep ' test$' | awk -F '[ \t]+' '{print $3;}')))
success_message_address=$((0x$(readelf -s hidden | grep ' success_message$' | awk -F '[ \t]+' '{print $3;}')))
data_address=$((0x$(readelf -S hidden | grep ' .data ' | awk -F '[ \t]+' '{print $5;}')))
data_offset=$((0x$(readelf -S hidden | grep ' .data ' | awk -F '[ \t]+' '{print $6;}')))
test_offset=$((test_address - data_address + data_offset))
success_message_offset=$((success_message_address - data_address + data_offset))

printf "test_offset: 0x%x\n" "$test_offset"
printf "success_message_offset: 0x%x\n" "$success_message_offset"

cp hidden hidden_copy
echo -en "\x64\x00\x00\x00" | dd seek=$((test_offset)) bs=1 of=hidden_copy conv=notrunc 2> /dev/null
echo -en "success" | dd seek=$((success_message_offset)) bs=1 of=hidden_copy conv=notrunc 2> /dev/null
echo "Generated updated executable in hidden_copy."
