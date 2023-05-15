breed[arbustos arbusto]
breed[zorros zorro]
breed[conejos conejo]
breed[esferas esfera]
breed[jefes jefe]
breed[balas bala]
breed[corazonzorros corazonzorro]
arbustos-own[velocidad]
conejos-own[velocidad]
esferas-own[velocidad]
jefes-own[velocidad]
globals[numarbustos cantconejos contesferas vidas vidasjefe  hordas Cg]

;-----------------INICIO----------------------------------------
to inicio ;Inicialización de variables
    ca
    set-default-shape balas "Cannon"
    pintarfondo
    set vidasjefe 9  ; comienza las vidas del conejo final en N°
    set contesferas 0
    set vidas 3 ; Inicia las vidas del zorro
    set hordas 0 ; Inicia un contador de cuantos conejos han muerto
    set Cg 0 ;Indica si el zorro se ha acercado al conejo grande
end


;-------------------FONDO--------------------------------------------------------------------
to pintarfondo ; Coloca el fondo verde inicia los agentes (los crea), y ubica los arbustos
  ca
  ask patches [set pcolor 65];
  ;import-drawing "pasto3.png"
  iniciaragentes
  ubicararbustos
end

;--------------------------CREACIÓN DE AGENTES------------------------------------------------
to iniciaragentes ;crea los agentes
  ;cantidades de las variables
  set numarbustos 6
  set cantconejos 5

  ;arbustos
  create-arbustos numarbustos
  [
    set shape "arbustoa2"
    set size 4.5
    set color 75
    set heading 0
    set Velocidad  0.003 / 4
  ]

  ;zorro
  create-zorros 1
  [
    set shape "zorro"
    set heading 0
    set size 5
    set color 25
    set ycor -14
  ]

  ;Conejos
  create-conejos  cantconejos
  [
    set shape "rabbit"
    set color white
    set size 3
    set heading 180
    set ycor 14
    set xcor random-xcor + who * 13
    ask conejos in-radius 0  [set  xcor random-xcor + who * 6 ]; Si hay otro conejo en la misma posición, lo cambia de coordenadas
    set Velocidad one-of [ 0.0008  0.0006  0.0005 ]  ;Velocidades que puede tomar el conejo
  ]

  ;Esferas
  create-esferas 2
  [
    set shape "esfera magica"
    set size 1.5
    set heading 180
    set ycor 14
    set xcor random-xcor + who * 5
    ask conejos in-radius 0 [set  xcor random-xcor + who * 6 ];si hay otra esfera en la misma posición, le cambia las coordenadas
    ask conejos in-radius 1 [set  xcor random-xcor + who * 6 ]
    set Velocidad one-of [ 0.0008 0.0009 0.0006  0.0005  ] ;Velocidades que puede tomar la esfera
  ]

   create-corazonzorros 3
   [
    set shape "corazon"
    set size 3
    set heading 0
    set ycor 15
    let w who
    set w (w - 1)
    set xcor (w - ( 2 * w))
  ]

end



; ---------------------------UBICAR ARBUSTOS----------------------------------
to ubicararbustos

  ask arbusto 0
  [
   set xcor -16
   set ycor 14
  ]
  ask arbusto 1
  [
   set xcor -16
   set ycor 8
  ]

  ask arbusto 2
  [
   set xcor -18
   set ycor 3
  ]
    ask arbusto 3
  [
   set xcor -15
   set ycor 0
  ]
     ask arbusto 4
  [
   set xcor -16
   set ycor -5
  ]
     ask arbusto 5
  [
   set xcor -16
   set ycor -10
  ]
end

; --------------------MOVIMIENTO DEL ZORRO CON EL TECLADO-------------------------------------------------
to Mover[Direccion]
  ask zorros
  [
   if(Direccion = "Derecha")
    [
    ifelse(xcor = 14) ; Si la pos en X es 15 fd 0 :no avance, es para que no se salga del recuadro
    [set heading 90 fd 0]
    [set heading 90 fd 2]
    ]

    if(Direccion = "Abajo")
    [
    ifelse(ycor = -14)
    [set heading 180 fd 0]
    [set heading 180 fd 2]
    ]

    if(Direccion = "Izquierda")
    [
    ifelse(xcor = -14)
    [set heading 270 fd 0]
    [set heading 270 fd 2]
    ]

    if(Direccion = "Arriba")
    [
    ifelse(ycor = 14)
    [set heading 0 fd 0]
    [set heading 0 fd 2]
    ]
  ]
end


;----------------------------EFECTO AVANZAR-------------------------------------------------------------
; Da la iliusión de que el personaje avanza por el campo de juego
to efectoavanzar
  moverarbustos
  moverconejos
  moverconejo-final
  moveresferas
  conteo
  masesferas
  masconejos
  if (vidas = 0) ; Si el Zorro tiene 0 vidas se Reinicia el juego
  [inicio]

end
;------------------------------------------------MOVIMIENTO DE LOS AGENTES-----------------------------------------------------------------------

;----------------------MOVIMIENTO DE LOS ARBUSTOS---------------------
to moverarbustos ; hace mover a los arbustos
  ask arbustos[
   bk velocidad
  ]
end

; ---------------------MOVIMIENTO DE LOS CONEJOS----------------------------------------------------------------
to moverconejos
  ifelse(hordas <= 50); si la cant de conejos que han pasado es menor o = 50 aparecen mas conejos
  [    ask conejos[
          fd  velocidad
          let numero count conejos with [  ycor <= -16 ] ;conteo de los conejos que llegaron al limite superior
          hatch numero [set xcor random-xcor + who * 14 set ycor 14  set Velocidad one-of [ 0.0008  0.0006  0.0005 0.0009  ]  ]; nacen "numero" conejos en la posicion inicial de Y y X random
          ask conejos with [  ycor <= -16 ][set hordas (hordas + numero ) die ] ;Los conejos que llegaron al limite superior de la pantalla mueren
       ]
  ]
  [
    ask conejos [die] ;De lo contrario los conejos mueren, para que dejen de aparecer más
    jefefinal; Llama a jefe final
  ]
end
;--------------------------GENERA VILLANO FINAL ------------------------------------
  to jefefinal
    if(hordas = 51)[ ; Si la cant de conejos que han pasado es = 51, se crea un conejo villano
       set hordas (hordas + 1) ; Incremente hordas en 1 para que no salgan infinitos conejos villano
       create-jefes 1[
         set shape "conejo malvado"
         set color gray
         set size 8
         set heading 180
         set ycor 14
         set velocidad one-of [ 0.0008  0.0006  0.0005 ]
       ]
     ]
end
;---------------------------------------MOVIMIENTO VILLANO --------------------------
to moverconejo-final
  ask jefes[
    fd  velocidad
    let numero count jefes with [  ycor = -15 ] ;conteo de los conejos que llegaron al limite superior
    hatch numero [set xcor random-xcor + who * 14 set ycor 14  set Velocidad one-of [ 0.0008  0.0006  0.0005  ]  ]; nacen "numero" conejos en la posicion inicial de Y y X random
    ask jefes with [  ycor = -16 ][die ] ;Los conejos que llegaron al limite superior de la pantalla mueren
  ]
end

; ---------------------MOVIMIENTO DE LAS ESFERAS------------------------------------------------------------------

to moveresferas
  ifelse(hordas <= 50); si la cant de conejos que han pasado es menor o = 50 aparecen mas esferas
  [
    ask esferas[
     fd  velocidad
     let numeroes count esferas with [  ycor >= 15 ];conteo de las esferas que llegaron al limite superior
     hatch numeroes [set xcor random-xcor + who * 5 set ycor 14 set Velocidad one-of [ 0.0009  0.0006  0.0005 0.0007] ]; nacen "numeroes" esferas en la posicion inicial de Y y X random
     ask esferas with [  ycor >= 15 ][die];Las esferas que llegaron al limite superior de la pantalla mueren
    ]
  ]
  [
    ask esferas [die] ;De lo contrario las esferas mueren, para que dejen de aparecer más
  ]
end

;---------------------MOVIMIENTO DEL CONEJO VILLANO-------------------------------------------------
to jefeinicio
   every 2.5;Cada 2.5 segundos
    [
     ask jefes[fd 5  left random 270  ];se mueve 5 pasos hacia adelante en una dirección random
    ]
end

;---------------------CONTADOR DE ESFERAS Y VIDAS------------------------------------

to conteo  ; RECOLECTAR ESFERAS
  ;El contador de esferas aumenta en 1 y la esfera muere al ser tocada por el zorro
  ; Que solo recoja la misma cant de balas que el doble de vidas del conejo villano y una mas. Si ya obtiene las 19 no recoje las demas
  ;ask zorros [ ask esferas in-radius 0 [ if(contesferas <= 18) [set contesferas  contesferas + 1 ] ] ask esferas in-radius 0 [die]]
  ;ask zorros [ ask esferas in-radius 1 [ if(contesferas <= 18) [set contesferas  contesferas + 1 ] ] ask esferas in-radius 1 [die]]
  ask zorros [ ask esferas in-radius 2 [ if(contesferas <= 18) [set contesferas  contesferas + 1 ] ] ask esferas in-radius 2 [die]]

  ; PERDER VIDAS ZORRO
  ;Al tocar un Conejo este muere y disminuyen las vidas del zorro
  ;ask zorros [ ask conejos in-radius 0 [ Muere-Zorro ] ask conejos in-radius 0 [die]]
  ;ask zorros [ ask conejos in-radius 1 [ Muere-Zorro ] ask conejos in-radius 1 [die]]
  ask zorros [ ask conejos in-radius 2 [ Muere-Zorro ] ask conejos in-radius 2 [die]]

 ;PERDER VIDAS CONEJO VILLANO
  ;ask jefes [ ask balas in-radius 0 [ Muere-jefe ] ask balas in-radius 0 [die]]
  ;ask jefes [ ask balas in-radius 1 [ Muere-jefe ] ask balas in-radius 1 [die]]
  ask jefes [ ask balas in-radius 2 [ Muere-jefe ] ask balas in-radius 2 [die]]

  ;PERDER VIDAS ZORRO CON CONEJO VILLANO
  ;Si un zorro toca un Conejo grande disminuyen las vidas del zorro
  ;ask zorros [ ask jefes in-radius 0 [set Cg 1 Muere-Zorro ] ask jefes in-radius 0 [die]];El conejo grande muere y se inicializa Cg en 1
  ;ask zorros [ ask jefes in-radius 1 [set Cg 1 Muere-Zorro ] ask jefes in-radius 1 [die]];El indicador Cg me permite saber si el Zorro
  ;ask zorros [ ask jefes in-radius 2 [set Cg 1 Muere-Zorro ] ask jefes in-radius 2 [die]];ha tocado al conejo grande
  ask zorros [ ask jefes in-radius 3 [set Cg 1 Muere-Zorro ] ask jefes in-radius 3 [die]]
end

;--------------------DISMINUCIÓN DE VIDAS DEL ZORRO-------------------------------
to Muere-Zorro
   ask zorros[ set vidas (vidas - 1);Disminuye en 1 las vidas del zorro
      if(vidas = 2)[
         ask corazonzorro 14 [die]] ;Cada vez que pierde una vida, desaparece un corazón de la pantalla
      if(vidas = 1)[
        ask corazonzorro 15 [die]]
      if(vidas = 0)[
        ask corazonzorro 16 [die]
        user-message "¡El zorro ha muerto!\n¡PERDISTE!"
      die]
   ]

  if (Cg = 1) ; Si el Indicador de conejo grande (Cg) es 1
  [hatch 1[ ;Se crea un nuevo conejo grande
         set shape "conejo malvado"
         set color gray
         set size 8
         set heading 180
         set ycor 14
         set velocidad one-of [ 0.0008  0.0006  0.0005 ]
  ]set Cg 0];Se cambia el indicador a 0

end

;-------------AGREGAR ESFERAS ---------------------------------------------------

to masesferas
  ;Al recolectar esferas estas mueren y deben nacer unas nuevas
  ask esferas[
      fd  velocidad
      let num-es count esferas ;Conteo del total de esferas
      if( num-es = 1 ) ; Al desaparecer una esfera
        [hatch 1 [set xcor random-xcor + who * 5 set ycor 14  ]]; Nace una esfera en la posicion inicial de Y y X random
      if ( num-es = 0 ) ; Al desaparecer todas las esferas
        [hatch 2 [set xcor random-xcor + who * 5 set ycor 14  ]]; Nacen dos esferas en la posicion inicial de Y y X random
  ]

end

; _-----------------AGREGAR CONEJOS ------------------------------------------
to masconejos
  ;Si el zorro toca los conejos estos mueren y deben nacer unos nuevos
  ask conejos [
      fd  velocidad
      let num count conejos ; conteo de conejos en total
      if(num < 5) ; Al desaparecer uno o mas conejos
        [hatch (5 - num)  [set xcor random-xcor + who * 14 set ycor 14 set Velocidad one-of [ 0.0008  0.0006  0.0005 ] ]]; nacen "numero" conejos en la posicion inicial de Y y X random
  ]
end


;--------------------------MUERTE DEL VILLANO------------------------------------------
to Muere-jefe
 ask jefes[ set vidasjefe (vidasjefe - 1); Disminuye en 1 las vidas del villano
     if (vidasjefe = 0) ;Si las vidas llegan a 0 el Zorro gana
       [ user-message "¡GANASTE!"
         die]
 ]
end

;--------------------------ATAQUE-------------------------------------------------------
;solo sirve para atacar al conejo villano, las balas no les hacen nada a los pequeños

to Play
  ask Balas
  [
    fd 0.01
    if(xcor >= 16 or xcor <= -16 or ycor >= 16 or ycor <= -16)
    [Die]
  ]

end

;------------- ----------DISPARAR BALAS---------------

to ataquezorroarriba

  set  contesferas (contesferas - 1) ;Disminuye en 1 las esferas recogidas
  ifelse (contesferas > 0) ;Si tiene esferas
    [ ask zorros[ hatch-Balas 1 [ set heading 0 set size 2  set color red ]] ]; Se genera una bala
    [ if(vidasjefe > 0 )  ; Si usa todas sus balas y el Conejo jefe no ha muerto
         [ ask zorros [die] user-message "¡No tienes balas!\n¡PERDISTE!"  inicio ];El zorro pierde
    ]

end

to ataquederecha
   set  contesferas (contesferas - 1) ;Disminuye en 1 las esferas recogidas
  ifelse (contesferas > 0) ;Si tiene esferas
    [ ask zorros[ hatch-Balas 1 [ set heading 90 set size 2  set color red ]] ]; Se genera una bala
    [ if(vidasjefe > 0 )  ; Si usa todas sus balas y el Conejo jefe no ha muerto
         [ ask zorros [die] user-message "¡No tienes balas!\n¡PERDISTE!"  inicio ];El zorro pierde
    ]
end



to ataqueizquierda
   set  contesferas (contesferas - 1) ;Disminuye en 1 las esferas recogidas
  ifelse (contesferas > 0) ;Si tiene esferas
    [ ask zorros[ hatch-Balas 1 [ set heading 270 set size 2  set color red ]] ]; Se genera una bala
    [ if(vidasjefe > 0 )  ; Si usa todas sus balas y el Conejo jefe no ha muerto
         [ ask zorros [die] user-message "¡No tienes balas!\n¡PERDISTE!"  inicio ];El zorro pierde
    ]
end

to ataqueabajo
   set  contesferas (contesferas - 1) ;Disminuye en 1 las esferas recogidas
  ifelse (contesferas > 0) ;Si tiene esferas
    [ ask zorros[ hatch-Balas 1 [ set heading 180 set size 2  set color red ]] ]; Se genera una bala
    [ if(vidasjefe > 0 )  ; Si usa todas sus balas y el Conejo jefe no ha muerto
         [ ask zorros [die] user-message "¡No tienes balas!\n¡PERDISTE!"  inicio ];El zorro pierde
    ]
end
@#$#@#$#@
GRAPHICS-WINDOW
238
20
675
458
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
114
434
179
467
Arriba
Mover\"Arriba\"
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
113
469
177
502
Abajo
Mover\"Abajo\"
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
180
469
258
502
Derecha
Mover\"Derecha\"
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
29
469
112
502
Izquierda
Mover\"Izquierda\"
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
691
433
764
466
Atq. Arriba
ataquezorroarriba
NIL
1
T
OBSERVER
NIL
O
NIL
NIL
1

BUTTON
122
123
189
156
Play
play
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
23
124
118
157
Avanzar
efectoavanzar
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
22
23
102
68
Vidas
vidas
17
1
11

MONITOR
111
24
191
69
Vidas Villano
vidasjefe
17
1
11

MONITOR
23
74
102
119
Hordas
hordas
17
1
11

MONITOR
110
75
192
120
Esferas Mágicas 
contesferas
17
1
11

BUTTON
23
160
86
193
Inicio
inicio
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
92
162
189
195
Conejo final
jefeinicio
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
766
469
853
502
Atq. Derecha
ataquederecha
NIL
1
T
OBSERVER
NIL
Ñ
NIL
NIL
1

BUTTON
601
469
690
502
Atq. Izquierda
ataqueizquierda
NIL
1
T
OBSERVER
NIL
K
NIL
NIL
1

BUTTON
692
469
764
502
Atq. Abajo
ataqueabajo
NIL
1
T
OBSERVER
NIL
L
NIL
NIL
1

TEXTBOX
720
53
888
389
            Finalidad                       Nuestro protagonista es el zorro que se encuentra en la parte inferior. Su misión es poner fin al mal causado por el terrible Señor Conejo, quien ha masacrado a los habitantes de Rose, el lugar de origen de nuestro personaje. El zorro posee habilidades mágicas y es un poderoso hechicero capaz de recolectar esferas de poder y convertirlas en balas para derrotar al villano conejo.\n\nDurante su travesía, el zorro deberá esquivar a los pequeños conejos enemigos, recolectar las esferas y evitar los ataques mientras se prepara para atacar al Señor Conejo y lograr la victoria.\n\nNota: Para iniciar el juego se deben activar los botones Avanzar, Play y Conejo final
11
0.0
1

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arbustoa2
true
0
Rectangle -14835848 true false 90 30 225 45
Rectangle -14835848 true false 60 45 240 75
Rectangle -14835848 true false 45 75 270 105
Rectangle -14835848 true false 15 105 285 135
Rectangle -14835848 true false 0 135 300 150
Rectangle -14835848 true false 15 150 285 180
Rectangle -14835848 true false 30 180 270 210
Rectangle -14835848 true false 75 210 105 225
Rectangle -14835848 true false 165 210 240 225
Rectangle -14835848 false false 30 195 45 195
Rectangle -14835848 false false 45 210 30 195
Rectangle -10899396 true false 90 30 225 45
Rectangle -10899396 true false 60 45 90 60
Rectangle -10899396 true false 60 60 75 75
Rectangle -10899396 true false 45 75 60 105
Rectangle -10899396 true false 15 105 60 120
Rectangle -10899396 true false 15 105 30 150
Rectangle -10899396 true false 0 135 30 150
Rectangle -10899396 true false 15 165 60 180
Rectangle -10899396 true false 75 90 120 105
Rectangle -10899396 true false 60 105 105 120
Rectangle -10899396 true false 135 75 195 90
Rectangle -10899396 true false 195 60 240 75
Rectangle -10899396 true false 150 135 210 150
Rectangle -10899396 true false 60 150 120 165
Rectangle -13791810 true false 240 195 270 210
Rectangle -13791810 true false 255 165 285 180
Rectangle -13791810 true false 270 135 315 150
Rectangle -13791810 true false 270 150 285 180
Rectangle -13791810 true false 255 165 270 210
Rectangle -13791810 true false 225 210 240 225
Rectangle -13791810 true false 165 210 225 225
Rectangle -13791810 true false 210 180 240 195
Rectangle -13791810 true false 255 120 270 135
Rectangle -6459832 true false 135 210 165 315
Rectangle -6459832 true false 150 210 165 315
Rectangle -6459832 true false 75 120 105 135
Rectangle -6459832 true false 105 135 120 150
Rectangle -6459832 true false 120 150 135 180
Rectangle -6459832 true false 135 180 150 210
Rectangle -10899396 true false 120 180 195 195
Rectangle -10899396 true false 90 165 135 180
Rectangle -14835848 true false 135 195 150 210
Rectangle -6459832 true false 240 105 225 135
Rectangle -6459832 true false 240 120 255 165
Rectangle -6459832 true false 210 150 240 165
Rectangle -6459832 true false 195 165 210 180
Rectangle -6459832 true false 180 180 195 195
Rectangle -6459832 true false 150 195 180 210
Rectangle -13791810 true false 60 195 90 210
Rectangle -13791810 true false 75 210 105 225
Rectangle -13791810 true false 105 195 150 210
Rectangle -13791810 true false 120 210 150 225
Rectangle -13791810 true false 150 210 165 225
Rectangle -13791810 true false 150 225 195 240
Rectangle -6459832 true false 195 75 210 90
Rectangle -6459832 true false 180 90 195 105
Rectangle -6459832 true false 165 105 180 120
Rectangle -14835848 true false 165 105 180 120

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

cannon
true
0
Polygon -7500403 true true 165 0 165 15 180 150 195 165 195 180 180 195 165 225 135 225 120 195 105 180 105 165 120 150 135 15 135 0
Line -16777216 false 120 150 180 150
Line -16777216 false 120 195 180 195
Line -16777216 false 165 15 135 15
Polygon -16777216 false false 165 0 135 0 135 15 120 150 105 165 105 180 120 195 135 225 165 225 180 195 195 180 195 165 180 150 165 15

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

conejo malvado
false
15
Polygon -1 true true 105 180 105 180 135 165 150 165 180 180 195 225 180 210 180 255 165 285 150 255 135 255 135 255 120 285 105 255 105 180 90 225 105 210 105 255 105 240 105 240
Polygon -7500403 true false 120 195 120 195 120 240 165 240 165 195 180 180 165 165 120 165 105 180
Circle -7500403 false false 90 225 30
Rectangle -7500403 true false 90 105 90 135
Polygon -7500403 true false 135 165 135 165 120 180 135 180 135 165 135 180 120 180 120 180 120 180
Rectangle -7500403 true false 135 165 135 180
Line -7500403 false 150 165 165 180
Polygon -7500403 true false 135 165 120 180 165 180 150 165 135 165 150 165 150 165 135 165 120 180 165 180 150 165 135 180 150 165 135 165 150 165
Rectangle -955883 true false 105 225 120 240
Polygon -955883 true false 75 120 75 120 75 120
Polygon -955883 true false 45 105
Polygon -955883 true false 105 240 105 255 180 255 180 240 105 240
Rectangle -955883 true false 135 150 150 165
Polygon -6459832 true false 120 270
Polygon -6459832 true false 120 270 120 270 120 285 120 270 120 270
Rectangle -16777216 true false 135 105 135 120
Rectangle -1 true true 120 195 165 195
Rectangle -1 true true 120 195 165 195
Rectangle -955883 true false 180 135 180 150
Polygon -2064490 true false 105 75 105 75 120 75 120 75 105 75
Polygon -8630108 true false 105 75
Rectangle -8630108 true false 90 75 75 90
Rectangle -8630108 true false 75 60 90 60
Rectangle -8630108 true false 75 45 75 60
Rectangle -8630108 true false 90 45 90 60
Rectangle -8630108 true false 60 30 75 30
Rectangle -8630108 true false 210 75 225 75
Polygon -8630108 true false 90 90 90 90
Polygon -8630108 true false 90 105 90 105
Polygon -8630108 true false 90 90
Rectangle -955883 true false 105 90 135 90
Rectangle -8630108 true false 90 75 210 75
Rectangle -8630108 true false 90 45 90 60
Rectangle -8630108 true false 60 30 90 30
Rectangle -8630108 true false 45 30 90 30
Circle -5825686 true false 150 60 0
Circle -13345367 true false 135 150 0
Polygon -13345367 true false 120 195
Polygon -2674135 true false 120 90
Polygon -2674135 true false 120 90
Polygon -1 true true 150 75 180 45 225 45 240 60 240 75 210 75 195 60 165 75
Rectangle -1 true true 120 150 165 165
Polygon -1 true true 135 75 105 45 60 45 45 60 45 75 75 75 90 60 120 75
Circle -1 true true 90 225 30
Polygon -2064490 true false 120 75
Polygon -2064490 true false 120 75 120 75 105 60 90 60 120 75
Polygon -2064490 true false 165 75 180 60 195 60 165 75
Polygon -16777216 true false 120 180 120 180 135 210
Polygon -16777216 true false 120 165 135 195
Polygon -16777216 true false 120 180 120 180 135 195 150 210 150 210
Polygon -16777216 true false 120 180 120 180
Circle -16777216 true false 135 180 0
Polygon -16777216 true false 0 300 15 270
Polygon -16777216 true false 120 240
Polygon -7500403 true false 30 240
Polygon -7500403 true false 150 135
Polygon -7500403 true false 135 165 135 165 120 165 120 165
Line -7500403 false 120 165 105 180
Line -7500403 false 105 180 105 180
Line -7500403 false 105 180 90 210
Line -7500403 false 120 225 120 225
Line -7500403 false 165 165 180 180
Line -7500403 false 180 180 180 180
Line -7500403 false 180 210 180 240
Line -7500403 false 180 210 195 210
Line -7500403 false 195 210 180 180
Polygon -7500403 false false 180 210 180 210 180 195 180 210 180 210
Polygon -7500403 false false 105 210 105 210 105 195
Polygon -7500403 false false 105 210 105 210 90 210
Polygon -7500403 false false 120 180 150 195
Polygon -16777216 true false 165 165 180 180 195 210 195 210 180 210 180 240 180 240 165 240 150 210 165 165
Polygon -16777216 true false 120 165 105 180 90 210 90 210 105 210 105 240 105 240 120 240 135 210 120 165
Polygon -13791810 true false 150 165 165 180 135 165 120 180 150 165
Rectangle -13345367 true false 135 165 150 180
Polygon -7500403 false false 105 210 105 270 135 270 135 255 150 255 150 270 180 270 180 270 180 240 105 240
Polygon -16777216 true false 105 240 105 240 180 240 180 255 180 255 180 270 150 270 150 255 135 255 135 270 105 270 105 270
Polygon -7500403 false false 150 135 180 135 135 135 120 135 120 135
Polygon -1 true true 90 135 90 135 120 165 165 165 180 150
Polygon -1 true true 90 105 120 75 165 75 165 75 165 75 195 105 195 135 180 150 105 150 90 135 90 90
Rectangle -2674135 true false 120 105 135 120
Rectangle -2674135 true false 150 105 165 120
Polygon -7500403 true false 105 240 105 270
Polygon -7500403 false false 105 240 105 240 105 270
Polygon -7500403 false false 105 240 180 240
Rectangle -16777216 true false 135 135 150 150
Polygon -1 false true 120 165 120 165 105 180 105 180 90 210 105 210 105 240 180 240 180 240 180 210 195 210 180 180 165 165 120 165 120 165
Polygon -1 false true 120 240 120 240 135 210 120 165 165 165 150 210 165 240

corazon
true
0
Rectangle -2674135 true false 150 120 165 135
Rectangle -2674135 true false 165 105 180 120
Rectangle -2674135 true false 180 90 195 105
Rectangle -2674135 true false 135 120 150 135
Rectangle -2674135 true false 120 105 135 120
Rectangle -2674135 true false 105 90 120 105
Rectangle -2674135 true false 195 75 210 90
Rectangle -2674135 true false 90 75 105 90
Rectangle -2674135 true false 210 75 225 90
Rectangle -2674135 true false 60 75 90 90
Rectangle -2674135 true false 225 75 240 90
Rectangle -2674135 true false 240 75 255 180
Rectangle -2674135 true false 45 75 60 180
Rectangle -2674135 true false 60 135 240 180
Rectangle -2674135 true false 60 90 120 150
Rectangle -2674135 true false 180 90 240 135
Rectangle -2674135 true false 105 135 195 120
Rectangle -2674135 true false 120 120 180 135
Rectangle -2674135 true false 60 180 240 195
Rectangle -2674135 true false 75 195 225 210
Rectangle -2674135 true false 90 210 210 225
Rectangle -2674135 true false 105 225 195 240
Rectangle -2674135 true false 120 240 180 255
Rectangle -2674135 true false 135 255 165 270
Rectangle -2674135 true false 30 90 45 165
Rectangle -2674135 true false 15 105 30 150
Rectangle -2674135 true false 255 90 270 165
Rectangle -2674135 true false 270 105 285 150
Rectangle -2674135 true false 210 60 240 75
Rectangle -2674135 true false 60 60 90 75
Rectangle -2674135 true false 30 75 45 105
Rectangle -2674135 true false 15 90 30 105
Rectangle -2674135 true false 270 90 285 105
Rectangle -2674135 true false 255 75 270 90
Rectangle -2674135 true false 240 60 255 75
Rectangle -2674135 true false 45 60 60 75
Rectangle -2674135 true false 180 75 195 90
Rectangle -2674135 true false 105 75 120 90
Rectangle -2674135 true false 121 89 131 115
Rectangle -2674135 true false 116 82 127 107
Rectangle -2674135 true false 130 95 135 111
Rectangle -2674135 true false 135 103 140 121
Rectangle -2674135 true false 139 113 145 121
Rectangle -2674135 true false 156 112 166 123
Rectangle -2674135 true false 163 99 175 114
Rectangle -2674135 true false 170 90 186 109
Rectangle -2674135 true false 176 80 183 105
Rectangle -2674135 true false 186 68 220 79
Rectangle -2674135 true false 193 62 212 70
Rectangle -2674135 true false 83 68 115 77
Rectangle -2674135 true false 81 63 108 70
Rectangle -2674135 true false 20 83 31 96
Rectangle -2674135 true false 37 65 46 78
Rectangle -2674135 true false 253 65 264 79
Rectangle -2674135 true false 270 78 280 97
Rectangle -2674135 true false 10 100 16 141
Rectangle -2674135 true false 283 98 290 145
Rectangle -1 true false 47 67 58 78
Rectangle -1 true false 38 79 49 88
Rectangle -1 true false 30 87 35 92
Rectangle -1 true false 22 91 32 101
Rectangle -1 true false 16 101 20 105
Rectangle -1 true false 17 101 24 112
Rectangle -1 true false 13 110 21 137
Rectangle -1 true false 161 113 167 119
Rectangle -1 true false 166 106 173 113
Rectangle -1 true false 172 100 176 106
Rectangle -1 true false 174 91 183 102
Rectangle -1 true false 183 81 192 91
Rectangle -1 true false 192 71 203 81
Rectangle -1 true false 200 65 212 72
Rectangle -1 true false 207 66 223 69
Rectangle -1 true false 55 65 70 69
Rectangle -16777216 true false 289 108 294 152
Rectangle -16777216 true false 285 144 292 152
Rectangle -16777216 true false 270 151 284 166
Rectangle -16777216 true false 255 166 270 181
Rectangle -16777216 true false 240 180 254 196
Rectangle -16777216 true false 226 195 241 212
Rectangle -16777216 true false 209 211 224 227
Rectangle -16777216 true false 194 223 210 240
Rectangle -16777216 true false 182 240 197 255
Rectangle -16777216 true false 167 258 180 271
Rectangle -16777216 true false 164 254 182 271
Rectangle -16777216 true false 150 270 166 286
Rectangle -1 true false 120 75 120 75
Rectangle -1 true false 105 60 120 60
Rectangle -1 true false 120 75 135 75

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

esfera magica
false
0
Rectangle -13345367 true false 195 30 210 45
Rectangle -11221820 true false 240 90 270 105
Rectangle -11221820 true false 30 90 60 105
Polygon -11221820 true false 45 60 45 135 45 135 75 180 75 180 105 210 195 210 195 210 225 180 255 165 255 75 240 75 240 60 225 60 45 60
Polygon -13791810 true false 30 90 45 105 45 135 75 180 105 210 195 210 210 195 225 180 255 135 255 105 270 90 270 240 255 240 255 255 240 255 240 270 225 270 225 285 75 285 75 270 60 270 60 270 60 255 45 255 45 240 30 240 30 105 30 90 30 90
Rectangle -13345367 true false 15 105 30 120
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 135 15 150 30
Rectangle -13345367 true false 90 15 105 30
Rectangle -13345367 true false 120 15 135 30
Rectangle -13345367 true false 105 15 120 30
Rectangle -13345367 true false 30 60 45 75
Rectangle -13345367 true false 225 45 240 60
Rectangle -13345367 true false 210 30 225 45
Rectangle -13345367 true false 195 15 210 30
Rectangle -13345367 true false 180 15 195 30
Rectangle -13345367 true false 165 15 180 30
Rectangle -13345367 true false 75 30 90 45
Rectangle -13345367 true false 150 15 165 30
Rectangle -13345367 true false 15 90 30 105
Rectangle -13345367 true false 30 240 45 255
Rectangle -13345367 true false 15 225 30 240
Rectangle -13345367 true false 15 210 30 225
Rectangle -13345367 true false 45 255 60 270
Rectangle -13345367 true false 60 270 75 285
Rectangle -13345367 true false 75 285 90 300
Rectangle -13345367 true false 75 15 90 30
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 60 30 75 45
Rectangle -13345367 true false 45 45 60 60
Rectangle -13345367 true false 15 105 30 120
Rectangle -13345367 true false 15 105 30 120
Rectangle -13345367 true false 15 120 30 135
Rectangle -13345367 true false 15 135 30 150
Rectangle -13345367 true false 15 135 30 150
Rectangle -13345367 true false 15 135 30 150
Rectangle -13345367 true false 15 150 30 165
Rectangle -13345367 true false 15 150 30 165
Rectangle -13345367 true false 15 165 30 180
Rectangle -13345367 true false 15 195 30 210
Rectangle -13345367 true false 15 180 30 195
Rectangle -13345367 true false 165 285 180 300
Rectangle -13345367 true false 150 285 165 300
Rectangle -13345367 true false 135 285 150 300
Rectangle -13345367 true false 105 285 120 300
Rectangle -13345367 true false 120 285 135 300
Rectangle -13345367 true false 165 285 180 300
Rectangle -13345367 true false 165 285 180 300
Rectangle -13345367 true false 90 285 105 300
Rectangle -13345367 true false 90 285 105 300
Rectangle -13345367 true false 90 285 105 300
Rectangle -13345367 true false 180 285 195 300
Rectangle -13345367 true false 180 285 195 300
Rectangle -13345367 true false 180 285 195 300
Rectangle -13345367 true false 195 285 210 300
Rectangle -13345367 true false 195 285 210 300
Rectangle -13345367 true false 270 150 285 165
Rectangle -13345367 true false 240 255 255 270
Rectangle -13345367 true false 225 270 240 285
Rectangle -13345367 true false 270 165 285 180
Rectangle -13345367 true false 270 180 285 195
Rectangle -13345367 true false 270 195 285 210
Rectangle -13345367 true false 270 210 285 225
Rectangle -13345367 true false 270 225 285 240
Rectangle -13345367 true false 255 240 270 255
Rectangle -13345367 true false 210 285 225 300
Rectangle -13345367 true false 270 105 285 120
Rectangle -13345367 true false 270 120 285 135
Rectangle -13345367 true false 270 135 285 150
Rectangle -13345367 true false 255 75 270 90
Rectangle -13345367 true false 270 90 285 105
Rectangle -13345367 true false 270 90 285 105
Rectangle -13345367 true false 240 60 255 75
Polygon -13791810 true false 60 195
Polygon -1 true false 75 60 75 60 225 60 60 60 60 45 60 45 75 45 90 30 195 30 210 45 225 45 225 60
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 75 120 90 135
Rectangle -1 true false 90 135 105 150
Rectangle -1 true false 60 135 75 150
Rectangle -1 true false 75 150 90 165
Rectangle -1 true false 105 195 120 210
Rectangle -1 true false 60 210 75 225
Polygon -13791810 true false 45 180
Rectangle -1 true false 60 225 75 240
Rectangle -1 true false 45 225 60 225
Polygon -1 true false 45 60 225 60
Polygon -1 true false 75 255 75 255 75 270 75 255 75 255 75 255 75 255 90 270 195 270 210 270 225 255 225 285 75 285 75 270
Rectangle -8630108 true false 60 45 75 60
Rectangle -8630108 true false 45 60 60 75
Rectangle -8630108 true false 240 75 255 90
Rectangle -8630108 true false 225 60 240 75
Rectangle -8630108 true false 210 45 225 60
Rectangle -8630108 true false 225 255 240 270
Rectangle -13345367 true false 15 75 30 90
Rectangle -8630108 true false 240 240 255 255
Rectangle -8630108 true false 45 240 60 255
Rectangle -8630108 true false 240 240 255 255
Rectangle -8630108 true false 240 240 255 255
Rectangle -8630108 true false 60 255 75 270
Rectangle -13791810 true false 30 105 30 105
Rectangle -8630108 true false 30 75 45 90
Rectangle -1 true false 240 165 255 180

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

zorro
false
0
Rectangle -8630108 true false 165 45 180 60
Polygon -13791810 true false 105 180 105 180 75 255 210 255 180 180
Line -13345367 false 180 180 210 255
Line -13345367 false 105 180 75 255
Line -13345367 false 75 255 210 255
Rectangle -7500403 true true 135 90 165 105
Rectangle -955883 true false 165 60 210 75
Rectangle -955883 true false 180 45 195 60
Rectangle -955883 true false 210 135 225 150
Rectangle -7500403 true true 195 90 210 135
Rectangle -7500403 true true 165 105 180 120
Rectangle -7500403 true true 180 120 195 135
Rectangle -7500403 true true 195 150 210 165
Rectangle -955883 true false 120 60 135 75
Rectangle -955883 true false 105 45 120 60
Rectangle -955883 true false 90 60 105 75
Rectangle -955883 true false 90 90 195 135
Rectangle -7500403 true true 90 105 90 135
Rectangle -7500403 true true 180 150 195 165
Polygon -7500403 true true 135 165 135 165 120 180 135 180 135 165 135 180 120 180 120 180 120 180
Rectangle -7500403 true true 135 165 135 180
Line -7500403 true 150 165 165 180
Polygon -7500403 true true 135 165 120 180 165 180 150 165 135 165 150 165 150 165 135 165 120 180 165 180 150 165 135 180 150 165 135 165 150 165
Rectangle -955883 true false 150 180 165 240
Rectangle -955883 true false 105 225 120 240
Polygon -955883 true false 75 120 75 120 75 120
Polygon -955883 true false 45 105
Polygon -955883 true false 105 240 105 255 180 255 180 240 105 240
Polygon -955883 true false 105 255 105 255 105 255 120 285 135 255 150 255 165 285 180 255
Polygon -955883 true false 105 180 135 165 150 165 180 180
Polygon -955883 true false 180 180 180 180 180 195 180 180 180 180 195 225 180 210
Polygon -955883 true false 90 225 105 180 105 210 90 225
Rectangle -955883 true false 105 180 180 240
Rectangle -955883 true false 105 105 180 150
Rectangle -955883 true false 135 150 150 165
Rectangle -955883 true false 180 90 210 165
Polygon -6459832 true false 120 270
Polygon -6459832 true false 120 270 120 270 120 285 120 270 120 270
Rectangle -16777216 true false 135 105 135 120
Rectangle -16777216 true false 135 105 150 120
Rectangle -16777216 true false 165 105 180 120
Rectangle -2064490 true false 105 60 120 75
Rectangle -955883 true false 180 60 195 75
Polygon -955883 true false 105 240 105 240 105 240 75 225 60 225 60 240 105 240
Polygon -1 true false 75 225 60 225 60 240 75 240 75 225
Rectangle -1 true false 135 180 150 240
Rectangle -1 true false 120 195 165 195
Rectangle -1 true false 120 195 165 195
Rectangle -1 true false 120 195 165 225
Polygon -1 true false 135 180 120 195 120 225 135 240 150 240 165 225 165 195 150 180
Rectangle -1 true false 165 135 225 150
Rectangle -16777216 true false 195 135 210 150
Rectangle -1 true false 180 150 210 165
Rectangle -955883 true false 165 150 180 165
Polygon -16777216 false false 105 180 135 165 135 150 105 150 105 135 90 135 90 75 90 60 105 45 120 45 120 60 135 60 135 90 165 90 165 60 180 60 180 45 195 45 195 60 210 60 210 60 210 135 225 135 225 150 210 150 210 165 165 165 165 150 150 150 150 165 180 180 195 225 180 210 180 255 165 285 150 255 135 255 120 285 105 255 105 210 90 225 105 180
Polygon -16777216 false false 105 240 75 225 60 225 60 240 75 240 105 240
Polygon -2064490 true false 105 75 105 75 120 75 120 75 105 75
Polygon -8630108 true false 105 75
Rectangle -8630108 true false 210 90 225 105
Rectangle -8630108 true false 60 90 90 105
Rectangle -8630108 true false 90 75 75 90
Rectangle -8630108 true false 75 60 90 90
Rectangle -8630108 true false 75 60 90 60
Rectangle -8630108 true false 75 45 75 60
Rectangle -8630108 true false 90 45 90 60
Rectangle -8630108 true false 60 30 75 30
Rectangle -8630108 true false 210 75 225 75
Polygon -8630108 true false 90 90 90 90
Polygon -8630108 true false 90 105 90 105
Polygon -8630108 true false 90 90
Rectangle -955883 true false 90 75 135 90
Rectangle -955883 true false 165 75 210 90
Rectangle -2064490 true false 180 60 195 75
Rectangle -955883 true false 105 90 135 90
Rectangle -8630108 true false 90 75 210 75
Rectangle -8630108 true false 90 75 225 90
Rectangle -8630108 true false 135 30 165 75
Rectangle -8630108 true false 90 45 90 60
Rectangle -8630108 true false 90 30 105 60
Rectangle -8630108 true false 105 30 135 45
Rectangle -8630108 true false 120 45 135 60
Rectangle -8630108 true false 60 30 90 30
Rectangle -8630108 true false 45 30 90 30
Rectangle -8630108 true false 60 30 90 45
Rectangle -16777216 true false 45 45 60 60
Line -2064490 false 90 45 135 45
Line -2064490 false 135 60 165 60
Line -5825686 false 90 90 210 90
Circle -5825686 true false 150 60 0
Line -5825686 false 90 105 60 105
Line -5825686 false 60 105 60 90
Line -5825686 false 60 90 75 90
Line -5825686 false 75 90 75 60
Line -5825686 false 90 60 75 60
Line -5825686 false 90 45 60 45
Line -5825686 false 60 45 60 30
Line -5825686 false 60 30 165 30
Line -5825686 false 165 45 165 30
Line -5825686 false 165 45 180 45
Line -5825686 false 210 75 225 75
Line -5825686 false 225 75 225 105
Line -5825686 false 225 105 210 105
Line -2064490 false 135 75 150 75
Line -13345367 false 135 165 150 165
Circle -13345367 true false 135 150 0
Polygon -13345367 true false 120 195
Polygon -13345367 true false 135 165 135 165 105 180 150 165
Line -16777216 false 105 60 105 45
Line -16777216 false 120 45 105 45
Line -16777216 false 90 60 90 60
Line -16777216 false 105 60 90 60
Line -16777216 false 135 75 135 75
Line -16777216 false 135 60 135 60
Line -16777216 false 135 75 135 75
Line -16777216 false 165 60 165 60
Line -16777216 false 180 60 180 60
Line -16777216 false 120 60 120 60
Line -16777216 false 180 60 180 60
Line -16777216 false 165 60 165 60
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
