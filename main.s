// Place static data declarations/directives here
  		.data
  		
/* code 1 */
risc_code:  
	.dc.l 0x0810000f 
	.dc.l 0x04040000
	.dc.l 0x040c0000 
	.dc.l 0x83000000 
	.dc.l 0x0840000a 
	.dc.l 0x46600008 
	.dc.l 0x05640000 
	.dc.l 0x10900001
	.dc.l 0x481ffff4 
	.dc.l 0x85000001
	.dc.l 0x00900001
/* code 2 
risc_code: 
	.dc.l 0x0810000A 
    .dc.l 0x04040000 
    .dc.l 0x08300000 
    .dc.l 0x084000ff
    .dc.l 0x21d00000 
    .dc.l 0x4ac00008 
    .dc.l 0x09200001
    .dc.l 0x10900001 
    .dc.l 0x09b00004 
    .dc.l 0x481fffec 
    .dc.l 0x85000001 
	.dc.l 0x00900001 
*/
registers: .dc.l 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0 
memory:    .dc.l 0x0,0xff,0x1,0x2,0xff,0xff,0x0,0xf,0xff,0xa,0xff 
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

_main:
main:
/////////////////PRE MAIN LOOP//////////////////////
	bsr INIT_DIP
	bsr INIT_LED
	movea.l #risc_code,a0 //a0 points to the PC
	movea.l #registers,a1 // a1 point to the registers (r0-r7)
	movea.l #memory,a2 // a2 for the emulators memory 
////////////////////////////////////////////////////

//////////////////MAIN LOOP/////////////////////////
FETCH:
	move.l (a0), d0
	move.l #26, d1
	lsr.l d1, d0
	and.l #63, d0
	cmp.l #1, d0
	beq ADD
	cmp.l #2, d0
	beq ADDI
	cmp.l #3, d0
	beq SUB
	cmp.l #4, d0
	beq SUBI
	cmp.l #8, d0
	beq LOAD
	cmp.l #17, d0
	beq BE
	cmp.l #18, d0
	beq BNE
	cmp.l #32, d0
	beq READS
	cmp.l #33, d0
	beq DISP
	cmp.l #0, d0
	beq END
RETURN:
	add.l #4, a0
	bra FETCH
////////////////////////////////////////////////////

//////////////INITIALIZING SUBROUTINES//////////////
INIT_LED:	
	move.l #0x0,d0
	move.b d0,0x4010006F // Set pins to be used GPIO.
	move.l #0xFFFFFFFF,d0
	move.b d0,0x40100027 // Set LED's as output.
	// Initial value 0000 for the LED's:
	move.l #0x0,d1
	move.l d1,0x4010000F
	rts
INIT_DIP:
	move.l #0x0,d5
	move.b d5,0x40100074 // Set pins to be used GPIO.
	move.l #0x0,d5
	move.b d5,0x4010002C // Set as input.
	rts
////////////////////////////////////////////////////
		
///////////////ADDING SUBROUTINES///////////////////
ADD:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	move.l #17, d3
	lsr.l d3, d2
	and.l #7, d2
	muls #4, d2
	move.l (d0, a1), d3
	add.l (d1, a1), d3
	move.l d3, (d2, a1)
	bra RETURN
ADDI:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	and.l #0xfffff, d2
	move.l (d0, a1), d3
	add.l d2, d3
	move.l d3, (d1, a1)
	bra RETURN
////////////////////////////////////////////////////

////////////SUBTRACTING SUBROUTINES/////////////////
SUB:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	move.l #17, d3
	lsr.l d3, d2
	and.l #7, d2
	muls #4, d2
	move.l (d0, a1), d3
	sub.l (d1, a1), d3
	move.l d3, (d2, a1)
	bra RETURN
SUBI:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	and.l #0xfffff, d2
	move.l (d0, a1), d3
	sub.l d2, d3
	move.l d3, (d1, a1)
	bra RETURN
////////////////////////////////////////////////////

///////////////LOADING SUBROUTINE///////////////////
LOAD:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	and.l #0xfffff, d2
	move.l (d0,a1), d4
	add.l d2, d4
	move.l (d4,a2), d3
	move.l d3, (d1,a1)
	bra RETURN
////////////////////////////////////////////////////

///////////////BRANCHING SUBROUTINES////////////////
BE:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	and.l #0xfffff, d2
	cmp.l #0x80000, d2
	blt POS_1
	add.l #0xfff00000, d2
POS_1:
	move.l (d0,a1), d3
	move.l (d1,a1), d4
	cmp.l d3, d4
	beq RETURN_1
	bra RETURN
RETURN_1:
	add.l d2, a0
	bra FETCH
BNE:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (a0), d1
	move.l #20, d2
	lsr.l d2, d1
	and.l #7, d1
	muls #4, d1
	move.l (a0), d2
	and.l #0xfffff, d2
	cmp.l #0x80000, d2
	blt POS_2
	add.l #0xfff00000, d2
POS_2:
	move.l (d0,a1), d3
	move.l (d1,a1), d4
	cmp.l d3, d4
	beq RETURN_2
	add.l d2, a0
	bra FETCH
RETURN_2:
	bra RETURN
////////////////////////////////////////////////////
	
/////////////READING SUBROUTINE/////////////////////
READS:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l #0x0, d1
	move.b 0x40100044, d1
	lsr.l #4, d1
	andi.l #0xf, d1
	move.l d1, (d0, a1)
	bra RETURN
////////////////////////////////////////////////////

///////////DISPLAYING SUBROUTINE////////////////////
DISP:
	move.l (a0), d0
	move.l #23, d1
	lsr.l d1, d0
	and.l #7, d0
	muls #4, d0
	move.l (d0,a1), d1
	and.l #0x0F, d1
	move.b d1, 0x4010000F
	bra RETURN
////////////////////////////////////////////////////

/////////////ENDING SUBROUTINE//////////////////////	
END:
	move.l #0xffff, d0
	move.b d0,0x4010000F
	rts
////////////////////////////////////////////////////

//======= Let the following few lines always end your main routing ===//
//------- No OS to return to so loop ---- //
//------- infinitely...Never hits rts --- //
inflp:	bra.s	inflp
		rts
