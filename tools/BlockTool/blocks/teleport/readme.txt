Teleport to Specified Level (TTSL) - Teo17

This block will act like a door or a teleport
block and it will teleport you to the level
specified in the ASM file. Change this:

!Level = $0103

To the level you want the block to teleport to.
Remember to make it always 4-digit value, so
level 127 becomes 0127 and level 1B becomes 001B.
Otherwise it won't work. You can make it act like
a door or a teleport block. In ASM file, you have:

!Property = !Door

Here, you input the property. If you want to make
the block act like a normal door which teleports
you to the level specified in the ASM file,
write "!Door", which is actually wrote. If you
want it to act like a teleport block that also
teleports you to the specified level, remove the
"!Door" and write "!Block". Any other property will
give an error so use "!Door" or "!Block".

And make it act like tile 25!