	SECTION IntroCode,CODE_C

	INCLUDE "include/custom.inc"
	INCLUDE "include/startup.asm"

Main:
	movem.l	d0-a6,-(sp)


	lea	$dff000,a5
	lea	CopperList,a0
	move.l	a0,COP1LC(a5)

	move.w	#$82a0,DMACON(a5)
	move.w	#$8010,INTENA(a5)
	move.l	S_VBR,a0
	move.l	#IRQHandler,IRQ3(a0)

	bsr	InitSprites

.MainLoop:
	btst	#6,CIAAPRA
	bne	.MainLoop


	movem.l	(sp)+,d0-a6

	rts

IRQHandler:
	movem.l	d0-a6,-(sp)
	lea	$dff000,a6
	btst	#5,$1f(a6)
	beq	.noIRQ

	moveq	#20,d0
	move.w	d0,$9c(a6)
	move.w	d0,$9c(a6)
.noIRQ:
	movem.l	(sp)+,d0-a6
	rte
InitSprites:
	lea	SpriteList,a0
	lea	SpritePtrs,a1
	moveq	#8-1,d7
.Loop:
	move.l	(a0)+,d0
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	adda.l	#8,a1

	dbra	d7,.Loop

	lea	$dff000,a5
	move.w	#$6464,SPR0POS(a5)	; Vertical=100, Horizontal=100
	move.w	#$0084,SPR0CTL(a5)	; VSTART=0, VSTOP=132 (100+32)


	rts

SpriteList:
	dc.l	SPRITE0		; 0
	dc.l	DUMMYSPRITE	; 1
	dc.l	DUMMYSPRITE	; 2
	dc.l	DUMMYSPRITE	; 3
	dc.l	DUMMYSPRITE	; 4
	dc.l	DUMMYSPRITE	; 5
	dc.l	DUMMYSPRITE	; 6
	dc.l	DUMMYSPRITE	; 7



;--------------------------------------------------------------------------
	SECTION Graphics,DATA_C
CopperList::
	dc.w    $008e,$2c81         ; DIWSTRT
	dc.w    $0090,$2cc1         ; DIWSTOP (vertical wraps: $12c)
	dc.w    $0092,$0038         ; DDFSTRT
	dc.w    $0094,$00d0         ; DDFSTOP
	dc.w    $0100,$0200         ; BPLCON0: 0 bitplanes, colour on
	dc.w    $0102,$0000         ; BPLCON1
	dc.w    $0104,$0000         ; BPLCON2: sprites in front
	dc.w    $0106,$0c00         ; BPLCON3 (AGA: palette bank 0, sane defaults)
	dc.w    $01fc,$0000         ; FMODE   (AGA: 16-pixel wide sprites)

	dc.w	$0180,$0000
	dc.w	$0182,$0fff

	dc.w    $01a2,$0fff,$01a4,$0fff,$01a6,$0fff
	dc.w    $01aa,$0000,$01ac,$0000,$01ae,$0000
	dc.w    $01b2,$0000,$01b4,$0000,$01b6,$0000
	dc.w    $01ba,$0000,$01bc,$0000,$01be,$0000

SpritePtrs:		
	dc.w	$0120,$0000,$0122,$0000	; Sprite 1
	dc.w	$0124,$0000,$0126,$0000	; Sprite 2
	dc.w	$0128,$0000,$012a,$0000	; Sprite 3
	dc.w	$012c,$0000,$012e,$0000	; Sprite 4
	dc.w	$0130,$0000,$0132,$0000	; Sprite 5
	dc.w	$0134,$0000,$0136,$0000	; Sprite 6
	dc.w	$0138,$0000,$013a,$0000	; Sprite 7
	dc.w	$013c,$0000,$013e,$0000	; Sprite 8


	dc.w	$c007,$fffe,$0180,$0fff
	dc.w	$c107,$fffe,$0180,$0000

	dc.w	$ffff,$fffe
;--------------------------------------------------------------------------
	include "sprites.inc"
DUMMYSPRITE:
	dc.w	$0000,$0000
	dc.w	$0000,$0000
;--------------------------------------------------------------------------


