module.exports =
  description:
    """
      Using this single file as my tracking for ALL my efforts. Detailed notes
      and such should go with projects, but time-box info should go here.
    """
  projects:
# Any object with a "mission" is a project
    personal:
      meta:
        mission: "program myself out of my confusion hole"
        github: "git@github.com:rdeforest/rdeforest"
        sessions:
          "2016-04-10 15:00":
            context: "Sunday at Linda's, ended my LOA last week"
            plan: "Move doing.md from ROT to personal/meta"
            actual:
              planChanged:
                why: """
                    ROT is the only project with a doing.md and it has different
                    versions in different branches which is also exatly why it
                    needs to move out of that repo. New plan is to deal with that
                    when I'm focused on ROT.
                  """
                instead: "take a break"
      dev:
        "node-astrolog":
          description: "StrongLoop wrapper for Astrolog"
          mission: "make Astrolog more accessible, have fun"
          github: "git@github.com:rdeforest/node-astrolog"
          sessions:
            "2016-04-10 17:00":
              plan: "get .now test passing or disable it with reason"
              actual:
                progress: [
                    "test now fails for the right reason (feature not finished"
                    "started code re-org"
                  ]
                also: "thinking about trying to be more OO"
            "2016-04-10 14:30":
              plan: "Reviewing architecture"
              actual:
                learn: "Reviewed Design Patterns"
                reorg: "Moved doing.md stuff to rdeforest project"
              notes:
                """
                - Models
                  - Subject: relates time and place
                  - Chart: Composite of multiple subjects and options
                  - AstroRun: Invoker of Astrolog
                  - AstroParse: Interpreter for Astrolog output
                """
            "2016-04-08 18:00":
              plan: "Get currently extant tests passing or marked as known bugs"
              actual:
                moretime: 1
                success: true
                extratime: "plan next session"
            "2016-04-01 15:30":
              plan: "'able to run' test passing"
              actual: success: true
            "2016-04-01 14:40":
              plan: "runner tests passing"
              actual: failed: "session goal too large"
            "2016-04-01 13:30":
              plan: "switches tests passing"
              actual:
                moretime: 1
                success: true
            "2016-04-01 12:10":
              plan: "text runner passing tests without cheating"
              actual:
                moretime: 2
                failed:
                  why: "did other work"
                  learned: false
            "2016-03-31 17:00":
              plan: "chats with Ty and Bruce"
              actual: success: true
            "2016-03-31 14:00":
              plan: 'Describe the app more than just "wrap astrolog in StrongLoop"'
              actual: failed: why: [ "goal too vague", "did other work" ]

            "2016-03-31 14:00":
              plan: "Review and refactor existing tests"
              actual: success: true
