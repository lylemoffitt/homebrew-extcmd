# Homebrew External-Command Manager

## What is this?

This is an extension on the OSX package manager, [Homebrew](http://brew.sh),
that makes it easy to find and manage Homebrew's  [external-commands](https://github.com/Homebrew/brew/blob/master/docs/External-Commands.md).

> Currently WIP

## Usage


Search for all external-commands with 'growl' in the name.
```
brew ext search growl
```

Search for all external-commands with 'growl' in the description.
```
brew ext search --desc growl
```

Print description of the external-command 'brew-growl'.
```
brew ext desc brew-growl
```

Open the home page for external-command 'brew-growl'.
```
brew ext home brew-growl
```

Install the external-command 'brew-growl'.
```
brew ext install brew-growl
```

Remove the external-command 'brew-growl'.
```
brew ext uninstall brew-growl
```

## Uploading

You can upload easily add your own external-commands so they are picked up
by homebrew. Just submit a manifest.

For example the manifest for an external-command like `brew-growl` from the [list](https://github.com/Homebrew/brew/blob/master/docs/External-Commands.md)
would is represented with a simple YAML file like this:

```YAML
---
name:   brew-growl
desc:   Get Growl notifications for Homebrew
home:   https://github.com/secondplanet/homebrew-growl
install:    # Prepend each line with 'brew' before executing
    - tap secondplanet/growl
    - install brew-growl
uninstall:  # Same as above
    - uninstall brew-growl
    - untap secondplanet/growl
test:       # Each must: [$?==0] after 'install' & [$?!=0] after 'uninstall'
    - command growl
    - growl on
---
```


## Improvements

Granted, even this example has problems, b/c `brew-growl.rb` doesn't list its
dependency on `growlnotify`. However, I think it also get's a lot of stuff right:
1)  The problem caused by missing requirements would be caught by at least one
    of the tests.
2)  Our package only stores what commands to execute, which leaves the burden
    of maintenance on the original dev.
3)  Because the commands are universal and generic, we have very loose coupling
    with the formula/tap, which minimizes maintenance burden when the
    tap/formula gets updated, modified, or even changes repos.
4)  Using `brew` commands gives us a basic guarantee against arbitrary shell
    commands and dependencies.
5)  Having tests allows us to verify installs, detect breaking changes, and
    collect (and report) metrics about whether or not an extcmd "works" for a
    majority of users. This could potentially be reported to the maintainer.
6)  Storing a GitHub homepage means we can relate metrics to the user and
    indicate the health/volatility of the extension.
7)  It's a simple and popular format with a very low barrier to entry, which
    should make it as easy as possible for developers to add and maintain
    their associated extcmds package.


## Goals

All in all, I think this goes a long way towards meetings the goals of such a
system. To clarify they are:
1)  Maintaining a relationship (with mutual feedback) between extcmd devs and
    the users who want to experiment with and use them.
2)  Lower barriers to entry for users looking for more features in Homebrew.
3)  Lower barriers to entry for devs who wish to add more features to Homebrew.
4)  Minimize maintenance upkeep for the maintainers of both the extcmd repo and
    the extcmd tap/formula.
5)  Ease integration of extcmds into brew by providing clear measures for
    eliability and desirability.


## Commments

Please let me know what you think.
 - Am I off the mark?
 - Where/Why will this system not work?
 - What could be improved?
