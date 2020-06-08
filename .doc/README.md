# Personal .dotfiles

collections of my config dotfiles for emacs, vim, zsh and more.

## Acknowledgment

- primarily inspired by [BurntSushi's dotfile](https://github.com/BurntSushi/dotfiles)
- editors using [Doom Emacs](https://github.com/hlissner/doom-emacs) and [ultimate vimrc](https://github.com/amix/vimrc)
- zsh config framework using [prezeto](https://github.com/sorin-ionescu/prezto)

## FAQ

- Why my own zsh functions doesn't should up. (e.g. a completion function for `rustup`)?

First, make sure the function file is under your `fpath`.
Next, try delete `rm -f ~/.zcompdump`, then restart the zsh.

## License

No(Un)[license](./LICENSE). Free to use however you want.
