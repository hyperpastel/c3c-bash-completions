# Bash completions for the C3 compiler (c3c)
These completions can be downloaded and sourced in your `.bashrc`
or equivalent.
For example:
```sh
# In ~/.bashrc
source $HOME/completion-scripts/c3c-bash-completions/c3c_completion_script.sh
```

Completions are provided for all the subcommands like `compile`, `run` or `clean`,
and for the many flags.
When double tapping after `$ c3c `, only the subcommands will show up to not
completely fill the screen, but pressing double tap after `$ c3c -` will
give you all the flags.

Flags which take in an argument after a `=` will show up their available values
after having written out (or completed) the flag up till `=`
(without space behind) and double tapping tab.


My dream is now to further smartify this, so that for example the `build`
subcommand completion knows which targets there are.
