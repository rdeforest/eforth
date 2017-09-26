% 48: /def proxy_command = telnet ${world_host} ${world_port}
% 270: /def -b'^X' = /dokey SOCKETF
% 271: /def -b'^B' = /recall 20
% 272: /def ls = /listsockets
% 273: /def -p1 -ag -h'BACKGROUND' 
% 274: /def q = /quote /send %*
% 275: /def th = :. o O ( %{*} )
% 276: /def url = /sh netscape -display localhost:0.0 -remote "openURL(%{*})" &
% 277: /def chef = /quote say !echo "%*" | chef
% 278: /def val = /quote say !echo "%*" | valspeak
% 279: /def jive = /quote say !echo "%*" | jive
% 280: /def babble = /quote say !echo "%*" | valspeak | jive | chef
% 281: /def jj = /quote say !echo "%*" | valspeak | jive | jive
% 282: /def -p1 -t'*pages*wake*up*' = /sh vplay /usr/local/snd/wav/monty/message.wav &
% 283: /def -p1 -t'*55 minutes*' unidle = eval "Unidle"
% 284: /def -p1 -agG -mregexp -t'^#\\$# edit name: .* upload: (.*)$' ed1 = /sys echo "%P1" >.ed.log %; /log -w .ed.log  %; /set editing 1 %; /def -p1 -agG -t".*" gagall
% 285: /def -p5 -ag -mregexp -t'^\\.$' ed2 = /if /test %editing==1 %; /then /set editing 0 %; /undef gagall %; /log off %; /sh pico -t -w .ed.log && echo ".">>.ed.log %; /quote -S '.ed.log %;/else /echo .%; /endif
% 286: /def xred = /sh color_xterm -ls -r -fn 12x24 -geometry 81x20+0+0 -e pico -w -t .ed.log &
% 287: /def red = /sh pico -w -t .ed.log %; /quote -S '.ed.log
% 288: /def elm = /sh color_xterm -ls -r -fn 12x24 -geometry 81x20+0+0 -e elm &
% 289: /def -p1 -ag -mregexp -t'^#\\$#display-url [0-9]* url: \\"(.*)\\" command: goto $' = /sh lynx %P1
% 290: /def -p1 -ag -mregexp -t'^#\\$#mcp version: .*' = #\$#authentication-key 1234567
% 298: /def l = /world local
% 299: /def LO = /world Local
% 302: /def adworld = /def %1 = /world %2 %;/addworld %-1
% 303: /def AK = /world Arkham
% 304: /def AQ = /world AquaMOO
% 305: /def BA = /world BayMOO
% 306: /def BE = /world Brecktown
% 307: /def BI = /world BioMOO
% 308: /def BM = /world BlueMOOn
% 309: /def BoM = /world BovineMUSE
% 310: /def BU = /world Butterfly
% 311: /def CA = /world Caine
% 312: /def CC = /world ColdCore
% 313: /def CM = /world CowsGoMOO
% 314: /def CN = /world Connections
% 315: /def CT = /world CollegeTown
% 316: /def CO = /world CoastalHomes
% 317: /def CY = /world Cybersphere
% 318: /def DE = /world DeltaMOO
% 319: /def DF = /world DragonsFire
% 320: /def DH = /world Dhalgren
% 321: /def DI = /world DiversityU
% 322: /def DM = /world DreaMOO
% 323: /def DP = /world DarkPhoenix-Wiz
% 324: /def DR = /world DruidMuck
% 325: /def ED = /world EdenMOO
% 326: /def EM = /world EMOO-Wiz
% 327: /def EN = /world EnigMOO
% 328: /def EO = /world EON
% 329: /def EP = /world EmpireOfTheMOOns
% 330: /def ER = /world ErasMOO
% 331: /def FA = /world FacistMOO
% 332: /def FN = /world FrednetMOO
% 333: /def FO = /world ForestMOO
% 334: /def GO = /world Goldfish
% 335: /def HT = /world HarpersTale
% 336: /def IC = /world Ice-Nine
% 337: /def ID = /world IDMOO
% 338: /def IM = /world ImmaterialPark
% 339: /def IS = /world IslandMOO
% 340: /def JH = /world JaysHouse
% 341: /def LA = /world Lambda1-Ice
% 342: /def L2 = /world Lambda2-Hellblazer
% 343: /def L3 = /world Lambda3-Glass
% 344: /def LI = /world LittleItaly
% 345: /def M2 = /world Moo2000
% 346: /def MD = /world Meadows
% 347: /def ME = /world MediaMOO
% 348: /def MI = /world MirrorMOO
% 349: /def MO = /world MOOf
% 350: /def MU = /world MuMOO
% 351: /def MT = /world MOOtiny
% 352: /def NE = /world NecroMOO
% 353: /def OU = /world OutlawMOO
% 354: /def OP = /world OpalMOO
% 355: /def PL = /world PlowMOO
% 356: /def PM = /world PMC
% 357: /def RI = /world RiverMOO
% 358: /def SI = /world Singlemoo
% 359: /def SY = /world Syrinx
% 360: /def TE = /world TecfaMOO
% 361: /def TI = /world TinyMOO
% 362: /def UM = /world UMOO
% 363: /def UN = /world UNM-MOO
% 364: /def VE = /world VEE
% 365: /def XX = /world XX
% 366: /def -p2 -agG -mregexp -w'JaysHouse' -t'^other:(.* says.*)' = /echo -wJaysHouse -aBCred - %P1
% 367: /def -p2 -agG -mregexp -w'JaysHouse' -t'^self:(.* say, .*)' = /echo -wJaysHouse -aCred - %P1
% 368: /def -p2 -agG -mregexp -w'JaysHouse' -t'^other:(.* says to .*, .*)' = /echo -wJaysHouse -aBCyellow - %P1
% 369: /def -p2 -agG -mregexp -w'JaysHouse' -t'^self:(You say to .*, .*)' = /echo -wJaysHouse -aCyellow - %P1
% 370: /def -p1 -agG -mregexp -w'JaysHouse' -t'^other:(.*)' = /echo -wJaysHouse -aBCcyan - %P1
% 371: /def -p1 -agG -mregexp -w'JaysHouse' -t'^self:(.*)' = /echo -wJaysHouse -aBCwhite - %P1
% 372: /def -p1 -aB -aCred -w'BioMOO' -t'*say*' 
% 373: /def -p1 -aB -aCred -w'MirrorMOO' -t'*say*' 
% 374: /def -p1 -aB -aCyellow -w'BioMOO' -t'* \\[to *' 
% 375: /def -p1 -aB -aCyellow -w'MirrorMOO' -t'* \\[to *]:*' 
% 376: /def -p1 -aB -aCyellow -w'MirrorMOO' -t'* says to *, *' 
% 377: /def -p1 -aB -aCyellow -w'MirrorMOO' -t'You say to *, *' 
% 378: /def reload = /load reload
% 379: /def minrecycler = eval ;;a=\$maxint; for l in (\$recycler.contents) b=tonum(l); if (b<a) a=b; endif endfor return a;
% 380: /def checkrecycler = eval ;a={}; for l in (\$recycler.contents) if (tonum(l) < 1000) a={@a,l}; endif endfor return a;
% 381: /def peek = eval-d ;who=\$string_utils:match_player ("%{*}"); if (!(data=who.responsible)) data=\$paranoid_db:get_data(who); endif for l in (data) notify (player,tostr(@l[length(l)])); endfor return "Peek on "+who.name+" finished.";
% 382: /def jhpeek = eval ;data=me.responsible; for l in (data) player:tell(tostr(@l[length(l)])); endfor
% 383: /def makepeek = eval ;who=\$string_utils:match_player("%{*}"); who.paranoid=1; buh="responsible ok"; if (typeof(who.responsible)!=LIST) who.responsible={}; buh="responsible reset"; endif who.lines=max(who.lines,10); return {who,who.name,buh,who.lines};
% 386: /def -p1 -t'' * /if (/idle() > 120) /beep /endif beep 
