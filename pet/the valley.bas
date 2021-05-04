10 rem ********************************
20 rem *      The Valley for PET      *
30 rem *                              *
40 rem *   typed-in and debugged by:  *
45 rem *     Trantor/Hokuto Force     *
50 rem *                              *
60 rem *  (C)1982 by Computing Today  *
65 rem *    (CT - April '82 Issue)    *
70 rem ********************************
99 rem ** define major variables **
100 dim d(3),g(73),p(8),n(8),s(4),t(2)
110 dim m$(18),ms(18),n1(18)
120 vg$="":gc$="":f$="":dl$=""
130 ts=0:tn=0:tm=3:cf=0
140 d$="{home}{down*21}"
150 d1$=left$(d$,17)
160 sp$="{space*39}"
170 r$="{right*30}"
180 r1$=left$(r$,21)
299 rem ** skip scene data
300 for i=1 to 32
310 read c$
320 next i
329 rem ** load monster data
330 for i=0 to 18
340 read m$(i):read ms(i): read n1(i)
350 next i
999 rem ** character choice and load
1000 print "{clear}{down}load a character from disk (y/n) ?"
1010 vg$="yn":gosub1500:rem ** uniget
1020 input "{down}character's name {right*2}*{left*3}";j$
1030 if j$="*" then 1020
1040 if len(j$)>16 then print "{down}too long":goto 1020
1050 if gc$="n" then 1240
1060 print"{clear}place data disk in the drive"
1070 print"{down}is the lid closed ?"
1080 gosub1600:rem ** anykey
1090 open 8,8,8,""+j$+",r,s"
1100 input#8,p$
1110 input#8,ts
1120 input#8,ex
1130 input#8,tn
1140 input#8,cs
1150 input#8,ps
1160 input#8,t(0)
1170 input#8,t(1)
1180 input#8,t(2)
1190 input#8,c1
1200 input#8,p1
1210 close 8
1220 c=150
1230 goto 1400
1240 print "{clear}{down*2}character types... chose carefully"
1250 print
1260 print"wizard    (1)"
1270 print"thinker   (2)"
1280 print"barbarian (3)","key 1-5"
1290 print"warrior   (4)"
1300 print"cleric    (5)"
1310 get gc$:if gc$="" then 1310
1320 a=val(gc$)
1330 if a=1 then p$="wizard":p1=2:c1=0.5:cs=22:ps=28
1340 if a=2 then p$="thinker":p1=1.5:c1=0.75:cs=24:ps=26
1350 if a=3 then p$="barbarian":p1=0.5:c1=2:cs=28:ps=22
1360 if a=4 then p$="warrior":p1=1:c1=1.25:cs=25:ps=25
1370 if a=5 then p$="cleric":p1=1.25:c1=1:cs=25:ps=25
1380 if a<1 or a>5 then p$="dolt":p1=1:c1=1:cs=20:ps=20
1390 ex=5:c=150
1400 print"{down*2}good luck"
1410 print"{down}";j$;" the ";p$
1420 df=150:dl$="d":gosub 36000:rem ** delay
1430 gosub 10000:rem ** valley draw
1440 df=5:gosub 36000:rem ** delay + update
1450 goto 2000:rem ** movement
1499 rem ** uniget routine
1500 get gc$:if gc$="" then 1500
1510 for i=1 to len(vg$)
1520 if mid$(vg$,i,1)=gc$ then return
1530 next i
1540 goto 1500
1599 rem ** anykey routine
1600 print "{down}** press any key to continue **"
1610 get gc$:if gc$="" then 1610
1620 return
1699 rem ** combat get routine
1700 for i =1 to 10:get gc$:next i: rem ** empties buffer
1710 tv=0
1720 for i=1 to 60
1730 get gc$:if gc$="" then 1750
1740 goto 1770
1750 next i
1760 tv=1:rem ** no key pressed
1770 print d$;sp$:rem ** wipe away message
1780 return
1999 rem ** movement routine
2000 m=w:pk=peek(w):poke m,81
2010 c=c+10
2020 if pk=77 or pk=78 then 2040
2030 print d$;"your move...which direction ?":goto 2050
2040 print d$;"safe on the path..which way ?"
2050 for i=1 to 10:get gc$:next i:rem **clear kbd buffer
2060 get gc$:if gc$="e" then 45000:rem ** ego
2069 rem ** special routine for numeric keypads
2070 a=val(gc$):if a=0 then 2060
2080 if a>3 then a=a-3:goto 2080
2090 w=m+a-2-40*(int((val(gc$)-1)/3)-1)
2100 tn=tn+1:print d$;sp$
2109 rem ** am i stepping on something ?
2110 q=81:q1=peek(w):if q1=32 or q1=45 then 2190
2120 if q1=219 then 48000: rem ** quit
2130 if q1=214 or q1=160 or q1=88 then tn=tn-1:goto 2030:rem ** hit wall or tree
2140 if q1=216 or q1=87 or q1=173 or q1=230 then 9000: rem ** scene entry
2150 if q1=104 or q1=95 then 9090: rem ** scene exit
2160 if q1=102 then 15000: rem ** stairs
2170 ifq1=224or(gc$="5"andpk=224)thenq=209:c=c-20:ifc<=0then55000:rem ** water
2180 if q1=42 then 2800: rem ** special find
2190 poke m,pk:pk=peek(w):m=w:poke m,q
2200 if pk=77 or pk=78 then df=5: goto 2250
2209 rem ** nothing, monster or find perhaps ?
2210 rf=rnd(ti)
2220 if rf<0.33 then 3000:rem ** monster select
2230 if rf>0.75 then 2300:rem ** find select
2240 print d$;"nothing of value...search on":df=80
2250 gosub36000:rem ** delay + update
2260 goto 2010
2299 rem ** finds routine
2300 rf=int(rnd(ti)*6+1)
2310 on rf gosub 2340,2380,2380,2410,2410,2440
2320 df=80:gosub 36000:rem ** delay + update
2330 goto 2010
2340 print d$;"a circle of evil...depart in haste !"
2350 cs=cs+int((fl+1)/2):ps=ps-int((fl+1)/2):c=c-20
2360 if c<=0 then 55000:rem ** death
2370 return
2380 print d$;"a hoard of gold"
2390 ts=ts+int(fl*rnd(ti)*100+100)
2400 return
2410 print d$;"you feel the auro of the deep magic..."
2420 print "{space*8}...all around you..."
2430 goto2450
2440 print d$;"...a place of ancient power..."
2450 ps=ps+2+int(fl*p1):cs=cs+1+int(fl*c1):c=c+25
2460 return
2799 rem ** special finds routine
2800 poke m,32:m=w:pk=32:poke m,81
2810 rn=rnd(ti):print d$;sp$
2820 if s=6 and rn>0.95 and t(1)=6 and t(2)=0 and rt>25 then t(2)=1:goto2870
2830 if s=5 and rn>0.85 and t(0)=0 then t(0)=1:goto 2880
2840 if s=4 and rn>0.7 and t(0)=1 and t(1)<6 and fl>t(1) then 2890
2850 if rn>0.43 then print d$;"a worthless bauble":goto2940
2860 print d$;"a precious stone !":goto 2930
2870 print d$;"you find the helm of evanna !":goto 2930
2880 print d$;"the amulet of alarian...empty...":goto2930
2890 print d$;"an amulet stone...":print
2900 df=60:dl$="d":gosub36000: rem ** delay
2910 if rn>0.85 then print "{down}...but the wrong one !":goto2940
2920 print "{down}...the stone fits !":t(1)=t(1)+1
2930 ts=ts+100*(t(0)+t(1)+t(2)+fl)
2940 df=80:gosub 36000: rem ** delay + update
2950 goto2010
2999 rem ** monster selection routine
3000 print d$;"** beware... thou hast encountered **"
3010 ms=0:n=0:cf=1
3020 rf=int(rnd(ti)*17):if rf>9 and rnd(ti)>0.85then3020
3030 if q1=224 or pk=224 then rf=int(rnd(ti)*2+17)
3040 if rf=16 and rnd(ti)<0.7 then 3020
3050 if fl<5 and rf=15 then 3020
3060 x$=left$(m$(rf),1)
3070 for i=1 to len(f$)
3080 if mid$(f$,i,1)=x$ then3110
3090 next i
3100 goto 3020
3110 m$=right$(m$(rf),len(m$(rf))-1)
3120 if ms(rf)=0 then 3150
3130 ms=int((cs*0.3)+ms(rf)*fl^0.2/(rnd(ti)+1))
3140 if n1(rf)=0 then 3160
3150 n=int(n1(rf)*fl^0.2/(rnd(ti)+1))
3160 u=int((rf+1)*(fl^1.5))
3170 if rf>23 then u=int((rf-22)*fl^1.5)
3180 print"{down}";left$(r$,12-(len(m$))/2);"an evil ";m$
3190 df=40:gosub 36000:rem ** delay + update
3499 rem ** character's combat routine
3500 if rnd(ti)<0.6then 4000: rem ** monster's combat
3510 print d$;"you have surprise...attack or retreat"
3520 gosub  1700: rem ** combat get
3530 if gc$="r" then 3900
3540 if tv=1 then 3600
3550 if gc$<>"a" then 4000
3560 df=30:dl$="d":gosub 36000:rem ** delay
3570 print d$;"*** strike quickly ***"
3580 gosub 1700: rem ** combat get
3590 if tv=0 then 3620
3600 print d$;"* too slow...too slow *"
3610 hf=0:goto 3830
3620 e=39*log(ex)/3.14
3630 if gc$="s"then 4500: rem ** spell control
3640 if ms=0 then print d$;"your sword avails you nought here":goto3830
3650 c=c-1
3660 if c<=0 then print d$;"you fatally exhaust yourself":goto55000:rem ** death
3670 rf=rnd(ti)*10
3680 if gc$="h" and (rf<5 or cs>ms*4) then z=2:goto 3730
3690 if gc$="b" and (rf<7 or cs>ms*4) then z=1:goto 3730
3700 if gc$="l" and (rf<9 or cs>ms*4) then z=0.3:goto 3730
3710 print d$;"you missed it !"
3720 hf=0:goto 3830
3730 if hf=1 then d=ms+int(rnd(ti)*9):hf=0:goto3760
3740 d=int((((cs*50*rnd(ti))-(10*ms)+e)/100)*z):if d<0 then d=0
3750 if cs>(ms-d)*4 then hf=1
3760 ms=ms-d
3770 print d$;"a hit..."
3780 df=60:dl$="d":gosub 36000:rem **delay
3790 if d=0 then print d$;"{right*8}but...no damage":hf=0:goto3830
3800 print d$;"{right*8}";d;" damage...":if ms<=0 then 3860: rem ** it's dead
3810 if hf=1 then df=30: dl$="d":gosub 36000: rem ** delay
3820 if hf=1 then print "{down}the ";m$;" staggers defeated"
3830 df=110:gosub 36000: rem ** delay + update
3840 if hf=1 then 3570
3850 goto 4000: rem ** monster's combat
3860 print d$;"{down*2}...killing the monster..."
3870 ex=ex+u:hf=0:cf=0
3880 df=80:gosub 36000: rem ** delay + update
3890 goto 2010: rem ** movement
3900 print d$;"knavish coward !":cf=0
3910 goto 3880
3999 rem ** monster's combat routine
4000 print d$;"the creature attacks..."
4010 df=50:dl$="w":gosub36000:rem ** delay + wipe
4020 if ms=0 then 4300: rem ** psionic attack
4030 if ms<n and n>6 and rnd(ti)<0.5 then 4300
4040 ms=ms-1:if ms<=0 then 4240
4050 rf=int(rnd(ti)*10+1)
4060 on rf goto 4070,4080,4090,4100,4110,4120,4120,4130,4140
4070 print d$;"it swings at you...and misses":goto4280
4080 print d$;"your blade deflects the blow":goto4280
4090 print d$;"...but hesitates, unsure...":goto4280
4100 z=3:print d$;"it strikes your head !":goto4150
4110 z=1.5:print d$;"your chest is struck !":goto4150
4120 z=1:print d$;"a strike to your swordarm !":goto4150
4130 z=1.3:print d$;"a blow to your body !":goto4150
4140 z=0.5:print d$;"it catches your legs !":goto4150
4150 df=60:dl$="d":gosub 36000:rem ** delay
4160 g=int((((ms*75*rnd(ti))-(10*cs)-e)/100)*z)
4170 if g<0 then g=0:print d$;"...saved by your armour !{space*2}":goto4280
4180 c=c-g
4190 if g>9 then cs=int(cs-g/6)
4200 if g=0 then print d$;"shaken......but no damage done":goto4280
4210 print d$;"you take...{space*6}{left*6}";g;" damage...{space*6}"
4220 if cs<=0 or c<=0 then 55000: rem ** death
4230 goto 4280
4240 print d$;"...using its last energy in the attempt"
4250 ex=int(ex+u/2):cf=0
4260 df=100:gosub 36000: rem ** delay + update
4270 goto 2010: rem ** movement
4280 df=100:gosub 36000: rem ** delay + update
4290 goto 3570: rem ** character's combat
4299 rem ** monster's psionic attack
4300 print d$;"...hurling a lightning bolt at you !"
4310 g=int(((180*n*rnd(ti))-(ps+e))/100):n=n-5:if g>9 then n=n-int(g/5)
4320 df=80:dl$="w":gosub 36000: rem ** delay + wipe
4330 if n<=0 then n=0: goto 4240
4340 if rnd(ti)<0.25 then 4410
4350 if g<=0 then g=0:goto 4400
4360 print d$;"it strikes home !"
4370 df=110:gosub 36000:rem ** delay + update
4380 c=c-g:if g>9 then ps=int(ps-g/4)
4390 goto 4210
4400 print d$;"your psi shield protects you":goto 4280
4410 print d$;"...missed you !":goto 4280
4499 rem ** spell control routine
4500 print d$;"which spell seek ye ? ":gosub1700:rem ** combat get
4510 if tv=1 then 3600: rem ** too slow
4520 if val(gc$)>0 and val(gc$)=<3 then 4540
4530 print d$;"no such spell...{space*5}":goto4640
4540 if 4*ps*rnd(ti)<=n then 4590
4550 on val(gc$) gosub 5000,5200,5400
4559 rem ** sc contains outcome flag
4560 on sc goto 4620,4640,4660,4570,4600,4580,4590
4570 print d$;"it is beyond you{space*5}":goto4640
4580 print"but the spell fails...!":goto 4640
4590 print d$;"no use, the beast's psi shields it":goto4640
4600 print d$;"the spell saps all you strength"
4610 goto 55000: rem ** death
4620 df=100:gosub 36000:rem ** delay + update
4630 goto2010:rem ** movement
4640 df=60:gosub 36000:rem ** delay + update
4650 goto 4000:rem ** monster's combat
4660 df=60:gosub 36000:rem ** delay + update
4670 goto 3570: rem ** character's combat
4999 rem ** spell 1 (sleepit)
5000 c=c-5:if c<=0 then sc=5:return
5010 print d$;"sleep you foul fiend that i may escape"
5020 print "and preserve my miserable skin"
5030 df=180:gosub 36000:rem ** delay + update
5040 print d$;"the creature staggers..."
5050 df=40:dl$="d":gosub 36000:rem ** delay
5060 if rnd(ti)<0.5 then 5090
5070 print "and collapses...stunned"
5080 ex=int(ex+u/2):cf=0:sc=1:return
5090 print "but recovers with a snarl !"
5100 sc=2:return
5199 rem ** spell 2 (psi-lance)
5200 if ms>c or ps<49 or ex>1000 then sc=4:return
5210 c=c-10:if c<=0 then sc=5:return
5220 if n=0 then print d$;"this beast has no psi to attack":sc=2:return
5230 print d$;"with my mind i battle thee for my life"
5240 df=120:gosub 36000:rem ** delay + update
5250 fr=rnd(ti):if rf<0.4 and n>10 then sc=6:return
5260 d=int((((cs*50*rf)-5*(ms+n)+e)/50)/4)
5270 if d<=0 then d=0:sc=7:return
5280 print d$;"the psi-lance causes ";d*2;" damage"
5290 n=n-3*d:if n<=0 then n=0
5300 ms=ms-d:if ms<=0 then ms=0
5310 if (ms+n)>0 then sc=2:return
5320 print "{down}...killing the creature"
5330 ex=ex+u:cf=0:sc=1:return
5399 rem ** spell 3 (crispit)
5400 if ps<77 or ex>5000 then sc=4:return
5410 c=c-20:if c<=0 then sc=5:return
5420 print d$;"with the might of my sword i smite thee"
5430 print "with the power of my spell i curse thee"
5440 print "burn ye spawn of hell and suffer..."
5450 df=240:gosub 36000:rem ** delay + update
5460 print d$;"a bolt of energy lashes at the beast..."
5470 df=80:dl$="w":gosub 36000:rem ** delay + wipe
5480 if rnd(ti)>(ps/780)*(5-p1) then print d$;"missed it !":sc=2:return
5490 d=int((cs+ps*rnd(ti))-(10*n*rnd(ti)))
5500 if d<=0 then d=0:sc=7:return
5510 if ms=0 then n=n-d:goto 5530
5520 ms=ms-d:if d>10 then n=int(n-(d/3))
5530 print d$;"it strikes home causing ";d;" damage{space*2}!"
5540 if (ms+n)<=0 then 5570
5550 df=80:dl$="d":gosub 36000:rem ** delay
5560 sc=2:return
5570 print"{down}the beast dies screaming !"
5580 ex=ex+u:cf=0:sc=1:return
8999 rem ** scenario control routine
9000 if q1=230 and pk=224 then print d$;"you cannot enter this way...":goto9110
9010 for i=2 to 7
9020 p(i)=0
9030 n(i)=int(rnd(ti)*5+4)
9040 if n(i)=5 then 9030
9050 next i
9060 if s=1 then mp=m
9070 p(2)=int(rnd(ti)*30+1)
9080 tf=tn:goto9130
9089 rem ** exit from scenario
9090 if tn>tf+int(rnd(ti)*6+1) then 9130
9100 print d$;"the way is barred"
9110 tn=tn-1:c=c-10:df=100:dl$="w":gosub 36000: rem ** delay + wipe
9120 goto 2010
9130 c=c-10:poke m,32:poke w,q
9140 if q1=96 then s=1:fl=1
9150 if q1=104 and s=4 then s=1:fl=1
9160 if q1=104 and s=5 or s=6 then s=s-3:fl=fl-4:m=mw
9170 if q1=173 then s=2:fl=2
9180 if q1=216 then s=3:fl=3
9190 if q1=216 or q1=173 then d2$=left$(d$,int(rnd(ti)*10)):r2$=left$(r$,p(2))
9200 if q1=87 then s=4:fl=2
9210 if q1=230 then s=s+3:fl=fl+4:mw=m
9220 on s gosub 10000,12000,12010,14000,14010,14010
9230 df=5:gosub 36000: rem ** delay + update
9240 goto 2000: rem ** movement
9999 rem ** scenario 1 (the valley)
10000 print"{clear}":f$="vaegh":fl=1:s=1
10009 rem ** draw the valley frame
10010 print"{home}{reverse on}{V*39}{reverse off}"
10020 for i=1 to 12
10030 print"{reverse on}{V}{reverse off}{space*37}{reverse on}{V}{reverse off}"
10040 next i
10050 print"{reverse on}{V*39}{reverse off}"
10059 rem ** if path already drawn skip
10060 if g(0)<>0 then 10190
10069 rem ** compute the path
10070 m=32809+(int(rnd(ti)*11+1)*40)
10080 l=m:mp=m:w=m:g(0)=m:g(1)=219
10090 for i=2 to 72 step 2
10100 if rnd(ti)>0.5 then 10120
10110 pc=77:l1=l+41:goto 10130
10120 pc=78:l1=l-39
10130 if l1>33286 or l1<=32806 then 10100
10140 g(i+1)=pc
10150 if i>2 and g(i+1)<>g(i-1) then l1=l+1
10160 g(i)=l1:l=l1:pokeg(i),g(i+1)
10170 next i
10180 g(73)=219
10189 rem ** plot in path
10190 for i=0 to 72 step 2
10200 poke g(i),g(i+1)
10210 next i
10220 if s(0)<>0 then 10280
10229 rem ** compute scenario positions
10230 for i=0 to 4
10240 n1=int(rnd(ti)*11)+1:n2=int(rnd(ti)*34)+1
10250 s(i)=32809+(40*n1)+n2
10260 if peek(s(i))<>32 or peek(s(i)+1)<>32 then 10240
10270 next i
10279 rem ** plot in scenarios
10280 poke s(0),216:poke s(0)+1,216:poke s(1),216:poke s(1)+1,216
10290 poke s(2),173:poke s(2)+1,173:poke s(3),173:poke s(3)+1,173
10300 poke s(4),87
10310 m=mp:w=m
10320 return
11999 rem ** scenario 2 (woods and swamps)
12000 f$="afl":pc=45:goto 12020
12010 f$="faehl":pc=88
12020 pk=32
12030 print "{clear}"
12039 rem ** draw random woods or swamps
12040 l=32810
12050 for i=1 to 200
12060 poke l+int(rnd(ti)*515),pc
12070 next i
12079 rem ** print in lake
12080 print "{home}";d2$;r2$;"{right*2}{reverse on}{space*2}{reverse off}"
12090 print r2$;"{right}{reverse on}{space*5}{reverse off}"
12100 print r2$;"{reverse on}{space*2}{reverse off}{space*2}{reverse on}{space*2}{reverse off}"
12110 print r2$;"{reverse on}{space*2}{&}{reverse off}{space}{reverse on}{space*4}{reverse off}"
12120 print r2$;"{right}{reverse on}{space*4}{reverse off}{right}{reverse on}{space*2}{reverse off}"
12130 print r2$;"{right*3}{reverse on}{space*2}{reverse off}"
12140 print r2$;"{right*4}{reverse on}{space}{reverse off}"
12149 rem ** draw in the frame
12150 print "{home}{sh space*40}";
12160 for i=1 to 13
12170 print "{sh space}{right*38}{sh space}";
12180 next i
12190 print "{sh space*40}"
12200 poke 33306,32:w=33306
12210 if q1=104 then m=mw:w=m
12220 return
13999 rem ** scenario 3 (castle-types)
14000 f$="cage":p=0:h=n(fl):pk=32:goto 14020
14010 f$="cbe":p=0:h=n(fl):pk=32:p(fl)=p(2)
14019 rem ** draw frame
14020 print "{clear}{reverse on}{right*2}{space*21}{reverse off}"
14030 for i=1 to 13
14040 print"{reverse on}{right*2}{space}{reverse off}{space*19}{reverse on}{space}{reverse off}"
14050 next i
14060 print "{reverse on}{right*2}{space*21}{reverse off}"
14069 rem ** draw vertical walls
14070 restore:for i=1 to p(fl)
14080 read v:if v=100 then restore
14090 next i
14100 l1=32810
14110 for j=1 to 3
14120 read d(j):p=p+1
14130 if d(j)=100 then restore:d(j)=3:p=p+1
14140 next j
14150 for i=0 to h:pc=160
14160 l=l1+(40*i):ifl>33290 then 14260
14170 if i=1 then pc=32
14180 if d(1)=0 then pc=160:goto14200
14190 poke l+d(1),pc:pc=160
14200 if i=3 then pc=32
14210 poke l+d(1)+d(2),pc:pc=160
14220 if i=4 then pc=32
14230 poke l+d(1)+d(2)+d(3),pc:pc=160
14240 next i
14250 l1=l1+(40*h)+40:goto14110
14259 rem ** draw horizontal walls
14260 l1=32810
14270 for j=1 to 4
14280 l=l1+(40*j*(h+1))
14290 for k=1 to 19
14300 if l>33250 then 14350
14310 poke l+k,pc
14320 if k=2 or k=3*h or k=17 then poke l+k,32:poke l+k-40,32:poke l+k+40,32
14330 next k
14340 next j
14349 rem ** draw in the stairs
14350 if s=5 or s=6 then 14380
14360 if fl/2=int(fl/2) then poke 33291,102:goto 14380
14370 poke32829,102
14379 rem ** doorway needed?
14380 if fl=2 or s=5 or s=6 then poke 33336,104:poke33296,32
14390 if p(3)=0 then w=33296
14399 rem ** write appropriate name
14400 if s=5 then 14470
14410 if s=6 then 14450
14420 print "{home}";r1$;"{down*4}{right*3}the black tower"
14430 print r1$;"{right*3}{space*3}of zaexon"
14440 print r1$;"{down*3}{right*3}{space*3}floor ";fl-1:goto14490
14450 print"{home}";r1$;"{down*2}{right*5}{reverse on}{space}vounim's{space}{reverse off}"
14460 print r1$;"{right*5}{reverse on}{space*3}lair{space*3}{reverse off}":goto14500
14470 print "{home}";r1$;"{down*2}{right*4}{reverse on}the temple of{reverse off}"
14480 print r1$;"{right*4}{reverse on}{space*2}y'nagioth{space*2}{reverse off}"
14490 p(fl+1)=p(fl)+p
14499 rem ** scatter special finds
14500 if fl<4 or rnd(ti)<0.3 then return
14510 for i=1 to int(rnd(ti)*5)+2
14520 n1=int(rnd(ti)*19)
14530 n2=int(rnd(ti)*12)
14540 if peek(32811+40*n2+n1)<>32 then 14520
14550 poke (32811+40*n2+n1),42
14560 next i
14570 return
14999 rem ** stairs routine
15000 poke w,81:poke m,32
15010 print d$;"a stairway... up or down ?":tv=fl
15020 vg$="ud":gosub1500:rem ** uniget
15030 if gc$="u" then fl=fl+1:goto 15050
15040 fl=fl-1
15050 if fl>7 or fl<2 then 15080
15060 df=110:dl$="d":gosub36000
15070 goto9220
15080 print d$;"these stairs are blocked{space}"
15090 df=60:dl$="d":gosub 36000:
15100 fl=tv:goto15010
35999 rem ** delay, wipe & update routine
36000 for dl=1 to (df*tm)
36010 next dl
36020 if dl$="d" then dl$="":return
36030 print d$;sp$
36040 print sp$
36050 print sp$
36060 if dl$="w" then dl$="":return
36070 if cs>77-int(2*p1^2.5)then cs=77-int(2*p1^2.5)
36080 if ps<7 then ps=7
36090 if ps>int(42*(p1+1)^log(p1^3.7))+75 then ps=int(42*(p1+1)^log(p1^3.7))+75
36100 if c>125-(int(p1)*12.5) then c=125-int(int(p1)*12.5)
36110 print d1$;"{up}";j$,p$
36120 print "treasure   =";ts
36130 print "experience =";ex
36140 print "turns      =";tn
36150 print d1$;r1$;"combat str ={space*4}{left*4}";cs
36160 print r1$;"psi power  ={space*4}{left*4}";ps
36170 print r1$;"stamina    ={space*4}{left*4}";c
36179 rem ** if fighting update monster
36180 if cf=1 then 36210
36190 print sp$
36200 return
36210 print d$;"{up*2}{reverse on}";m$;"{reverse off}";
36220 print d$;r1$;"{up*2}m str ={space*12}{left*12}";ms;n;"{space*4}"
36230 return
44999 rem ** rating routine
45000 df=5:dl$="w":gosub 36000: rem ** delay + wipe
45010 rt=int(0.067*(ex+ts/3)^0.5+log(ex/((tn+1)^1.5))):if rt>28 then rt=28
45020 if rt<0 then rt=0
45030 print d$;"your rating now be";rt
45040 if t(2)=1 then print "you have the helm of evanna"
45050 if t(0)=1 then print "amulet stones...{space}";t(1)
45060 df=250:dl$="w":gosub36000: rem ** delay + wipe
45070 if gc$="e" then c=c-10: gc$="":goto 2010: rem ** movement
45080 return
47999 rem ** quit valley routine
48000 print d$;"thou art safe in a castle":if cs<20 then cs=20
48010 poke m,pk:pk=peek(w):m=w:poke m,q
48020 print "wilt thou leave the valley (y/n) ?"
48030 vg$="yn":gosub 1500: rem ** uniget
48040 df=5:dl$="w":gosub 36000: rem ** delay + wipe
48050 gosub 45000: rem ** rating
48060 df=110:dl$="w":gosub 36000: rem ** delay + wipe
48070 if gc$="y" then 50000: rem ** save routine
48080 c=150:print d$:"thy wounds healed...thy sword sharp"
48090 print "go as the gods demand...trust none other"
48100 df=120:gosub36000: rem ** delay + wipe
48110 goto 2010: rem ** movement
49999 rem ** save character routine
50000 print "{clear}do you wish to save ";j$;" ?"
50010 print:print"please key y or n"
50020 vg$="yn":gosub1500:rem ** uniget
50030 if gc$="n" then 50210
50040 print "{clear}place data disk in the drive"
50050 print "is the lid closed ?"
50060 gosub 1600: rem ** anykey
50070 open 8,8,8,"@0:"+j$+",w,s"
50080 print#8,p$
50090 print#8,ts
50100 print#8,ex
50110 print#8,tn
50120 print#8,cs
50130 print#8,ps
50140 print#8,t(0)
50150 print#8,t(1)
50160 print#8,t(2)
50170 print#8,c1
50180 print#8,p1
50190 close 8
50200 print"{clear}{down*3}"," *** done ***"
50210 print d$;"{space*6}type run to start again"
50220 clr
50230 end
54999 rem ** death routine
55000 c=0:cs=0:ps=0:cf=0
55010 df=110:gosub36000:rem ** delay + update
55020 if t(1)=6 then 55070
55030 print d$,"{right}oh what a frail shell"
55040 print,"{right*2}is this that we call man"
55050 df=300:dl$="w":gosub36000: rem ** delay + wipe
55060 print"{clear}":goto50210
55070 t(0)=0:t(1)=0:ts=0:cs=30:c=150:ps=30
55080 print d$;"alarian's amulet protects thy soul"
55090 print "{down}{reverse on}{space*2}live again{space*2}{reverse off}"
55100 print df=150:gosub 36000: rem ** delay + update
55110 l=g(0):mp=l:m=w:s=1:goto 9220: rem ** scene control
59999 rem ** data for castle type scenarios
60000 data 4,7,3,6,4,4,6,5,3,6,0,3,8,4,3,5,5,5,8,3,4,5,0,6,3,6,4,6,4,7,4,100
60009 rem ** data for monsters
60010 data awolfen,9,0,ahob-goblin,9,0,aorc,9,0,efire-imp,7,3,grock-troll,19,0
60020 data eharpy,10,12,aogre,23,0,bbarrow-wigth,0,25,hcentaur,18,14
60030 data efire-giant,26,20,vthunder-lizard,50,0,cminotaur,35,25,cwraith,0,30
60040 data fwyvern,36,12,bdragon,50,20,cring-wraith,0,45,abalrog,50,50
60049 rem ** special monsters for water only
60050 data lwater-imp,15,15,lkraken,50,0