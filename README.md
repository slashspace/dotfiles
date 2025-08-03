# dotfiles
My macOS configuration files.

![截图](https://d3george.github.io/github-static/dotfiles/dotfiles-screen.png)

```
.
├── aerospace           
├── ghostty               
├── karabiner        
├── sketchybar      
├── starship     
├── zsh
│   └── .zshrc
```


### GNU Stow
- Refer the docs : [Read More](https://www.gnu.org/software/stow/)
```
brew install stow
```

## Installation of this repo using stow

First, check out dotfiles repo in your $HOME directory using git

```
$ git clone https://github.com/slashspace/dotfiles
$ cd dotfiles
```
#### Before Running any stow commands
- At least for this config structure
- **!! make sure home directories is set to have the same structure first !!**
- for instances ( Watch for Sub-directories ) 
    - if any subdirectory eg: `~/.config` dont exist in $HOME then `mkdir .config`
    - other config files that don't exist in $HOME atm, should not have any problems
      for stow symlinks


then use GNU stow to create symlinks
> [!IMPORTANT]
> make sure you are in your dotfiles directory

- `cd dotfiles`
- as long as you have the structure setup in $HOME correctly
- running `stow .` should be enough

##### However, for assurance
- run stow commands like below for each directory in dotfiles 
- re-check if the symlinks are correct for each sub-directories and files
```bash
stow -t ~ starship wezterm tmux

#or run them separately

stow -t ~ nvim
stow -t ~ zsh
```