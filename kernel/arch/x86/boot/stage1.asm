section .stage1
use16

_start:
  jmp loader

message_stage1: db `Starting stage1...\r\n`, 0
message_stage2: db `Jumping to stage2...\r\n`, 0
message_a20_enabled: db `A20 Enabled\r\n`, 0
message_a20_disabled: db `A20 Disabled\r\n`, 0
disk_error_message: db `Could not read disk\r\n`, 0

%include "stdio.h"
%include "a20.h"

extern stage2_start

loader:
  ; Zero all necessary segments 
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  mov si, message_stage1
  call puts16

  ; deal with A20 
  call check_a20

  cmp ax, 0
  jne a20_enabled

  mov si, message_a20_disabled
  call puts16
  jmp a20_disabled

a20_enabled:
  mov si, message_a20_enabled
  call puts16

a20_disabled:
  ; Load stage 2 from disk using int 0x13 
  mov ah, 0
  mov dl, 0
  int 0x13
  jc error

  mov bx, 0x0000
  mov es, bx

  mov bx, 0x7e00

  ; uses int 0x13 function 2 to read sectors from floppy 
  mov ah, 0x02
  mov al, 0x02 ; Number of sectors to read 
  mov ch, 0x00 ; Start on track 0 
  mov cl, 0x02 ; start on sector 2 
  mov dh, 0x00 ; start on head 0 
  mov dl, 0x00 ; drive number 
  int 0x13
  jc error ; Carry flag indicates an error 

  mov si, message_stage2
  call puts16

  jmp stage2_start ; jump to stage 2

error:
  mov si, disk_error_message
  call puts16
  jmp $

  ; Last bytes must be 0xaa55 to mark this as bootable 
  times 510-($-$$) db 0
  db 0x55
  db 0xaa