QEMU 					?= qemu-system-i386
QEMU_FLAGS		?= -boot order=dca --no-kvm -k en-us
QEMU_MEMORY		?= 32

ISO_IMAGE			?= rustix.iso

.PHONY: all run clean all_kernel clean_kernel

all: all_kernel

all_kernel:
	@ cd kernel && $(MAKE) all

clean: clean_kernel

clean_kernel:
	@ cd kernel && $(MAKE) clean

run:
	@ $(QEMU) $(QEMU_FLAGS) -m $(QEMU_MEMORY) -cdrom kernel/$(ISO_IMAGE) -serial stdio


