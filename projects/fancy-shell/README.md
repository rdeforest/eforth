Making my shell environments (and those of others perhaps) do more right
things by default.

  - autocompletion
  - screen
  - ssh-agent
  - LANG
  - 256 colors
  - prompt
  - config mgmt (small-projects/configs)

# How

  - .staged-config in directory configures that directory and its children
    - bin/ contains utility scripts (just re-link for now)
      - relink links foo -> .staged-config/data/foo
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

      

