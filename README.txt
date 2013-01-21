
NYAN ALL THE MBRs!

a 16 bit Nyan cat demo small enough to fit in the master boot record
of a disk.

BEFORE YOU CONTINUE: USE ON YOUR OWN RISK, PLAYING WITH MBRs IS LIKE PLAYING
WITH FIRE. DO NOT BE ON FIRE!

Usage:

 1) dd if=nyan.mbr of=/dev/usbstick # USE THE .mbr, NOT THE .img, IT WILL OVERWRITE
                                    # THE PARTITION TABLE!
 2) and boot from the stick

 3) INSTANT WIN!

or:

 qemu -hda nyan.img # does flicker a bit since wait for sync does not work

For more info in MBR demos:

 http://io.smashthestack.org:84/intro/

Erik
