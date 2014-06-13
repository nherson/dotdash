Dotdash
=======

A second stab at a dotfile manager, this time in Ruby... hopefully I find time in this one :)

This is a work in its infancy.


### Intended Usage (to be hopefully implemented some day) ###

The following is mostly bookkeeping for what commands should be supported.

```
dotdash init

dotdash file import [HOST] FILE
dotdash file new [HOST] FILE
dotdash file clone HOST1 [HOST2] FILE
dotdash file delete [HOST] FILE
dotdash file edit [HOST] FILE

dotdash host create HOST
dotdash host clone HOST1 HOST2
dotdash host delete HOST
dotdash host rename HOST1 HOST2
dotdash host list

dotdash deploy [HOST]

dotdash push
dotdash pull


### Wishlist ###

dotdash link HOST1 [HOST2] FILE
```


### The Idea ###

The goal is to have a single git repo that houses one users dotfiles that are
deployed across several hosts.  My .zshrc may be present on both host A and host
B, but perhaps with minor differences/optimizations.  This gem aims to ease the
process of managing identical or similar personal config files across many
machines.


### The Planned Implementation ###

Users configure a file located at ~/.dotdash.conf. The only required config
option at this point is `git_repo_url` which points `dotdash` to a place to
fetch dotfiles from.  The repository of config files will be located at
`~/.dotdash` and have the a structure represented by this example:

```
.dotdash/
    host_a/
        .somethingrc
        .mutt/
            .mutt_config1
            .mutt_config2
    host_b/
        .zshrc
        .tmux.conf
        .ssh/
            config
    ...
```
