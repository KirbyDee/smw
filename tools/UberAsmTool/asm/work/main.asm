incsrc "asm/work/library.asm"
incsrc "../../other/macro_library.asm"
!level_nmi	= 0
!overworld_nmi	= 0
!gamemode_nmi	= 0
!global_nmi	= 0

!sprite_RAM	= $7FAC80

autoclean $909271
autoclean $90C7E5
autoclean $90CD06
autoclean $90CD18
autoclean $90CD05
autoclean $90CD13
autoclean $91DB34
autoclean $91D997
autoclean $90CCE9
autoclean $90CCE0
autoclean $90C7AF
autoclean $90CCB9
autoclean $90C5F6

!previous_mode = !sprite_RAM+(!sprite_slots*3)

incsrc level.asm
incsrc overworld.asm
incsrc gamemode.asm
incsrc global.asm
incsrc sprites.asm
incsrc statusbar.asm


print freespaceuse
