module.exports =
  fshDirName: '.fsh'
  help:
    usage:
      """

          Fancy Shell control program

      Usage:
      
          fsh [opts] module[:command] [parameters...]

      Some modules:
          
          help         usage and such
          init [dir]   create a skeleton .fsh directory
          config       configure .fsh, ../.fsh, ../.. or whatever
          ignore       add pathspec to .fsh/ignore or $EDITOR .fsh/ignore
          changes      diff
          backup       commit and push changes
          update       pull
          restore      copy backup
          repo         echo full path to applicable .fsh/copy
      """


