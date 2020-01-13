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
ADDRESS_BORDER_COLOR          = $d020
ADDRESS_BACKGROUND_COLOR      = $d021
ADDRESS_CLEAR_SCREEN          = $e544
ADDRESS_SCREEN_RAM            = $0400
ADDRESS_COLOR_RAM             = $d800
ADDRESS_SPRITES               = $2400
ADDRESS_SPRITE_MULTICOLOR     = $d01c
ADDRESS_SPRITE_ENABLE         = $d015
ADDRESS_SPRITE_DOUBLE_WIDTH   = $D01D
ADDRESS_SPRITE_DOUBLE_HEIGHT  = $D017
ADDRESS_SPRITE_X_MSB          = $D010
ADDRESS_SPRITE0_POINTER       = ADDRESS_SCREEN_RAM + $3f8
ADDRESS_SPRITE1_POINTER       = ADDRESS_SCREEN_RAM + $3f9
ADDRESS_SPRITE2_POINTER       = ADDRESS_SCREEN_RAM + $3fa
ADDRESS_SPRITE0_COLOR         = $d027
ADDRESS_SPRITE1_COLOR         = $d028
ADDRESS_SPRITE2_COLOR         = $d029
ADDRESS_SPRITE0_XPOS          = $d000
ADDRESS_SPRITE0_YPOS          = $d001
ADDRESS_SPRITE1_XPOS          = $d002
ADDRESS_SPRITE1_YPOS          = $d003
ADDRESS_SPRITE2_XPOS          = $d004
ADDRESS_SPRITE2_YPOS          = $d005
ADDRESS_SID                   = $1000
ADDRESS_SID_PLAY              = $1003
ADDRESS_CHARS                 = $3800
ADDRESS_JOY2_STATE            = $dc00
ADDRESS_CIA1_ICR              = $dc0d
ADDRESS_CIA2_ICR              = $dd0d

ADDRESS_INTERRUPT_CONTROL_REG = $d01a
; Bit #0: 1 = Raster interrupt enabled.
; Bit #1: 1 = Sprite-background collision interrupt enabled.
; Bit #2: 1 = Sprite-sprite collision interrupt enabled.
; Bit #3: 1 = Light pen interrupt enabled.

ADDRESS_SCREEN_CONTROL_REG = $d011
; Bits #0-#2: Vertical raster scroll.
; Bit #3: Screen height; 0 = 24 rows; 1 = 25 rows.
; Bit #4: 0 = Screen off, complete screen is covered by border; 1 = Screen on, normal screen contents are visible.
; Bit #5: 0 = Text mode; 1 = Bitmap mode.
; Bit #6: 1 = Extended background mode on.
; Bit #7: Read: Current raster line (bit #8).
;         Write: Raster line to generate interrupt at (bit #8).
; Default: $1B, %00011011.

ADDRESS_SCREEN_CONTROL_REG2 = $d016
; Bits #0-#2: Horizontal raster scroll.
; Bit #3: Screen width; 0 = 38 columns; 1 = 40 columns.
; Bit #4: 1 = Multicolor mode on.
; Default: $C8, %11001000.

ADDRESS_RASTER_LINE = $d012
; Read: Current raster line (bits #0-#7).
; Write: Raster line to generate interrupt at (bits #0-#7).

ADDRESS_SID                  = $1000
ADDRESS_SID_PLAY             = $1003

; Constants
; --------------------------------
C_ROOF_YPOS = #142      ; Screen Height (25 x 8 = 200), 200 - (8 x 8) = 136
C_PLAYER1_STARTX = #72;  ; Screen Width (40 x 8 = 320, 30 x 8 = 240) 40 + 32

; Include external files
; --------------------------------

; Basic Loader
; 2012 SYS 49152 (C000)
; --------------------------------
* = $0801
        byte $0d,$08,$dc,$07,$9e,$20,$34,$39
        byte $31,$35,$32,$00,$00,$00

* = $1000
IncBin "music/wk_unity.sid",$7e ; Remove header from sid and cut off original loading address

; Sprites
* = $2000
IncBin "sprites.spt", 1, 7, True  ; Load sprite 1 - 2 and pad to 64 bytes
; 1 = Player
; 2 = Player Jump
; 3 = Bullet
; 4 - 7 = Blood animation

* = $c000 ; Start Address for program (49152)

; Entry point is here
; --------------------------------
init
        ; Clear the screen
        jsr ADDRESS_CLEAR_SCREEN
        jsr draw_roof

        ; Set foreground color
        lda #COLOR_WHITE
        jsr set_foreground_color

        ; Background and border colors
        lda #COLOR_BLUE
        sta ADDRESS_BACKGROUND_COLOR
        lda #COLOR_BLACK        
        sta ADDRESS_BORDER_COLOR

        ; Player 1 Sprite
        ; Sprite pointer
        lda #$80 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE0_POINTER
        ; X/Y position
        ldx C_PLAYER1_STARTX ; X position
        ldy #50 ; Y position
        stx ADDRESS_SPRITE0_XPOS
        sty ADDRESS_SPRITE0_YPOS
        lda #%00000111            ; Enable first/second sprite
        sta ADDRESS_SPRITE_ENABLE
        lda #%00000111            ; Double height
        sta ADDRESS_SPRITE_DOUBLE_HEIGHT
        lda #COLOR_PINK
        sta ADDRESS_SPRITE0_COLOR
        lda #%11111001
        sta ADDRESS_SPRITE_MULTICOLOR

        ; Bullet sprite
        ; Sprite pointer
        lda #$82 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE1_POINTER
        lda #COLOR_YELLOW
        sta ADDRESS_SPRITE1_COLOR
        ldx #50 ; X position
        ldy #50 ; Y position
        stx ADDRESS_SPRITE1_XPOS
        sty ADDRESS_SPRITE1_YPOS

        ; Blood sprite
        ; Sprite pointer
        lda #$83 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE2_POINTER
        lda #COLOR_RED
        sta ADDRESS_SPRITE2_COLOR
        ldx #100 ; X position
        ldy #50 ; Y position
        stx ADDRESS_SPRITE2_XPOS
        sty ADDRESS_SPRITE2_YPOS
    
init_music
        lda #0
        tax
        tay
        jsr ADDRESS_SID

init_raster_interrupt
        ; Disable interrupts
        sei ; Disable interupt signal
        lda #$7f ; 0111111
        sta ADDRESS_CIA1_ICR
        sta ADDRESS_CIA2_ICR
        lda #$01
        sta ADDRESS_INTERRUPT_CONTROL_REG
        ; Set text mode
        lda #$1b ; 00011011
        ldx #$08 ; 00001000
        ldy #$14 ; 00010100
        sta ADDRESS_SCREEN_CONTROL_REG
        stx ADDRESS_SCREEN_CONTROL_REG2
        sty $d014
        ; Init irq
        lda #<raster_interrupt
        ldx #>raster_interrupt
        sta $0314 ; Execution address of interrupt service routine.
        stx $0315
        ; Create rater interrupt at...
        ldy #$00 ; Line Zero
        sty ADDRESS_RASTER_LINE
        ; Clear interrupts and ack irq
        lda $dc0d
        lda $dd0d
        asl $d019
        cli
        jmp * ; infinite loop

raster_interrupt
        ; Trigger next interupt
        lda #<raster_interrupt
        ldx #>raster_interrupt
        sta $0314 ; Execution address of interrupt service routine.
        stx $0315
        ; Create raster interrupt at...
        ldy #$00 ; Line Zero
        sty ADDRESS_RASTER_LINE
        asl $d019
        ; Call the mainloop
        jsr mainloop
        jmp $ea81

; --------------------------------
; The main loop. Called once per
; frame.
; --------------------------------
mainloop
        jsr ADDRESS_SID_PLAY
        jsr read_joysticks
        jsr move_player1
        jsr move_bullet1
        jsr update_blood1
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

; --------------------------------
; Draw rooftop
; --------------------------------
draw_roof
        ; At row 18 fill 30 chars
        ; 5 empty spaces on each side
        ldx #0
        lda #79 ; Character
@loop   sta $06ad,x ; Memory offset to fill
        inx ; x++
        cpx #30 ; x == 30 ?
        bne @loop ; if no; loop
        rts

; --------------------------------
; Read joysticks and set variables
; --------------------------------
read_joysticks
        ; Player 1
        lda ADDRESS_JOY2_STATE
        lsr
        ror player1_joy_up
        lsr
        ror player1_joy_down
        lsr
        ror player1_joy_left
        lsr
        ror player1_joy_right
        lsr
        ror player1_joy_fire
        rts

; --------------------------------
; Move player 1
; --------------------------------
move_player1
        jsr check_jump_player1
        jsr apply_gravity_player1
        rts

; --------------------------------
; Init player 1 bullet
; --------------------------------
init_bullet1
        ldx ADDRESS_SPRITE0_XPOS
        ldy ADDRESS_SPRITE0_YPOS
        stx ADDRESS_SPRITE1_XPOS
        sty ADDRESS_SPRITE1_YPOS
        lda ADDRESS_SPRITE_X_MSB
        and #%00000001
        asl
        sta ADDRESS_SPRITE_X_MSB
        rts

; --------------------------------
; Move player 1 bullet
; --------------------------------
move_bullet1
        ; X-direction
        ldx bullet1_x_speed
@movex
        inc ADDRESS_SPRITE1_XPOS
        bne @donex
        lda ADDRESS_SPRITE_X_MSB ; Set X pos bit 8
        eor #%00000010
        sta ADDRESS_SPRITE_X_MSB
@donex
        dex
        txa
        bne @movex
        ; Y-direction
        ldy bullet1_y_speed
@movey
        dec ADDRESS_SPRITE1_YPOS
        bne @doney
@doney
        dey
        tya
        bne @movey
        rts

; --------------------------------
; Init player 1 blood
; --------------------------------
init_blood1
        ldx ADDRESS_SPRITE0_XPOS
        ldy ADDRESS_SPRITE0_YPOS
        stx ADDRESS_SPRITE2_XPOS
        sty ADDRESS_SPRITE2_YPOS
        lda ADDRESS_SPRITE_X_MSB
        and #%00000001
        asl
        asl
        sta ADDRESS_SPRITE_X_MSB
        lda #$83 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE2_POINTER
        sta blood1_anim
        rts

update_blood1
        ldx blood1_anim
        cpx #$86
        beq @done
        inx
        stx blood1_anim
        stx ADDRESS_SPRITE2_POINTER
@done
        rts

; --------------------------------
; Check player 1 jumping
; --------------------------------
check_jump_player1
        ; If jumping do the jump
        lda player1_is_jumping
        cmp #1
        beq @jump
        ; On ground?
        lda player1_on_ground
        cmp #1
        bne @done
        ; Up pressed?
        bit player1_joy_fire
        bmi @done
        bvc @done
        ; Begin jump
        jsr init_bullet1
        jsr init_blood1
        lda #$81 ; Jump animation
        sta ADDRESS_SPRITE0_POINTER
        lda #1
        sta player1_is_jumping
        lda #10
        sta player1_jump_count
        ; Do the jumping
@jump   dec ADDRESS_SPRITE0_YPOS
        dec ADDRESS_SPRITE0_YPOS
        dec ADDRESS_SPRITE0_YPOS
        jsr move_player1_right
        dec player1_jump_count
        bne @done
        ; Stop jumping
        lda #0
        sta player1_is_jumping
        lda #$80 ; Jump animation
        sta ADDRESS_SPRITE0_POINTER
@done   rts

move_player1_right
        ldx player1_x_speed
@move
        inc ADDRESS_SPRITE0_XPOS
        bne @done
        lda ADDRESS_SPRITE_X_MSB ; Set X pos bit 8
        eor #%00000001
        sta ADDRESS_SPRITE_X_MSB
@done
        dex
        txa
        bne @move
        rts

; --------------------------------
; Apply gravity to player 1
; --------------------------------
apply_gravity_player1
        ; If jumping return
        lda player1_is_jumping
        cmp #1
        beq @done 
        ; Can player fall?
        ; Outside roof to the left or right?
        lda ADDRESS_SPRITE_X_MSB
        and #%00000001
        beq @checkleft
        ; Check right
        lda ADDRESS_SPRITE0_XPOS
        cmp #40 ; 5x8
        bcs @fall ; Skip to fall if outside roof (x > 25)
        jmp @checksky
@checkleft
        lda ADDRESS_SPRITE0_XPOS
        cmp #34 ; 5x8
        bcc @fall ; Skip to fall if outside roof (x < 40)
@checksky
        ; In sky?
        lda ADDRESS_SPRITE0_YPOS
        cmp #C_ROOF_YPOS
        bcc @fall ; Skip to fall if in sky (a < roof)
        ; Flag player on ground
        lda #1
        sta player1_on_ground
        jmp @done
@fall
        ; Unset flag player on ground
        lda #0
        sta player1_on_ground
        ; Increment Y
        inc ADDRESS_SPRITE0_YPOS
        inc ADDRESS_SPRITE0_YPOS
        ; Check if dead...
        ; todo
@done   rts

; Vars
; --------------------------------

player1_is_jumping
        byte $00
player1_jump_count
        byte $00
player1_is_firing
        byte $00
bullet1_active
        byte $00
bullet1_x_speed
        byte $03
bullet1_y_speed
        byte $01
blood1_anim
        byte $83
player1_x_speed
        byte $02
player1_on_ground
        byte $00
player1_joy_fire
        byte $00
player1_joy_up
        byte $00
player1_joy_down
        byte $00
player1_joy_left
        byte $00
player1_joy_right
        byte $00


