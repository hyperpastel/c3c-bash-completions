# Bash completions for the [C3 compiler (c3c)](https://github.com/c3lang/c3c)
These completions can be downloaded and sourced in your `.bashrc`
or equivalent.
For example:
```sh
# In ~/.bashrc
source $HOME/completion-scripts/c3c-bash-completions/c3c_completion_script.sh
```

Completions are provided for all the subcommands like `compile`, `run` or `clean`,
and for the many flags.
When double tapping tab after `$ c3c `, only the subcommands will show up to not
completely fill the screen, but pressing double tap after `$ c3c -` will
give you all the flags.

Flags which take in an argument after a `=` will show up their available values
after having written out (or completed) the flag up till `=`
(without space behind) and double "tabbing".

Commands like `build` which take in a target (from project.json) have
smart target-completion using `c3c project view --targets`.
This is a flag introduced to c3c in commit [c326c525be](https://github.com/c3lang/c3c/commit/c326c525be92f89ad437cf6afb03661fb6537b17).
It will be in release 0.6.7, or is now available in `latest`.
