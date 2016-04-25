# A Fancier Shell Environment for Fancier People

Making my shell environments (and those of others perhaps) do more right
things by default.

# Features

  - autocompletion
  - screen
  - ssh-agent
  - LANG
  - 256 colors
  - prompt
  - config mgmt (small-projects/configs)
  - staged config separate from git repo
    - so that modifications don't show up in git status

# How

  - .fsh in any directory configures that directory and its children
    - bin/ contains utility scripts
      - $foo/.fsh/bin/backup
        - copies $foo/whatever to $foo/.fsh/scm
      - $foo/.fsh/bin/restore
        - copies $foo/.fsh/scm/* to $foo
    - lib/ is self explanatory
    - data/ is self explanatory

    - .bashrc.d/
      - .bashrc sources contents of .bashrc.d/
      - 0...
        - Defaults
      - 3...
        - Libraries
      - 5...
        - User owned
      - 7...
        - Consume user prefs and activate stuff
      - 9...
        - Overrides, failsafes

      - 50-prefs
      - 70-ssh-agent
        - Reconnect if live agent exists else start one
      - 70-prompt
        - Colors, time, host, user, etc
      - 72-screen
        - Menu at login for resuming an old screen or starting a new one

# Workflows

## Making and saving a config change

    $ vi .bashrc
    # ... 
    $ .fsh/bin/backup
    (git diff output, then)
    Proceed anyway? (Y/n) Y
    $ 
