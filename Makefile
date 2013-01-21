SHELL=/bin/bash

TARGETS=nyan.mbr nyan.img nyan_io.mbr nyan_io.img nyan_nosync.mbr nyan_nosync.img
OBJS=$(patsubst %.img, %.o, $(TARGETS))

all: $(TARGETS)

%.o: %.s
	as -o $@ $<

%.img: %.mbr
	dd if=/dev/zero of=$@ count=510 bs=1
	printf "\125\252" >> $@
	dd if=$< of=$@ conv=notrunc

%.mbr: %.o
	ld --oformat binary -Ttext 0x7c00 -o $@ $< 
	echo 'mbr max size test'; test -z $$( (stat -c "%s" $@; echo 'd446 [p]sa<a')|dc)

clean:
	-rm $(TARGETS) $(OBJS)
