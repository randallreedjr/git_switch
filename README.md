[![CircleCI](https://circleci.com/gh/randallreedjr/git_switch.svg?style=shield)](https://circleci.com/gh/randallreedjr/git_switch)
[![Gem Version](https://badge.fury.io/rb/git_switch.svg)](https://badge.fury.io/rb/git_switch)

# Git Switch

Git Switch is a command line utility to easily switch between multiple git profiles. It uses a `.gitswitch` YAML file to configure each profile (name, username, and email) and ssh key.

## Installation

This gem is not intended to be installed via a Gemfile. Instead, install it yourself:

    $ gem install git_switch

## Configuration

Although a guided setup is planned, for now you must manually create your configuration at `~/.gitswitch`. The config file is in YAML format. Here is an example.

```
personal:
  username: johnnyfive
  email: me@johnsmith.com
  name: Johnny Smith
  ssh: ~/.ssh/id_rsa
work:
  username: johnsmith
  email: john@defmethod.io
  name: John Smith
  ssh: ~/.ssh/defmethod_rsa
```

Note that the ssh key must already exist. See these instructions to [generate a new SSH key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

The root keys can be any nickname you want. It should be memorable to make it easy to switch between profiles.

## Usage

Git Switch follows the convention to create a custom git command. It can be invoked as follows, to either set your git profile locally or globally:

```
$ git switch personal
$ git switch personal -g
```

Note that currently, invoking `git switch` will remove all identities from `ssh-add`, except the one specified. You can always readd them using `ssh-add path/to/ssh`.

### Flags

* Use `-l` or `--list` to list configured profiles

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
