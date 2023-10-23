# taxi.vim

Vim/Neovim plugin for the [taxi timesheeting tool](https://github.com/sephii/taxi/)
that makes your life easier

![taxi.vim Screenshot](taxi-vim.png)


## Features

* Syntax highlighting
* Alias completion when adding a new line
* Output of the balance every time the timesheet gets saved
* Aligning the timesheet entries
* Automatic async update of the aliases


## Installation

Make sure you have vim in incompatible mode. Add the following lines to your `~/.config/nvim/config` or  `~/.vimrc` file:

```
set nocompatible
filetype plugin on
```

Simply add this repository to your plugin manager, e.g. [dein](https://github.com/Shougo/dein.vim):

```
call dein#add('schtibe/taxi.vim')
```

If you don't have one, put the content of the folders in your vim 
configuration folder: 

### Neovim
* ~/.config/nvim/syntax
* ~/.config/nvim/ftplugin
* ~/.config/nvim/ftdetect

### Vim
* ~/.vim/syntax
* ~/.vim/ftplugin
* ~/.vim/ftdetect


## Usage of the alias completion

To complete the aliases use vim's [omnicomplete functionality](http://vim.wikia.com/wiki/Omni_completion):

Start typing a word, then hit `CTRL-x` and `CTRL-o` consecutively to complete 
it. The completion is automatically spawned when adding a new line.


## Special Thanks


I did not write the syntax file, so thanks to whoever wrote it and contributed 
to it. To me it made sense to include this here to have a single point of
vim taxi functionality.


## Stuff

### I have a date format that is not parsed by the syntax file

Edit the syntax/taxi.vim file, then add a new line containing a regular 
expression for the date format, like

```syn match date "^\d\+/\d\+/\d\d"```

and make a pull request if you think it is a commonly used date format that
should be covered by the syntax file.
