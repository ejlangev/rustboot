
LDFLAGS				?= -m elf_i386 -z nodefaultlib

ASM						?= nasm
ASMFLAGS			?= -g -f elf32

READELF				?= readelf

OBJS					?= $(BDIR)/stage1.o $(BDIR)/stage2.o


SRCDIR			:=	arch/x86/boot
SRC					:= $(foreach dr, $(SRCDIR), $(wildcard $(dr)/*.asm))
OBJS				:= $(addsuffix .o, $(basename $(SRC)))

ifneq "$(shell which mkisofs 2>/dev/null)" ""
    MAKEISO := mkisofs
else
    MAKEISO := genisoimage
endif

BSYMBOLS		:= symbols.dbg
SYMBOLS			:= rustix.dbg
KERNEL 			:= rustix.bin
IMAGE 			:= rustix.img
ISO_IMAGE 	:= rustix.iso


.PHONY: all clean

all: $(BSYMBOLS) $(ISO_IMAGE)

$(SYMBOLS): $(OBJS)
	@ echo "  Linking for \"kernel/$@\"..."
	@ $(LD) $(LDFLAGS) -T link.ld $^ -o $@

$(BSYMBOLS): $(SYMBOLS)
	@ echo "  Generating kernel symbols list..."
	@ $(READELF) -s $(SYMBOLS) | grep -Ev 'SECTION|UND|FILE|Num:|Symbol|^$$' | awk '{printf "0x%s %s\n", $$2, $$8}' > $@

$(KERNEL): $(SYMBOLS)
	@ echo "  Setting addresses for kernel stage 1 and stage 2..."
	@ objcopy -j .stage1 --set-section-flags .stage1=load --change-section-address .stage1=0 -O binary $< /tmp/temptemp
	@ cat /tmp/temptemp > rustix.bin
	@ objcopy -j .stage2 --set-section-flags .stage2=load --change-section-address .stage2=0 -O binary $< /tmp/temptemp
	@ cat /tmp/temptemp >> rustix.bin
	@ objcopy -O binary $< /tmp/temptemp
	@ cat /tmp/temptemp >> rustix.bin
	@ rm /tmp/temptemp # XXX find better solution than this

$(IMAGE): $(KERNEL)
	@ echo " Creating floppy disk image from kernel binary..."
	@ dd if=/dev/zero of=$@ bs=1024 count=1440 2> /dev/null
	@ dd if=$< of=$@ conv=notrunc 2> /dev/null

$(ISO_IMAGE): $(IMAGE)
	@ echo "  Creating \"kernel/$@\" from floppy disk image..."
	@ $(MAKEISO) -quiet -input-charset utf-8 -o $@ -b $< $<

%.o: %.asm
	@ echo "  Compiling \"kernel/$<\"..."
	@ $(ASM) $(ASMFLAGS) -I include/$(dir $<) -o $@ $<

clean:
	@ rm -f $(OBJS) $(SYMBOLS) $(BSYMBOLS) $(KERNEL) $(IMAGE) $(ISO_IMAGE)