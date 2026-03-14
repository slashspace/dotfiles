#!/bin/bash

# Source the active colorscheme (DOTFILES_DIR defaults to ~/dotfiles if unset)
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
source "$DOTFILES_DIR/support/colorscheme/active/active-colorscheme.sh"

export MIC_LEVEL=40

# Linkarzu Theme
export BLACK=0xff${linkarzu_color10#\#}
export WHITE=0xff${linkarzu_color14#\#}
export RED=0xff${linkarzu_color11#\#}
export GREEN=0xff${linkarzu_color02#\#}
export BLUE=0xff${linkarzu_color03#\#}
export YELLOW=0xff${linkarzu_color12#\#}
export ORANGE=0xff${linkarzu_color04#\#}
export MAGENTA=0xff${linkarzu_color01#\#}
export GREY=0xff${linkarzu_color09#\#}
export TRANSPARENT=0x00000000
export BG0=0xff${linkarzu_color10#\#}
export BG0O50=0x80${linkarzu_color10#\#}
export BG0O60=0x99${linkarzu_color10#\#}
export BG0O70=0xb2${linkarzu_color10#\#}
export BG0O80=0xcc${linkarzu_color10#\#}
# This sets the color of the bar
# Eldritch dark
export BG0O85=0x55${linkarzu_color10#\#}
# Eldritch light
export BG1=0x60${linkarzu_color13#\#}
export BG2=0x60${linkarzu_color07#\#}

# General bar colors
export BAR_COLOR=$BG0O85
export BAR_BORDER_COLOR=$BG2
export BACKGROUND_1=$BG1
export BACKGROUND_2=$BG2
export ICON_COLOR=$WHITE  # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export POPUP_BACKGROUND_COLOR=$BAR_COLOR
export POPUP_BORDER_COLOR=$WHITE
export SHADOW_COLOR=$BLACK
