pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- my own image format
-- by afunai

str = [[045679=?ぬのはひふへほみ

0481;K1o=113=111=6122112228>
0381;>11;:1q=217=612=111218>
028191;:11;113;91r=41<=112918>
83;:16;411;21t22=21<=111218?
82;;16;114;11u23=31<218?
;<1▒=123=419=2<18?
;;1🐱=122=712=213=111;18?
;;1▒=321=433=515;18>
;:1⬇️==31=314;18=
;919=21y=732=912?111;18<
;919=31W=21J=213=233=232=631=111?112?111;18;
;81;=21T=51I=315=432=231=231=311?112?112<18:
;81a=51Q;1==11?3159189
;71b=61S;112=312=112?513?11189
;61D;71H=51<?11C?215;413?711?31188
;51@;122<488<1;11C=518?212?31A?3=23161=212?113=411?113?21187
;211;21<;111=12111=721;1<187<1;11A=21:?71B?1=13165=466=214?111;186
1>2311=8>1=271=111;3<191<183<1;11@=11:?211?413=418?113=162:367:264=114?111;185
1=22=5>1=3>272=371=112=121;1<283;11>=319?8=235=215?211=13161:261:162:162:5216317;184
1:=41121;1=8>273>1=1>171=17131=111;1<282;11;=331=219=633=434=2?112?11131693462:362=117;18291
19=5219111=7?1=1>171>872=121;2<3;119=1367331713A=432=1143163314275427163:16231189181<1
1:21=411=612=2?112>6?1=172=121;1=12191<117=232=43J=23321819164314275>462216231=111?1169181
162111;1<19121=171>1=811=1>2=271>4=372>1=222<2;115=132=33N=332=121<163=13171>9=166=316<1
14;581<1;1=271>1=613>372>3=111=2>3=421<19114=132=23S=232=1213162=171>:=168=116
13;4<1;121=6>6=3>173=2>1=5>3=231=221<1918191=132=23772>2=1>173>3733?=23363=172>871413167=1?115
12;181<4=:>674=114=2>4=6228191=13;72=1?112=171>1=1?4>2=23?=23362=171>4763164:16131=1?115
;281<3;111=2>2=8>373=116=1>4=721<181=13;71>1=2?3=2?1=3?3>2=23?=23361=2>27231=66631=1?214
8291;312=8>672=212=1>5=1>2=8;1<1213;71>1=111=1?412=2>1=1?5=13A=132=121=56<31=1?512
82<1;211=812=3>371=212=1>2=5>1=8233;71>1=111?612?2=171?3=1113F=26?31=1?711
82;2=611=413=2>311=2>1=2?2=3>4=621<1=13;71=2?2=1>1=1?5=4>271?1=1713F642664312112?611
;41121=6>1=215=311=1>7=111=3>1=171=321<23<>1=2?2=3?5=3?1=1>1=1?1=1>1733B<18<21619181;111?7
;313=71;=9>2=111=1>171=3<2213;71=271?9>1=2?3=114?2=1713A=18>0281;111?6
;2<121=371=912=217=;31=221<181213:71=371>1?4=1?812=111?111?3>13?=132<18:91810481;111?5
23=1;121=431=612=417=;2282=13874=272=1?812=511?111?4=2713?218;068112?4
22=:32=313=419=721<1810181=13873>1=3>1=1?1=1?3=1?113?1=5?5>1?2=23<=131=18;0285;311;111
;221=131=634=115=>>1=321<1810281=13871>171>112=3?211?2=113=1?2=4?4>6713;=132830489;8
22=612=134=212=611=612=322<1810381=13873=212=1>1?216?1=2?1=1?1=2?3=1>1?1=1>1743=<1820584;<
=4;121=633=412=411=213=112=2228205213873>2=112=2?111?111?212=2?112=1?3=6>1753;21810582;?
;2<2;121=734=2;112=9>1=121=121918206<138=174=2;2?311?3=211=1?113?1=3?111=3?1=4>1713:21820382;@
82<281;122=733=:71>1=221=12184068138=27414?111?3=1?1=113?311?111?219=13;21810283;;9284
;28291<1822112=773=411=421<28408812137=471=3>113?216?2=411?1=215;111=13<<18491;88:
12;184<2=312=;;121=121<1850:8237=172=312=111;119?2=4?3>1=114;111=23;85;6918<
14;182<18222;12213=11121;1<321<18202820<82213573=172=112=111;215=2?111?2=1>1=1?5=171=111;112=13:=184;6918=
148;<18192<1860C83=1347813;181;114?6=1>2?5=172=43;2184;7918<
1484018;0I810181213573=412;19181;211?3=1?4>3?5=174=13<<18391;6928<
14830Y812133=111=3;184<1;411?6=273=1?3=2763:=184;6928=
14830Z81=133=121;2<19184;111=112?4>1=176?2=4753:<18391;D91
14820\81=134=121;483;111=1?5>275>2?2=3>17538218491;71;;3
14820\82=136=411;1=2>3?4>175>1=1?111=27737218591;413=;12;1
14;2810681912<<1810G812139=271>172>1=1?3=1>1=271>1=1?4=1>37436218691;313=<12=1
14;281038121=B210F81<138=6>171>1=1?1=712?1=373>1=13621879114=@71
14;2822131=E31=1<1860>82=137=12111=316=512=835=1<188911171=?71>1=171
15=231=I31=121840@81<1=136=121;3<1;491819111=216=334=1218;2174=;73>171
12=Q31=18404840981<1=134=131=924=83421918=<174>2=:71>171>1
=231=Q32=18:0;8221=13I=1218=018291=176>1=973
=V31=1890=8291=132=425=335=221<182038:028221=1>174>6=1>2=371
==31=139=534=631=1890=81=42==231=18308870481<111=1>273>374>171>1=2
=:3D7234=431=191880:81<1=32B=2820985068121=2>273>9=2
=73;77327239=331=189088121=22E=2218108840781<1=6>271>272>4=1
=43<723179327534=3312189068121=22H=2810684088191=1>1=7>7=2
=33=7A37=3319189048121=22J=28104830;81<1>2=412=3>4=2
3;71337?4238=331=18:0321=22L=28102840;8211>2=>
3:7:3171327938=331<18;91=22N=201840<82<1=1>1=>
387;3271337838=331218;21=12P=121840=8221=1>1==
367=327=38=48:<1=22Q3121830>8221>2=<
367J3;=231<18921=12=6226622;=2820?83=1>1=<
72347:317>3471317135=231=189=2266122=3226121=322632;=121810@82<1=1>1=;
73337=317;367136=131=188<1=2256222=522=521=16329=2810A82<1=<
377L327136=231918721=2236422=522=621=16329=1<10B82<1=;
3471327A>17;317136=1322187=2246422=522=862=16128=20A84<1=971
3373347:327C34=131218691=2236521<1=411<121=3>1=66327=131810@85<1=2>1=4>171
3472347;3176317:36=1312186<1=22361=163<221=4<221=2>3=321=16227=131910A85<1=1>2=111?1=1>1
3471357B317<36=186<1=22261=1?1=321<18121=321<2=921=1612831210?820185<1=1>2=2>2
3:7C317=34=186<1=6?352;181<1=4<18121=9216128=1210@889121=1>4
72377E317<34=18591<1=6?3521181<121=3218121=92:=1210=82028921=1>3
72387E317:35=183<193=6?151?251?1;181;1=4<221=5>1=221<128=1210>820289<1=1>1=1
72387P35=18491<2=61151?25211;1<111=321<1;1=5>2=121<128=1210B8;21=1
72377P31713421859221=5?552;1<1;1=421<121=62:=131210C8;91
72377E317<34218491<3=5?65111;211=321<221=5<121<127=13121810C8;
73387A327=34=18392<281=5?811;2=42181<125<228=131<1810A810389
73387A3171317=33218293<281<1=4?9;1<121=31184<121<4216125=2820B8202830184
73387C3279317233<18391<382=4?911;211=32182<181<321<1216124=221830B8302820282
75377@317231753272317134<18491<1918221=4?911;1<12485<2226323=284068102840<8301
33723472317?3371317832=232=18692810181=4?:;1<586226323=8<18<0=82
32743172=17?3471337632=332218491<121<1810181<1=4?911;181<281<182;1<181<1216224=137=1850F
7A31773371337732=2332182<681028121=4?812;2<3;112;1<1226223=131=26122=321810I
7<>17<327;37=19185<191<18521=4?:14?151?1=16423=131=1<622=121820G
7H347:34=1322182<121=33221952131=3??=16423=321<191<291<123=2<1810<8208
79327=347;32=23223=136=18621=4?==26323=131=12:=321<1810=8107
73387?32733177=332=1<321=78721=131=3?911=523=322=226=521<10?830182
3<7>3479=23321829121=12688<1=132=311?212=:31=2<121=623=79101810981038401
3:7A317431713174=232=1<183<1=123<121=1219185018221=232=@21<221=623=721820>8301
3775327B3171317335=19183<1=121=2258:21=235=234=321<4=233=224=621<191810>83
3775327A347331=132=1<18423=7218;91<121=822<423=233=226=225<1810?81
36733171327B347331=132218392=;218304899384<122<121=821=124=62482048:
733371>173327I33=1218194=<<182028B<421=<22=833=1<18805
]]

function _draw()
 cls()
 for y,line in pairs(
  split(str,'\n',false)
 ) do
  local x=0
  for i=1,#line,2 do
   local p,len=ord(line,i,2)
   p-=0x30
   len-=0x30
   rectfill(x,y,x+len,y,p)
   x+=len
  end
 end
end
