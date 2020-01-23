; --------------------------------
; C64 Rooftop Snipers
; Code by: Sandis
; Music by: Wolk
; (C) 2019- Software of Sweden
; --------------------------------

; --------------------------------
; Memory
; --------------------------------
; $1000-$2978 Music
; $5000-$6000 Charset
; $6000       Sprites
; $c000       Code

; --------------------------------
; *** CONSTANTS ***
; --------------------------------

; Colors
; --------------------------------
COLOR_BLACK         = #$00
COLOR_WHITE         = #$01
COLOR_RED           = #$02
COLOR_CYAN          = #$03
COLOR_PURPLE        = #$04
COLOR_GREEN         = #$05
COLOR_BLUE          = #$06
COLOR_YELLOW        = #$07
COLOR_ORANGE        = #$08
COLOR_BROWN         = #$09
COLOR_PINK          = #$0a
COLOR_DARK_GREY     = #$0b
COLOR_GREY          = #$0c
COLOR_LIGHT_GREEN   = #$0d
COLOR_LIGHT_BLUE    = #$0e
COLOR_LIGHT_GREY    = #$0f

; VIC Banks
; --------------------------------
VIC_BANK_0 = #%00000011 ; $0000-$3fff
VIC_BANK_1 = #%00000010 ; $4000-$7fff
VIC_BANK_2 = #%00000001 ; $8000-$bfff
VIC_BANK_3 = #%00000000 ; $c000-$ffff

; Keyboard matrix codes
; --------------------------------
KBD_MATRIX_CODE_1 = #$38
KBD_MATRIX_CODE_2 = #$3b
KBD_MATRIX_CODE_3 = #$08
KBD_MATRIX_CODE_4 = #$0b

; SID tunes
; --------------------------------
SONG_WK_RTOP_TITLE2 = #0;
SONG_WK_RTOP_TITLE3 = #1;
SONG_WK_INGAME = #2;
SONG_WK_UNITY = #3;

; Memory Addresses
; --------------------------------

ZP_LOW = $fb
ZP_HIGH = $fc

ADDRESS_BORDER_COLOR          = $d020
ADDRESS_BACKGROUND_COLOR      = $d021
ADDRESS_CLEAR_SCREEN          = $e544
;ADDRESS_SCREEN_RAM            = $0400 ; Bank 0
ADDRESS_SCREEN_RAM            = $4400 ; Bank 1
ADDRESS_COLOR_RAM             = $d800
ADDRESS_SPRITES               = $6000
ADDRESS_SPRITE_MULTICOLOR     = $d01c
ADDRESS_SPRITE_ENABLE         = $d015
ADDRESS_SPRITE_DOUBLE_WIDTH   = $d01d
ADDRESS_SPRITE_DOUBLE_HEIGHT  = $d017
ADDRESS_SPRITE_X_MSB          = $d010
ADDRESS_SPRITE0_POINTER       = ADDRESS_SCREEN_RAM + $3f8
ADDRESS_SPRITE1_POINTER       = ADDRESS_SCREEN_RAM + $3f9
ADDRESS_SPRITE2_POINTER       = ADDRESS_SCREEN_RAM + $3fa
ADDRESS_SPRITE3_POINTER       = ADDRESS_SCREEN_RAM + $3fb
ADDRESS_SPRITE4_POINTER       = ADDRESS_SCREEN_RAM + $3fc
ADDRESS_SPRITE5_POINTER       = ADDRESS_SCREEN_RAM + $3fd
ADDRESS_SPRITE6_POINTER       = ADDRESS_SCREEN_RAM + $3fe
ADDRESS_SPRITE7_POINTER       = ADDRESS_SCREEN_RAM + $3ff
ADDRESS_SPRITE_MULTICOLOR1    = $d025;
ADDRESS_SPRITE_MULTICOLOR2    = $d026;
ADDRESS_SPRITE0_COLOR         = $d027
ADDRESS_SPRITE1_COLOR         = $d028
ADDRESS_SPRITE2_COLOR         = $d029
ADDRESS_SPRITE3_COLOR         = $d02a
ADDRESS_SPRITE4_COLOR         = $d02b
ADDRESS_SPRITE5_COLOR         = $d02c
ADDRESS_SPRITE6_COLOR         = $d02d
ADDRESS_SPRITE7_COLOR         = $d02e
ADDRESS_SPRITE0_XPOS          = $d000
ADDRESS_SPRITE0_YPOS          = $d001
ADDRESS_SPRITE1_XPOS          = $d002
ADDRESS_SPRITE1_YPOS          = $d003
ADDRESS_SPRITE2_XPOS          = $d004
ADDRESS_SPRITE2_YPOS          = $d005
ADDRESS_SPRITE3_XPOS          = $d006
ADDRESS_SPRITE3_YPOS          = $d007
ADDRESS_SPRITE4_XPOS          = $d008
ADDRESS_SPRITE4_YPOS          = $d009
ADDRESS_SPRITE5_XPOS          = $d00a
ADDRESS_SPRITE5_YPOS          = $d00b
ADDRESS_SPRITE6_XPOS          = $d00c
ADDRESS_SPRITE6_YPOS          = $d00d
ADDRESS_SPRITE7_XPOS          = $d00e
ADDRESS_SPRITE7_YPOS          = $d00f
ADDRESS_SID                   = $1000
ADDRESS_SID_PLAY              = $1003
ADDRESS_CHARS                 = $3800
ADDRESS_JOY2_STATE            = $dc00
ADDRESS_CIA1_ICR              = $dc0d
ADDRESS_CIA2_ICR              = $dd0d
ADDRESS_VIC_BANK              = $dd00
; SCNKEY. Query keyboard; put current matrix code into memory 
; address $00CB, current status of shift keys into memory 
; address $028D and PETSCII code into keyboard buffer.
ADDRESS_KERNAL_SCNKEY         = $ff9f
ADDRESS_KEYPRESSED_MATRIXCODE = $00cb;

ADDRESS_INTERRUPT_CONTROL_REG = $d01a
; Bit #0: 1 = Raster interrupt enabled.
; Bit #1: 1 = Sprite-background collision interrupt enabled.
; Bit #2: 1 = Sprite-sprite collision interrupt enabled.
; Bit #3: 1 = Light pen interrupt enabled.

ADDRESS_SCREEN_CONTROL_REG    = $d011
; Bits #0-#2: Vertical raster scroll.
; Bit #3: Screen height; 0 = 24 rows; 1 = 25 rows.
; Bit #4: 0 = Screen off, complete screen is covered by border; 1 = Screen on, normal screen contents are visible.
; Bit #5: 0 = Text mode; 1 = Bitmap mode.
; Bit #6: 1 = Extended background mode on.
; Bit #7: Read: Current raster line (bit #8).
;         Write: Raster line to generate interrupt at (bit #8).
; Default: $1B, %00011011.

ADDRESS_SCREEN_CONTROL_REG2   = $d016
; Bits #0-#2: Horizontal raster scroll.
; Bit #3: Screen width; 0 = 38 columns; 1 = 40 columns.
; Bit #4: 1 = Multicolor mode on.
; Default: $C8, %11001000.

ADDRESS_RASTER_LINE           = $d012
; Read: Current raster line (bits #0-#7).
; Write: Raster line to generate interrupt at (bits #0-#7).

ADDRESS_SID                   = $1000
ADDRESS_SID_PLAY              = $1003

; Game specific
; --------------------------------
GAMEMODE_INTRO = #0
GAMEMODE_MENU = #1
GAMEMODE_INGAME = #2
GAMEMODE_GAMEOVER = #3

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

* = $1000 ; $1000-$2978
IncBin "music/Rooftop.sid",$7e ; Remove header from sid and cut off original loading address

* = $5000 ; $5000-$6000
IncBin "charset.bin"

; Sprites
* = $6000
IncBin "sprites.spt", 1, 7, True  ; Load sprite 1 - 7 and pad to 64 bytes
; 1 = Player
; 2 = Player Jump
; 3 = Bullet
; 4 - 7 = Blood animation

* = $c000 ; Start Address for program (49152)



; Entry point is here
; --------------------------------
init
        ; Set VIC Bank
        lda ADDRESS_VIC_BANK
        and #%11111100
        ora VIC_BANK_1
        sta ADDRESS_VIC_BANK

        ; Charset location
        ;lda $d018  ; set chars location to $3800 for displaying the custom font
        ;ora #$0e   ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
        ;sta $d018  ; $400 + $200 * $0E = $3800

        ; Clear the screen
        jsr clear_screen
        ;jsr fill_chars

        ; Set foreground color
        lda COLOR_WHITE
        jsr set_foreground_color

        ; Sprite Multicolor
        lda COLOR_BLUE
        sta ADDRESS_SPRITE_MULTICOLOR1        
        lda COLOR_WHITE
        sta ADDRESS_SPRITE_MULTICOLOR2

        ; Player 1 Sprite
        ; Sprite pointer
        lda #$80 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE0_POINTER

        ; Bullet sprite
        ; Sprite pointer
        lda #$82 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE1_POINTER
        lda #COLOR_BLACK
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

        ; Turn off all sprites
        lda #%00000000            
        sta ADDRESS_SPRITE_ENABLE
        ; Double width
        lda #%00000100
        sta ADDRESS_SPRITE_DOUBLE_WIDTH
        ; Double height
        lda #%00000101            
        sta ADDRESS_SPRITE_DOUBLE_HEIGHT
        ; Multicolor
        lda #%11111001
        sta ADDRESS_SPRITE_MULTICOLOR

        lda GAMEMODE_MENU
        sta game_mode
        jsr init_gamemode
    
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
        ldy #$ff ; Line Zero
        sty ADDRESS_RASTER_LINE
        asl $d019
        ; Call the mainloop
        jsr mainloop
        jmp $ea81

init_gamemode
        ; Load current game mode
        ldy game_mode
        ; Store location of game mode init subroutine in zeropage
        lda init_game_mode_jumptable_low,y
        sta ZP_LOW
        lda init_game_mode_jumptable_high,y
        sta ZP_HIGH
        ; Jump to game mode init subroutine
        jmp (ZP_LOW)

; --------------------------------
; The main loop. Called once per
; frame.
; --------------------------------
mainloop
        ; Load current game mode
        ldy game_mode
        ; Store location of game mode subroutine in zeropage
        lda game_mode_jumptable_low,y
        sta ZP_LOW
        lda game_mode_jumptable_high,y
        sta ZP_HIGH
        ; Jump to game mode subroutine
        jmp (ZP_LOW)

init_gamemode_intro
        rts

update_gamemode_intro
        jsr ADDRESS_SID_PLAY
        jsr read_joysticks
        jsr change_music
        rts

init_gamemode_menu
        ; Music
        lda SONG_WK_UNITY ; Sid Subtune
        jsr init_music

        jsr clear_screen

        ; Background and border colors
        lda COLOR_BLACK
        sta ADDRESS_BACKGROUND_COLOR
        lda COLOR_BLACK        
        sta ADDRESS_BORDER_COLOR

        ; Disable sprites
        lda #%00000000
        sta ADDRESS_SPRITE_ENABLE
        rts

update_gamemode_menu
        jsr ADDRESS_SID_PLAY
        jsr read_joysticks

        bit player1_joy_fire
        bmi @done ; Button is not released
        bvc @done ; Up already triggered
        ; Start game
        lda GAMEMODE_INGAME
        sta game_mode
        jsr init_gamemode

        ;jsr change_music
@done
        rts

init_gamemode_ingame
        ; Music
        lda SONG_WK_INGAME ; Sid Subtune
        jsr init_music

        jsr clear_screen
        jsr draw_roof

        ; Background and border colors
        lda COLOR_CYAN
        sta ADDRESS_BACKGROUND_COLOR
        lda COLOR_CYAN
        sta ADDRESS_BORDER_COLOR

        ; Player1 X/Y position
        ldx C_PLAYER1_STARTX ; X position
        ldy #50 ; Y position
        stx ADDRESS_SPRITE0_XPOS
        sty ADDRESS_SPRITE0_YPOS
        lda #COLOR_ORANGE
        sta ADDRESS_SPRITE0_COLOR

        ; Enable sprites
        lda #%00000111
        sta ADDRESS_SPRITE_ENABLE

        rts

update_gamemode_ingame
        jsr ADDRESS_SID_PLAY
        jsr read_joysticks
        jsr update_blood1
        jsr move_player1
        jsr move_bullet1
        rts

init_gamemode_gameover
        rts

update_gamemode_gameover
        rts

; --------------------------------
; Use keys 1-4 to change song
; (For debugging)
; --------------------------------
change_music
        jsr ADDRESS_KERNAL_SCNKEY
        lda ADDRESS_KEYPRESSED_MATRIXCODE
        cmp KBD_MATRIX_CODE_1
        bne @skip1
        ; Pressed key 1
        inc ADDRESS_SCREEN_RAM
        pha
        lda SONG_WK_UNITY
        jsr init_music
        pla
@skip1
        cmp KBD_MATRIX_CODE_2
        bne @skip2
        ; Pressed key 2
        inc ADDRESS_SCREEN_RAM + 1
        pha
        lda SONG_WK_RTOP_TITLE2
        jsr init_music
        pla
@skip2
        cmp KBD_MATRIX_CODE_3
        bne @skip3
        ; Pressed key 3
        inc ADDRESS_SCREEN_RAM + 2
        pha
        lda SONG_WK_RTOP_TITLE3
        jsr init_music
        pla
@skip3
        cmp KBD_MATRIX_CODE_4
        bne @skip4
        ; Pressed key 4
        inc ADDRESS_SCREEN_RAM + 3
        pha
        lda SONG_WK_INGAME
        jsr init_music
        pla
@skip4
        rts

; --------------------------------
; Play music
; A = Subtune
; --------------------------------
init_music
        ldx #0
        ldy #0
        jsr ADDRESS_SID
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
; Clear screen
; --------------------------------
clear_screen
        ldx #0
        lda #$20
@loop   sta ADDRESS_SCREEN_RAM,x
        sta ADDRESS_SCREEN_RAM + $100,x   
        sta ADDRESS_SCREEN_RAM + $200,x   
        sta ADDRESS_SCREEN_RAM + $2e8,x
        dex          ; Decrement value in x reg
        bne @loop    ; If not zero, branch to loop
        rts



; --------------------------------
; Fill chars
; --------------------------------
fill_chars_row = 3
fill_chars_offset = (fill_chars_row * 40)-1
fill_chars
        ; Screen: 40x25 chars
        ldx #40
        lda #160 ; Character
        ; 
@loop   sta ADDRESS_SCREEN_RAM+fill_chars_offset,x ; Memory offset to fill
        dex ; x++
        bne @loop
        rts

; --------------------------------
; Draw rooftop
; --------------------------------
draw_roof
        ; At row 18 fill 30 chars
        ; 5 empty spaces on each side
        ldx #0
        lda #160 ; Character
@loop   sta ADDRESS_SCREEN_RAM + 685,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 725,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 765,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 805,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 845,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 885,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 925,x ; Memory offset to fill
        sta ADDRESS_SCREEN_RAM + 965,x ; Memory offset to fill
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
        jsr check_move_player1_left
        jsr check_move_player1_right
        jsr check_jump_player1
        jsr apply_gravity_player1
        rts

check_move_player1_left
        bit player1_joy_left
        bmi @done
        jsr move_player1_left
@done
        rts

check_move_player1_right
        bit player1_joy_right
        bmi @done
        jsr move_player1_right
@done
        rts

; --------------------------------
; Init player 1 bullet
; --------------------------------
init_bullet1
        ldx ADDRESS_SPRITE0_XPOS
        ldy ADDRESS_SPRITE0_YPOS
        stx ADDRESS_SPRITE1_XPOS
        sty ADDRESS_SPRITE1_YPOS
        ; Copy Sprite 0 X-MSB to Sprite 1
        lda ADDRESS_SPRITE_X_MSB
        and #%11111101
        sta ADDRESS_SPRITE_X_MSB
        and #%00000001
        asl
        ora ADDRESS_SPRITE_X_MSB
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
        and #%11111011
        sta ADDRESS_SPRITE_X_MSB
        and #%00000001
        asl
        asl
        ora ADDRESS_SPRITE_X_MSB
        sta ADDRESS_SPRITE_X_MSB

        lda #$83 ; ADDRESS_SPRITES / 64 ($2000 / $40 = $80)
        sta ADDRESS_SPRITE2_POINTER
        sta blood1_anim
        lda #5
        sta blood1_anim_delay
        rts

update_blood1
        dec blood1_anim_delay
        bne @done
        lda #5
        inc ADDRESS_SPRITE2_YPOS
        inc ADDRESS_SPRITE2_YPOS
        sta blood1_anim_delay
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
        bmi @done ; Button is not released
        bvc @done ; Up already triggered
        ; Begin jump
        jsr init_bullet1
        jsr init_blood1
        lda #$81 ; Jump animation
        sta ADDRESS_SPRITE0_POINTER
        lda #1
        sta player1_is_jumping
        lda #12
        sta player1_jump_count
        ; Do the jumping
@jump   jsr player1_jump
@done   rts

; --------------------------------
; Do the jumping
; --------------------------------
player1_jump
        lda player1_jump_count
        lsr ; divide by 4
        lsr
        tax
        ; Repeat x times
@loop
        dec ADDRESS_SPRITE0_YPOS
        dex
        bne @loop
        ; Dec jump count
        dec player1_jump_count
        cmp #0
        bne @done
        ; Stop jumping
        lda #0
        sta player1_is_jumping
        lda #$80 ; Jump animation
        sta ADDRESS_SPRITE0_POINTER
@done
        rts

; --------------------------------
; Move player 1 left if possible
; --------------------------------
move_player1_left
        ldx player1_x_speed ; Number of iterations to move
        lda ADDRESS_SPRITE_X_MSB ; Check if we are on the left side of screen
        and #%00000001
        bne @move ; If not, no need to check minimum X
        lda ADDRESS_SPRITE0_XPOS
        cmp #24 ; Minimum X pos to the left
        bcc @skip
@move
        dec ADDRESS_SPRITE0_XPOS
        bne @done
        lda ADDRESS_SPRITE_X_MSB ; Unset X pos bit 8
        and #%11111110
        sta ADDRESS_SPRITE_X_MSB
        lda #$ff
        sta ADDRESS_SPRITE0_XPOS
@done
        dex
        txa
        bne @move
@skip
        rts

move_player1_right
        ldx player1_x_speed ; Number of iterations to move
        lda ADDRESS_SPRITE_X_MSB ; Check if we are on the right side of screen
        and #%00000001
        beq @move ; If not, no need to check maximum X
        lda ADDRESS_SPRITE0_XPOS
        cmp #64 ; Maximum X pos to the right
        bcs @skip
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
@skip
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
        cmp #52 ; 5x8
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
        lda ADDRESS_SPRITE0_YPOS
        cmp #200
        bcc @done ; Not dead if x < 255
        lda GAMEMODE_MENU
        sta game_mode
        jsr init_gamemode
@done   rts

; Vars
; --------------------------------
game_mode
        byte $00
game_mode_jumptable_low
        byte <update_gamemode_intro
        byte <update_gamemode_menu
        byte <update_gamemode_ingame
        byte <update_gamemode_gameover
game_mode_jumptable_high
        byte >update_gamemode_intro
        byte >update_gamemode_menu
        byte >update_gamemode_ingame
        byte >update_gamemode_gameover
init_game_mode_jumptable_low
        byte <init_gamemode_intro
        byte <init_gamemode_menu
        byte <init_gamemode_ingame
        byte <init_gamemode_gameover
init_game_mode_jumptable_high
        byte >init_gamemode_intro
        byte >init_gamemode_menu
        byte >init_gamemode_ingame
        byte >init_gamemode_gameover
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
blood1_anim_delay
        byte $00
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


