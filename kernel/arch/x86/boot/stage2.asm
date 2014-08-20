section .stage2
use16

global stage2_start

stage2_start:
_start:
  jmp start

%include "stdio.h"

message_got_there: db `Got There!\r\n`, 0

start:
  mov si, message_got_there
  call puts16
  jmp $