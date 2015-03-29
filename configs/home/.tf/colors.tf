
/ Colorize MOO text

/ Types of text to separate
/   comms:
/     public: speech, directed speech, emote
/     private: page, pageemote
/   other: (to be done later...)
/     @who output
/     Navigational output (look, movement)

/set friends=Jacque|stormagnet|Binder|Crag

/set comms_say_speaker=BCwhite
/set comms_say_text=dCcyan

/set comms_say_to_speaker=BCwhite
/set comms_say_to_target=BCwhite
/set comms_say_to_text=Cgreen

/eval /set comms_say    ^(%{friends-.*}) says, \\"(.*)\\"
/eval /set comms_say_to ^(%{friends-.*}) \\[to (.*)\\]: (.*)
/eval /set comms_emote  ^(%{friends-.*}) (.*)

/eval /set comms_page=^(%{friends-.*}) pages, \\"(.*)\\"
/eval /set comms_epage=^\\(from (.*)\\) (%{friends-.*}) (.*)

/purge -P1

/ Default color
/ def -F -PCyellow -t"."

/ Person says, "stuff"
/eval /def -F -P1%{comms_say_speaker} -t"%{comms_say}"
/eval /def -F -P2%{comms_say_text}    -t"%{comms_say}"

/eval /def -F -P1%{comms_say_to_speaker} -t"%{comms_say_to}"
/eval /def -F -P2%{comms_say_to_target}  -t"%{comms_say_to}"
/eval /def -F -P3%{comms_say_to_text}    -t"%{comms_say_to}"
