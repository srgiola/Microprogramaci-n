.model small			; Modelo para ejecutables
.data 
	A DB 03h
	B DB 02h
	C DB 01h
.stack 					; Inicia el segmento de pila
.code					; Inicia el segmento de código
programa:				; Etiqueta para el inicio del programa
		Mov AX,@DATA	; Se obtiene la dirección de inicio del segmento de datos
		Mov DS,AX		; Se asigna al registro data segment la dirección de inicio del segmento de datos
		
		MOV AL, A		; Se asigna A a la parte baja del registro A
		ADD AL, B		; Se suma A + B
		ADD AL, 30h 	; Se agrega 30h para que sea un caracter imprimible
		MOV DL, AL		; Asignación del resultado al registro D
		MOV AH, 02h 	; Intrución de impresion del registro D
		INT 21h			; Fin de la instrución
		
		MOV AL, A 		; Se asigna A a la parte baja del registro A
		SUB AL, C		; Se resta A - C
		ADD AL, 30h		; Se agrega el caracter imprimible
		MOV DL, AL		; Se asigna el resultado al registro D
		INT 21h			; Fin de la instrución
		
		MOV AL, A		; Se asigna A a la parte baja del registro A
		ADD AL, B		; Se suma A + B
		ADD AL, B 		; Se suma A + 2B
		ADD AL, C		; Se suma A + 2B + C
		ADD AL, 30h		; Se le agrega el caracter imprimible
		MOV DL, AL 		; Se asigna el resultado AL registro D
		INT 21h
		
		MOV AL, A		; Se asigna A a la parte baja del registro A
		ADD AL, B		; Se suma A + B
		SUB AL, C		; Se resta A + B - C
		ADD AL, 30h 	; Se le agrega el caracter imprimible
		MOV DL, AL		; Se asigna el resultado AL al registro D
		INT 21h
		
		Mov AH,4CH		; Se asigna el código para finalización de programa
		Int 21h			; Si invoca a la interrupción del DOS 21h para finalizar

End programa