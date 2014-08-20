puts16:
  pusha ; save registers
  mov bh, 0x00
  mov bl, 0x07
.loop:
  lodsb ; load next byte from si into al and increment si
  or al, al ; is al 0? (the null terminator)
  jz .done ; finished if we hit the null terminator
  mov ah, 0x0e
  int 0x10
  jmp .loop
.done:
  popa
  ret