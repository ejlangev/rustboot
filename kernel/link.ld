SECTIONS
{
  . = 0x7c00;
  .stage1 : { *(.stage1) }

  . = 0x7e00;
  .stage2 : { *(.stage2) }
}