.def ResL   = r2
.def ResH   = r3
.def ResVH  = r4

.def multiplierLReg = r16
.def multiplierHReg = r17
.def multiplier8Reg = r18

.equ multiplier16 = 0x2f8
.equ multiplier8 = 0x19

multiply:
   ldi multiplierHReg, high(multiplier16)   ; upper 8 bits of m1 to multiplierHReg
   ldi multiplierLReg, low(multiplier16)     ; lower 8 bits of m1 to multiplierLReg
   ldi multiplier8Reg, multiplier8           ; 8-bit constant to multiplier8Reg

   mul multiplierLReg, multiplier8Reg     ; Multiply 0xf8 and 0x19

   mov ResL, r0    ; copy result          ;  0x38
   mov ResH, r1    ; to result registers  ;  0x18

   mul multiplierHReg, multiplier8Reg     ; Multiply 0x2 and 0x19

   mov ResVH,r1  ; copy upper 8 bit of last mul result               ; in this example 0x00
   add ResH,r0   ; add lower 8 bit of last mul result to result ResH ; 0x32 + 0x18 = 0x4a
   brcc noCarry  ; if no carry, jump
   inc ResVH     ; if is carry increment highest register ; in this example ResVH does not used

   noCarry:
       ;result in { ResHH : ResH : ResL } => { 0x00 : 0x4a : 0x38 } => 0x4a38
ret
