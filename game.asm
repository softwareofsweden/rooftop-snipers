; --------------------------------
; C64 Rooftop Snipers
; Code by: Martin
; (C) 2019- Software of Sweden
; --------------------------------

; Colors
; --------------------------------
COLOR_BLACK         = $00
COLOR_WHITE         = $01
COLOR_RED           = $02
COLOR_CYAN          = $03
COLOR_PURPLE        = $04
COLOR_GREEN         = $05
COLOR_BLUE          = $06
COLOR_YELLOW        = $07
COLOR_ORANGE        = $08
COLOR_BROWN         = $09
COLOR_PINK          = $0a
COLOR_DARK_GREY     = $0b
COLOR_GREY          = $0c
COLOR_LIGHT_GREEN   = $0d
COLOR_LIGHT_BLUE    = $0e
COLOR_LIGHT_GREY    = $0f

; Memory Addresses
; --------------------------------
ADDRESS_BORDER_COLOR         = $d020
ADDRESS_BACKGROUND_COLOR     = $d021
ADDRESS_CLEAR_SCREEN         = $e544
ADDRESS_SCREEN_RAM           = $0400
ADDRESS_COLOR_RAM            = $d800
ADDRESS_SPRITES              = $2000
ADDRESS_SPRITE_MULTICOLOR    = $d01c
ADDRESS_SPRITE_ENABLE        = $d015
ADDRESS_SPRITE_DOUBLE_WIDTH  = $D01D
ADDRESS_SPRITE_DOUBLE_HEIGHT = $D017
ADDRESS_SPRITE0_POINTER      = ADDRESS_SCREEN_RAM + $3f8
ADDRESS_SPRITE0_COLOR        = $d027
ADDRESS_SPRITE0_XPOS         = $d000
ADDRESS_SPRITE0_YPOS         = $d001
ADDRESS_SID                  = $1000
ADDRESS_SID_PLAY             = $1003
ADDRESS_CHARS                = $3800
ADDRESS_JOY2_STATE           = $dc00

; Constants
; --------------------------------
C_ROOF_YPOS = #136      ; Screen Height (25 x 8 = 200), 200 - (8 x 8) = 136
C_PLAYER1_STARTX = #72;  ; Screen Width (40 x 8 = 320, 30 x 8 = 240) 40 + 32

; Include external files
; --------------------------------

; Basic Loader
; 2012 SYS 49152 (C000)
; --------------------------------
* = $0801
        byte $0d,$08,$dc,$07,$9e,$20,$34,$39
        byte $31,$35,$32,$00,$00,$00

; Sprites
* = $2000
IncBin "sprites.spt", 1, 1, True  ; Load sprite 1 - 1 and pad to 64 bytes

* = $c000 ; Start Address for program (49152)

; Entry point is here
; --------------------------------
init
    ; Clear the screen
    ; jsr ADDRESS_CLEAR_SCREEN

    ; Set foreground color
    lda #COLOR_WHITE
    jsr set_foreground_color

    ; Background and border colors
    lda #COLOR_BLACK
    sta ADDRESS_BACKGROUND_COLOR
    lda #COLOR_BLUE
    sta ADDRESS_BORDER_COLOR

    ; Player 1 Sprite
    ; Sprite pointer
    lda #$80 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
    sta ADDRESS_SPRITE0_POINTER
    ; X/Y position
    ldx C_PLAYER1_STARTX ; X position
    ldy C_ROOF_YPOS ; Y position
    stx ADDRESS_SPRITE0_XPOS
    sty ADDRESS_SPRITE0_YPOS
    lda #%00000001            ; Enable first sprite
    sta ADDRESS_SPRITE_ENABLE
    lda #%00000001            ; Double height
    sta ADDRESS_SPRITE_DOUBLE_HEIGHT
    
init_raster_interrupt
    ; Disable interrupts
    sei                     ; Disable interupt signal
    lda #$7f
    sta $dc0d
    sta $dd0d
    lda #$01
    sta $d01a
    ; Set text mode
    lda #$1b
    ldx #$08
    ldy #$14
    sta $d011
    stx $d016
    sty $d014
    ; Init irq
    lda #<raster_interrupt
    ldx #>raster_interrupt
    sta $0314
    stx $0315
    ; Create rater interrupt at...
    ldy #$00        ; Line Zero
    sty $d012
    ; Clear interrupts and ack irq
    lda $dc0d
    lda $dd0d
    asl $d019
    cli
    jmp *       ; infinite loop

raster_interrupt
    ; Trigger next interupt
    lda #<raster_interrupt
    ldx #>raster_interrupt
    sta $0314
    stx $0315
    ; Create raster interrupt at...
    ldy #$00  ; Line Zero
    
    sty $d012
    asl $d019
    ; Call the mainloop
    jsr mainloop
    jmp $ea81

; --------------------------------
; The main loop. Called once per
; frame.
; --------------------------------
mainloop
    ; inc ADDRESS_BACKGROUND_COLOR

        jsr move_player1

    rts

; --------------------------------
; Function that sets the
; foreground color. Set A register
; to specify color.
; --------------------------------
set_foreground_color
    ldx #$00
clear
    sta $d800,x  
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne clear
    rts
    
move_player1
        ; Falling
        inc ADDRESS_SPRITE0_YPOS
        inc ADDRESS_SPRITE0_YPOS
        rts


