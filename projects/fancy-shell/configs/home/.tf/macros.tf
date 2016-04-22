; Aliases
/def ls=/listsockets
/def wu=/world (unnamed%*)
; /def lw=/listworlds

; Check all: flushes pending output on all open sockets.
/def ca=/quote -0 /fg -> `/listsockets

; fna - /fg next active
;   Implemented by storing ids of idle worlds in a queue. Hooks into ACTIVITY
; and if that world isn't already queued it adds it to the end. /fna changes
; to the world at the head of the queue and removes it.
/def fna = /_fna %{act_queue}
/def _fna = /fg %1%;/set act_queue=%-1
/hook ACTIVITY = /if (strstr(%{act_queue},%1) != -1) /set act_queue=%{act_queue} %1%;/endif

; rl - reload (reconfigure)
/def rl=/load ~/.tf/macros.tf %;/load ~/.tf/worlds.tf

; The following are "ListWorldsJustify(N)" vars
/set lwj1=0
/set lwj2=0
/set lwj3=0

; The following is 'list world sub one'
; It lists a world formatted.
/def lws1 = /echo | $[strcat(strrep(" ", (lwj2-strlen(%2))), %2)] \
                   ($[strcat(strrep(" ", (lwj1-strlen(%1))), %1)]) \
                    $[strcat(strrep(" ", (lwj3-strlen(%3))), %3)] \
                    %5:%6
/def lw = /echo -- +---
/def adworld = /if ({1} =/ "-T*") \
                 /addworld %1 %-2%; \
                 /shift %; \
               /else \
                 /addworld %-1%; \
               /endif %; \
               /def %1 = /world %2 %; \
               /def lw = ${lw}\%;/lws1 %*%;\
               /if (strlen(%1) > lwj1) /set lwj1=$[strlen(%1)] %; /endif %; \
               /if (strlen(%2) > lwj2) /set lwj2=$[strlen(%2)] %; /endif %; \
               /if (strlen(%3) > lwj3) /set lwj3=$[strlen(%3)] %; /endif

/def all = / 
/def adworldp = /adworld %*%; \
                /if ({1} =/ "-T*") \
                  /def all = ${all}\%;/world %3%; \
                /else \
                  /def all = ${all}\%;/world %2%; \
                /endif \

/def idlebeep = \
  /if (idle(%1) > 120) \
    /beep %; \
    /repeat 1 /idlebeep %; \
  /endif

/hook ACTIVITY = /idlebeep %1
/hook CONNECT = /log -w ~/.tf/logs/${world_name}-$[ftime("%Y%m%d-%H.%M", time())].log

; Get lag by finding out how long it takes to page oneself.
/def ping = page me with PING: :$[time()]:
/def -mregexp -t"PING: :(.*):" = /let t=%{P1}%;/echo PING: Lag measured at $[time() - t]

; TODO: macros and key bindings to define 'previous world' and
; 'world before that'. Should work almost like Windows ALT-Tab if possible.
