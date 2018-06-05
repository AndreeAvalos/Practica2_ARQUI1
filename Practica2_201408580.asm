;-------------Area para macros----------------
imprimir macro mensaje
	push dx
	push ax
	
	lea dx,mensaje
	mov ah,09h
	int 21h
	mov ax,@data
	mov ds,ax
	mov es,ax
	
	pop ax
	pop dx
endm

Pintar_Pixel macro color, posX, posY

	push cx
	push dx
	mov ch, 0h
	mov cl, posX
	mov dh, 0h
	mov dl, posY
	mov ah, 0ch
	mov al, color
	int 10h
	
	pop dx
	pop cx
endm

esperarAccion macro
	imprimir msj_espera
	mov ah,10h  ;@@esperar tecla
	int 16h
endm


imprimirCaracter macro char
    PUSH AX;agregamos a pila ax
	MOV AL, char;movemos a al el caracter entrante
	MOV AH, 0Eh;funcion de salida teletipo
    INT 10h; interrupcion con funcion VGA
    POP AX;sacamos de pila ax
endm  

limpiarPantalla macro 
	mov ah,00h ;limpia la pantalla
	mov al,03h
	int 10h
endm

leer_usuarios macro handle, usuario, rutaA
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 3dh ; abrir un archivo
	mov al, 0h
	mov dx, offset rutaA
	int 21h
	mov ah,42h
	mov al,00h
	mov bx,ax
	mov cx,50
	int 21h
	
	mov handle, ax ;Se mueve el apuntador de lectura al archivo
	mov ah, 3fh 
	mov bx, handle  
	mov cx, 100 ;leemos 100 bytes
	lea dx, usuario
	int 21h
	
	mov ah, 3eh ;cierra el archivo
	mov bx, handle
	int 21h
	
	push dx
	push cx
	push bx
	push ax
	
endm

print macro msg 
    push ax
    push dx
    mov ah,09h
    mov dx,offset msg
    int 21H
    pop dx
    pop ax
endm

actualizar_usuarios macro handleA, usuariosA
	push ax
	push bx
	push cx
	push dx
	
	mov    ax,@data
	mov    ds,ax
	mov    ah,3ch
	mov    cx,00
	lea    dx,ruta
	int    21h
	mov    handle,ax
	mov    cx,500
	
	push   cx
	mov    ah,40h
	mov    bx,handleA
	mov    cx,208
	lea    dx,usuariosA
	int    21h
	pop    cx;encabezado rex
	mov    ah,3eh
	mov    bx,handleA
	int    21h
	push dx
	push cx
	push bx
	push ax
endm

contorno macro nivel_
	push ax
	push bx
	push cx
	push dx
  
	mov cx,10		;marco derecho
	mov dx,10

	contorno_derecho:		
		mov ah,0ch
		mov al,25
		int 10h
		inc dx
		cmp dx,190
		jne contorno_derecho

		mov cx,255  ;marco izquierdo 
		mov dx,10

	contorno_izquierdo:     
		mov ah,0ch
		mov al,25
		int 10h
		inc dx
		cmp dx,190
		jne contorno_izquierdo
	  
		mov cx,10		;marco arriba
		mov dx,10

	contorno_superior:     
		mov ah,0ch
		mov al,25
		int 10h
		inc cx
		cmp cx,255
		jne contorno_superior
	  
		mov cx,10		;marco abajo
		mov dx,190

	contorno_inferior:     
		mov ah,0ch
		mov al,25
		int 10h
		inc cx
		cmp cx,255
		jne contorno_inferior
	  
		cmp nivel_, 0
		je fin
	  
		cmp nivel_,1
		je fin
	  
		cmp nivel_,2
		je muro
	  
		cmp nivel_, 3
		je muro
  
	muro: 
		mov cx,50		
		mov dx,40

	muro_superior:     ;obataculo arriba
		mov ah,0ch
		mov al,50
		int 10h
		inc cx
		cmp cx,210
		jne muro_superior
		  
	mov cx,50		
	mov dx,130

	muro_inferior:     ;obstaculo abajo
		mov ah,0ch
		mov al,50
		int 10h
		inc cx
		cmp cx,210
		jne muro_inferior
	  
		cmp nivel_, 2
		je fin
	  
		cmp nivel_,3
		je muro2
  
	muro2:
	  mov cx,70		;obstaculo izquierdo
	  mov dx,50

	muro2_derecho:		
	  mov ah,0ch
	  mov al,125
	  int 10h
	  inc dx
	  cmp dx,75
	  jne muro2_derecho

	mov cx,180  ;obstaculo derecho 
	mov dx,50

	muro2_izquierdo:     
		mov ah,0ch
		mov al,80
		int 10h
		inc dx
		cmp dx,120
		jne muro2_izquierdo
	
	
	mov cx, 75
	mov dx,120
	
	obs_up2:     ;obataculo arriba
		mov ah,0ch
		mov al,80
		int 10h
		inc cx
		cmp cx,180
		jne obs_up2

	
	fin: 
		push dx
		push cx
		push bx
		push ax
  
endm



;--------------------------------------------------------------------------------------
.model small
.stack 200h
.data
	
	encabezado db 	0Ah, 0Dh,"UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",
					0Ah, 0Dh,"FACULTAD DE INGENIERIA ESCUELA DE CIENCIAS Y SISTEMAS",
					0Ah, 0Dh,"ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 B",
					0Ah, 0Dh,"PRIMER SEMESTRE 2018",
					0Ah, 0Dh,"Carlos Andree Avalos Soto",
					0Ah, 0Dh,"201408580",
					0Ah, 0Dh,"Segunda Practica", "$"
						
	menu_principal db 0Ah, 0Dh,"##################################",
					  0Ah, 0Dh,"######### MENU PRINCIPAL #########",
					  0Ah, 0Dh,"##################################", 
					  0Ah, 0Dh,"### 1. Ingresar                ###", 
					  0Ah, 0dh,"### 2. Registrar               ###", 
					  0Ah, 0dh,"### 3. Salir                   ###", 
					  0Ah, 0Dh,"##################################", "$"
	
	msj1 db 0Ah,0dh,"Ingrese opcion: ","$"
	msj2 db 0Ah,0dh, "USTED ACABA DE SALIR..... :D","$"
	nuevaLinea	db	0Ah,0Dh, '$'
	msj_espera db 0Ah, 0Dh, "Presione cualquier tecla para continuar...",'$'
	msj3 db 0Ah,0Dh, "Ingrese Usuario: ",'$'
	msj4 db 0Ah, 0Dh,"Ingrese Password: ",'$'
	ruta db "lstUsuarios.txt",0000h
	msj5 db 0Ah, 0Dh, "Usuario registrado",'$'
	msgErrorA db 0ah,0dh, 'Error al leer el archivo','$'
	msj6 db 0Ah,0Dh, "************************************** ",
			0Ah,0Dh, "*        Bienvenido a SNAKE          * ",
			0Ah,0Dh, "**************************************" ,'$'
			
	msj7 db 0Ah,0Dh, "***Sesion Iniciada***",'$'
	msj8 db 0Ah, 0Dh, "usuario: ",'$'
	msj_peridida db 0Ah,0Dh, "Mejor suerte",0Ah,0Dh,"Punteo: ",'$'
	msj_victoria db 0Ah,0Dh,"¡En hora buena, has ganado!",0Ah,0Dh,"puntos_: 30",'$'
	handle dw ?
	usuarioActual db 50 dup('$') 
	passActual db 50 dup('$')
	usuarios db 500 dup('$')
	posx db 150
	posx2 db 149
	diez dw 10
	direccion db 1 dup('r')
	horizontal db 500 dup(0)
	vertical db 500 dup(0)
	posy db 100
	posy2 db 100
	tamano_cuerpo db 4
	puntos_ db "0",'$'
	puntosAuxiliares db 0
	puntosTotales db 0
	nivel_ db "1",'$'
	nivelActual db 1
	msj_nivel db " Nvl ",'$'
	flag db 0
	posX_cola db 0
	posY_cola db 0
	frutax db 0
	frutay db 0
	
	
	
.code
.startup

	xor ax,ax	
	mov ax,@data	
	mov ds,ax
	
	
	call Inicializacion
	
	mov di, 0
	
	Menu proc far
	
		clc
		xor ax,ax
		xor bx,bx
		xor si,si
		xor cx,cx
		xor dx,dx
	
		mov si,0 
		mov horizontal[si],146
		mov vertical[si],100
		inc si
		mov horizontal[si],147
		mov vertical[si],100
		inc si
		mov horizontal[si],148
		mov vertical[si],100
		inc si
		mov horizontal[si],149
		mov vertical[si],100
		inc si
		mov horizontal[si],150
		mov vertical[si],100
		push si
	
		limpiarPantalla
		imprimir encabezado
		imprimir menu_principal
		call leer_linea
		
		cmp al,1;
		je @Ingresar
		
		cmp al,2;
		je @Registrar
		
		cmp al,3;
		je @salir
			
		jmp Menu;
		
		@Ingresar:
		
			mov si,000h
			xor bx,bx
			limpiarPantalla
			imprimir msj3
			
			@@LeerUsuarioI:
				mov ah, 01h 
				int 21h 
				mov usuarioActual[si], al 
				inc si				
				cmp al,0dh  
				jnz @@LeerUsuarioI 
			
			
			imprimir msj4
			mov si,00h
			
			@@LeerPassI:
				mov ah, 01h 
				int 21h 
				mov passActual[si], al 
				inc si
				
				cmp al,0dh  
				jnz @@LeerPassI
			
			imprimir msj7
			
			imprimir msj6
			imprimir nuevaLinea
			imprimir usuarioActual
			
			esperarAccion
		
			
			pop si
			mov di,00h
			
			jmp @modo_grafico
		
		@Registrar:	
			mov si,000h
			xor bx,bx
			limpiarPantalla
			imprimir msj3
			
			@@LeerUsuario:
				mov ah, 01h 
				int 21h 
				mov usuarioActual[si], al 
				inc si
				
				
				cmp al,0dh  
				jnz @@LeerUsuario 
			
			imprimir usuarioActual
			imprimir msj4
			mov si,00h
			
			@@LeerPass:
				mov ah, 01h
				int 21h 
				mov passActual[si], al 
				inc si
				
				cmp al,0dh  
				jnz @@LeerPass 	
				
			imprimir passActual
			imprimir nuevaLinea
			
			@@Registrar:
				xor bx,bx
				@@@Disponible:
					add bx,1
					cmp usuarios[bx],'$'
					jnz @@@Disponible
				mov si,000h
				
			@@Registro_Usuario:
				mov al,usuarioActual[si]
				mov usuarios[bx],al
				inc si
				add bx,1
				cmp usuarioActual[si],'$'
				jnz @@Registro_Usuario
			mov usuarios[bx],','
			mov si,000h
			add bx,1
			
			@@Registro_Pass:
				mov al, passActual[si]
				mov usuarios[bx],al
				inc si
				add bx,1
				cmp passActual[si],'$'
				jnz @@Registro_Pass

			mov usuarios[bx],';'
			mov si,000h

			imprimir msj5
			imprimir nuevaLinea
			esperarAccion
			
			@@limpiar_Registros:
				mov usuarioActual[si],'$'
				mov passActual[si], '$'
				inc si
				cmp si,50
				jnz @@limpiar_Registros
			
			actualizar_usuarios handle, usuarios
			
			xor bx,bx
			mov si,000h
			clc
			xor ax,ax
			
			jmp Menu
			
			
		@salir:
			esperarAccion
			
			mov ah,09h
			lea dx,msj2;mostramos mensaje de salida
			int 21h

			mov ax,4c00h ;Opcion para salir
			int 21h ;Termmina interrupcion 21h funcion DOS
			
			
		@modo_grafico:
			
			mov ah,0
			mov al,13h
			int 10h
		
			contorno nivelActual
			imprimirCaracter '	'
			print msj8
			imprimirCaracter '	'
			imprimir puntos_
			imprimirCaracter '	'
			imprimir msj_nivel
			imprimir nivel_
			  
			mov cl, tamano_cuerpo
			
			call generarFruta

			@@bucle_movimiento:
				
				cmp puntosTotales,30
				je @fin_partida
				
				cmp puntosAuxiliares,10
				je @@aumentar_nivel
				jnz @@colocar_cuerpo
				
			
			@@aumentar_nivel:
				inc nivelActual
				inc nivel_
				mov puntosAuxiliares,0
			
			@@limpiar_cola:
				cmp flag,1
				jnz @@colocar_cuerpo
				je limpia_mg
				
				limpia_mg:
				mov flag,0
				jmp @modo_grafico	
			
			@@colocar_cuerpo: 
				mov al, horizontal[si]
				mov posx,al
				mov al, vertical[si]
				mov posy, al
				Pintar_Pixel  150, posx, posy
				inc si
				
				mov al, horizontal[di]
				mov posX_cola,al
				mov al, vertical[di]
				mov posY_cola, al
				Pintar_Pixel  0,posX_cola, posY_cola

				cmp nivelActual, 1
				je @validarCrecimiento
				
				cmp nivelActual, 2
				je @validarChoque

				cmp nivelActual, 3
				je @validarChoque
			
			@validarChoque:
				clc
				cmp posx,40
				jge @validarX
				jnge @validarX
			
			@validarX:
				cmp posx,210
				jle @validarMuro1
				jnle @validarNivel
			
			@validarMuro1: 
				cmp posy, 40
				je @retornar
			
				cmp posy, 130
				je @retornar
				
				jmp @validarNivel
			
			@validarNivel:
				cmp nivelActual,2
				je @validarCrecimiento
			
				cmp nivelActual,3
				je @validarChoque2
			
				jmp @validarCrecimiento
			
			@validarChoque2:
				
				cmp posy,50
				jge @validarY
				jnge @validarCrecimiento
			
			@validarY:
				cmp posy,50
				jle validar_x_obs2
				jnle @validarCrecimiento
			
			validar_x_obs2: 
				cmp posx, 70
				je @retornar
				
				cmp posx, 180
				je @retornar
				jmp @validarCrecimiento
			
			@validarCrecimiento: 
				mov cl,frutax
				cmp posx, cl
				je @validar_y
				jmp @tamano_cuerpo
			
			@validar_y:
				mov cl,frutay
				cmp posy, cl
				je aumentar_puntos
				jnz @tamano_cuerpo		
			
			aumentar_puntos: 
				inc puntosAuxiliares
				inc puntosTotales
				inc tamano_cuerpo
				call generarFruta
				jmp direccion2
			
			@tamano_cuerpo:
				inc di
			
				cmp si,500
				je @@clear_si
				
				cmp di, 500
				je @@clear_di
				
				jmp direccion2
			
			@@clear_si:
				mov si,0
				jmp direccion2
			
			@@clear_di:
				mov di,0
			
			direccion2:
				cmp nivelActual, 1
				je @velocidad1
			
				cmp nivelActual, 2
				je @velocidad2
			
				cmp nivelActual,3
				je @velocidad3
			
			@velocidad1:
				mov cx,0000h ; tiempo del delay
				mov dx,0ffffh ; tiempo del delay
				jmp @@esperar
			
			@velocidad2:
				mov cx,0000h ; tiempo del delay
				mov dx,08fffh ; tiempo del delay
				jmp @@esperar
			
			@velocidad3:
				mov cx,0000h ; tiempo del delay
				mov dx,05fffh ; tiempo del delay
				jmp @@esperar
			
			@@esperar:
				call Delay
				push si
				call obtener_movimiento
				mov cx, 0
				cmp direccion[si], 117 
				je @mover_arriba
			
				cmp direccion[si], 100 
				je @mover_abajo
			
				cmp direccion[si], 108
				je @mover_izquierda
				
				cmp direccion[si], 114  
				je mover_der
			
			@retornar:
			
				limpiarPantalla
				imprimir msj8
				imprimir usuarioActual
				
				imprimir msj_peridida
				mov al, puntosTotales
				cbw
				call Imprimir_Numero
				
				esperarAccion
				mov nivelActual,1
				mov puntosAuxiliares,0000
				mov puntosTotales,0
				mov tamano_cuerpo, 4
				mov si,0
				mov puntos_[si],'0'
				mov nivel_[si],'1'
				mov direccion[si],'r'
				mov flag, 0 
				xor bx, bx
				xor ax, ax
				clc
				jmp Menu
				
			@fin_partida:
				limpiarPantalla
				imprimir msj8
				imprimir usuarioActual
				imprimir msj_victoria
				esperarAccion
				mov nivelActual,1
				mov puntosAuxiliares,0000
				mov puntosTotales,0
				mov tamano_cuerpo, 4
				mov si,0
				mov puntos_[si],'0'
				mov nivel_[si],'1'
				mov direccion[si],'r'
				mov flag, 0 
				xor bx, bx
				xor ax, ax
				clc
				jmp Menu

			@mover_arriba:
				dec posy
				
				cmp posy,10
				je @retornar
				
				pop si
				mov al, posx
				mov horizontal[si],al
				mov al, posy
				mov vertical[si],al
				jmp @@bucle_movimiento


			@mover_abajo:
				inc posy
				
				cmp posy,190
				je @retornar
				
				pop si
				mov al, posx
				mov horizontal[si],al
				mov al, posy
				mov vertical[si],al
				jmp @@bucle_movimiento
			
			@mover_izquierda:
				dec posx
				
				cmp posx,10	
				je @retornar
				
				pop si
				mov al, posx
				mov horizontal[si],al
				mov al, posy
				mov vertical[si],al
				jmp @@bucle_movimiento
				
			mover_der:
				pop si
				inc posx
				cmp posx,255	
				je @retornar
				
				mov al, posx
				mov horizontal[si],al
				mov al, posy
				mov vertical[si],al
				jmp @@bucle_movimiento


	Menu endp 
;-------------------------Procesos------------------------------------------------
Delay proc
	mov ah , 86h
    int 15h
    ret    		
Delay endp

obtener_movimiento proc
	call leer_tecla
	mov si, 0
	cmp dl,48h
	je arriba
		
	cmp dl,50h
	je abajo
	
	cmp dl,4bh
	je izquierda
	
	cmp dl,4dh
	je derecha
	
	cmp dl, 113
	je fin_programa
	
	ret
obtener_movimiento endp

leer_tecla proc
	mov ah, 01H
    int 16H
    jnz obtener_tecla
    xor dl, dl
    ret	
	obtener_tecla:	
		mov ah, 0
		int 16H
		mov dl,ah
		ret
leer_tecla endp
	
arriba proc
	mov flag, 1
	mov direccion[si], 'u'
	mov bl, posy
	mov posy2,bl
	add posy2,1
	mov bl, posx
	mov posx2, bl
	xor dl, dl
	ret
arriba endp
	
abajo proc
	mov flag, 1
	mov direccion[si], 'd'
	mov bl, posy
	mov posy2, bl
	sub posy2,1
	mov bl, posx
	mov posx2, bl
	xor dl, dl
	ret
abajo endp

izquierda proc
	mov flag, 1
	mov direccion[si], 'l'
	mov bl,posx
	mov posx2, bl
	add posx2,1
	mov bl, posy
	mov posy2, bl
	xor dl, dl
	ret
izquierda endp

derecha proc
	mov flag, 1
	mov direccion[si], 'r'
	mov bl, posx
	mov posx2, bl
	sub posx2,1
	mov bl, posy
	mov posy2, bl
	xor dl, dl
	ret
derecha endp


fin_programa proc
	  ; regresar a modo texto
	  mov ax,0003h
      int 10h
	  mov ax,4c00h
	  int 21h
	  ret
fin_programa endp
		
leer_linea proc near

	mov ah,09h; funcion para imprimir cadena
	lea dx,nuevaLinea;le damos enter
	int 21h; funcion DOS

	mov ah,09h; funcion para imprimir cadena
	lea dx,msj1;para que elija una opcion
	int 21h; funcion DOS

	mov ah,01h;leer caracter desde teclado
	int 21h;interrupcion DOS
	sub al,30h;restamos en codigo ascii para que quede saolamente el numero

	ret; para retornar al proceso de donde se llamo 
leer_linea endp
;================Proceso para imprimir numero==============================
Imprimir_Numero proc near
	push dx;agregamos a pila dx
	push ax;agregamos a pila ax
	
	cmp ax,0;comparamos ax si tiene algun numero
	jnz @no_cero;si no es cero saltamos
	
	imprimirCaracter '0';mandamos un cero si es 0
	jmp @impreso;saltamos al proceso de finalizacion
	
	@no_cero:
		cmp ax,0;comparamos ax
		jns @positivo; si no tiene signo
		neg ax;complemento a 2
		
		imprimirCaracter '-';agregamos el caracter -
		
	@positivo:
		call Imprimir_Numero_sinSigno;llamamos al proceso para imprimir numeros sin signo
		
	@impreso:
		pop ax;sacamos de pila el registro ax
		pop dx;sacamos de pila el registro dx
		ret;retornamos
Imprimir_Numero endp
;==========================================================================

;Muestra numero alojados en ax sin signo
;==============Proceso para imprimir un numero sin signo ==================
Imprimir_Numero_sinSigno proc near
	push ax;agregamos a pila ax
	push bx;agregamos a pila bx
	push cx;agregamos a pila cx
	push dx;agregamos a pila dx
	
	mov cx,1
	mov bx,10000
	
	cmp ax,0 ;comparamos el registro ax
	jz @imprimir_cero; si ax es igual a 0 vamos a imprimir 0
	
	@inicio:
		cmp bx,0;comparamos el registro bx
		jz @final;si es igual a 0 saltamos al final
		
		cmp cx,0;comparamos el registro cx
		je @calc;si es igual a 0 saltamos a calc
		
		cmp ax,bx;comparamos ax con bx
		jb @salto;entonces ax<bx por lo tanto div sera diferente cero
	
	@calc:
		mov cx,0000h;limpiamos el registro cx
		mov dx,0000h;limpiamos el registro dx
		div bx;dividimos ax=ax/bx
		add al,30h;lo convertimos en numero ascii
		imprimirCaracter al;lo mandamos a imprimir 
		
		mov ax,dx; guardamos el resultado de la ultima division
		
	@salto:
		push ax
		mov dx,0000h;limpiamos registro
		mov ax,bx;guardamos valor de bx en ax para operar
		div diez;dividimos ax=ax/10
		mov bx,ax
		pop ax
		
		jmp @inicio;regresamos
		
	@imprimir_cero:
		imprimirCaracter '0';imprimimos 0
	
	@final:
		pop dx;sacamos de pila ax,bx,dx,cx
		pop cx
		pop bx
		pop ax
		ret;retornamos
Imprimir_Numero_sinSigno endp

generarFruta proc near
	push Ax
	push dx
	push cx
	

	Mov ah,2Ch 
	Int 21h 
	mov frutax, dl
	add frutax,20
	
	mov frutay,dh
	add frutay,20
	add frutay,dl
	
	Pintar_Pixel 60,frutax,frutay
	
	pop cx
	pop dx
	pop ax
	
	ret 

generarFruta endp

Inicializacion proc near

	xor bx, bx
	
	mov bx, 150 
	push bx
	mov bx, 100
	push bx
	
	mov bx, 149 
	push bx
	mov bx, 100
	push bx
	
	mov bx, 148 
	push bx
	mov bx, 100
	push bx
	
	mov bx, 147 
	push bx
	mov bx, 100
	push bx
	
	mov bx, 146 
	push bx
	mov bx, 100
	push bx
	
	mov si,0 
	mov horizontal[si],146
	mov vertical[si],100
	inc si
	mov horizontal[si],147
	mov vertical[si],100
	inc si
	mov horizontal[si],148
	mov vertical[si],100
	inc si
	mov horizontal[si],149
	mov vertical[si],100
	inc si
	mov horizontal[si],150
	mov vertical[si],100
	
	ret
Inicializacion endp
;==========================================================================

;---------------------------------------------------------------------------------
.exit
end