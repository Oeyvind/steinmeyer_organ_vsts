The Ruckpositiv can be coupled to manual 1,2,3 or pedal.
Switches to enable coupling is on the left side of the keyboard for each manual.
The midi prog numbers for this are quirky, and as follows:
    - Ruck M1:  ch 1, prog 72 and 73
    - Ruck M2:  ch 2, prog 70 and 71
    - Ruck M3:  ch 3, prog 74 and 75
    - Ruck Ped: ch 8, prog 76 and 77
* In the sequencer we use prog number 99 to enable ruckpos coupling (use midi channel to set which manual is coupled)
... and the correct midi prog is sent (as in the list above)

Then, to make registration for the ruckpos, prog change on channel 4 is used
The first ruckpos register is button 135 on the physical organ console
The prog number for the first ruckpos stop is 36 on ch 4
In the sequencer, channels 1,2,3,8 should be able to make registration for the ruckpos,
...so we use prog number 101 upwards (to 112) on any channel to send registration for the ruckpos
... this is mapped internally to prog change 36 (and upwards) on channel 4, so we send the correct message to the organ
