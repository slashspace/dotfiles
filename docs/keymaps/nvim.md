# nvim

## Navigation
J          Move down 5 lines (normal mode)
K          Move up 5 lines (normal mode)
H          Move to first non-blank char (normal/visual)
L          Move to last non-blank char (normal/visual)

## Editing
jj         Exit insert mode (→ Esc)
<leader>s  Save file (:w)
<esc>      Clear search highlight

## Flash (fast navigation)
s          Flash jump (2-char label)
S          Flash Treesitter jump
r          Flash remote operator (operator-pending)
R          Flash Treesitter remote
<c-s>      Flash toggle search

## Surround (mini.surround / nvim-surround)
sa         Add surrounding (sa{motion}{char})
sd         Delete surrounding (sd{char})
sr         Replace surrounding (sr{old}{new})

## Which-Key
<leader>   Show leader key bindings popup

## Noice / UI
:messages  Browse message history
:Noice     View notification log
