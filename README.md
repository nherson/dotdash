Dotdash
=======

### Purpose ###

The goal is to have a single git repo that houses one user's dotfiles that are
deployed across several hosts.  My .zshrc may be present on both host A and host
B, but perhaps with minor differences/optimizations.  This gem aims to ease the
process of managing identical or similar personal config files across many
machines.

### Usage ###

The following commands are currently supported:

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
```

##### Wishlist #####
```
dotdash link HOST1 [HOST2] FILE
```

### Installation ###

##### From Source #####
```
git clone https://github.com/nherson/dotdash
cd dotdash
bundle install
gem build dotdash.gemspec
gem install ./dotdash-X.X.X.gem  # where you replace X.X.X with what you got from 'gem build dotdash.gemspec'
```
##### Via Rubygems #####
Coming soon!

### Setup ###

##### Git Repo #####
You need a git repo that you have read and write access to. GitHub accounts are free, so it is a great option. However you decide to configure your git situation, it is recommended that you have a way of authenticating automatically, to avoid typing in passwords over and over.  GitHub + SSH Keys is tried and true.

##### Dotdash Config #####
Next, you need a dotdash config file.  Use your favorite text editor to open `~/.dotdash.conf`:
```
host=
git_repo_url=
editor=
dir=
```
Go ahead and set these variables accordingly. `host` is the hostname of the machine; this defaults to the string returned by `hostname -s`.  `git_repo_url` is the external location where your dotdash repo lives.  If you are using GitHub with SSH keys, it should look like this `git@github.com:YOUR_GITHUB_USERNAME/YOUR_DOTDASH_REPO_NAME`. `editor` is the name of the editor you want to use to edit dotfiles in your repo, and it defaults to the environment value of `$EDITOR`. `dir` is the location where the local copy of the dotdash repo should live.  This defaults to `~/.dotdash`.

##### Bootstrapping #####

Simply run `dotdash init`.

### Known Issues ###

Deploying different hosts to the same machine can leave lingering files.  There should be a way to keep track of the most recent deployment on a given machine, and delete those files before deploying a new host to the machine.
