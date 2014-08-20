check_a20:
  pushf
  push ds
  push es
  push di
  push si

  cli

  xor ax, ax ; ax = 0
  mov es, ax

  not ax ; ax = 0xffff
  mov ds, ax

  mov di, 0x0500
  mov si, 0x0510

  mov al, byte [es:di]
  push ax

  mov al, byte [ds:si]
  push ax

  mov byte [es:di], 0x00
  mov byte [ds:si], 0xff

  cmp byte [es:di], 0xff

  pop ax
  mov byte [ds:si], al

  pop ax
  mov byte [es:di], al

  mov ax, 0x00
  je .check_a20__exit

  mov ax, 0x01

.check_a20__exit:
  pop si
  pop di
  pop es
  pop ds
  popf

  ret