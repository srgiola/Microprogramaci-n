;MACROS
A_CUADRADO MACRO A
	print chr$(13, 10, "Cuadrado")
	print chr$(13, 10, "Area: ")
	MOV AL, A
	MUL A
	print str$(AL)
	print chr$(13, 10, "Perimetro: ")
	MOV AL, A
	MOV AH, 4H
	MUL AH
	print str$(AL)
ENDM

A_RETANGULO MACRO A, B
	print chr$(13, 10, "Retangulo ")
	print chr$(13, 10, "Area: ")
	MOV AL, A
	MUL B
	print str$(AL)
	print chr$(13, 10, "Perimetro: ")
	MOV AL, A
	MOV BL, 02H
	MUL BL

	MOV CH, AL

	MOV AL, B
	MUL BL
	ADD CH, AL
	print str$(CH)
ENDM

A_TRIANGULO MACRO A, B, H
	print chr$(13, 10, "Triangulo ")
	print chr$(13, 10, "Area: ")
	MOV AL, A
	MUL B
	MOV BH, 02H
	DIV BH
	print str$(AL)
	print chr$(13, 10, "Perimetro: ")
	MOV AL, A
	ADD AL, B
	ADD AL, H
	print str$(AL)
ENDM

OPERA MACRO A, B, C
	print chr$(13, 10)
	print chr$("2b+3(a-c) : ")
	MOV AL, B
	MOV BH, 02H
	MUL BH

	MOV BH, AL ;SE GUARDA EN BH 2*B

	MOV CH, A
	SUB CH, C
	MOV AL, CH
	MOV DH, 03H
	MUL DH

	MOV DH, AL ;SE GUARDO EN DH 3*(A-C)

	ADD DH, BH
	print str$(DH)
	
	print chr$(13, 10, "a/b : ")
	CALL LIMPIAR
	MOV AL, A
	MOV BH, B
	DIV BH
	print str$(AL)

	print chr$(13, 10, "a*b/c : ")
	CALL LIMPIAR
	MOV AL, A
	MUL B
	DIV C
	print str$(AL)

	print chr$(13, 10, "a*(b/c) : ")
	CALL LIMPIAR
	MOV AL, B
	DIV C
	MUL A
	print str$(AL)
ENDM

;END MACROS
.386
.MODEL flat, stdcall
OPTION casemap:none
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc

locate PROTO :DWORD,:DWORD

.DATA
	CADENA DB 100 DUP(0)
	CADENA2 DB 100 DUP(0)
	CANT DB 0
.DATA?
	OP DB ?
	L_A DB ?
	L_B DB ?
	L_H DB ?
.CODE
MAIN:
	;EJERCICIO 1
	EJERCICIO1:

	print chr$(13, 10, "Ejercicio 1, selecione la figura a calcular el area y perimetro", 13, 10, "1 - Cuadrado", 13, 10, "2 - Rectangulo", 13, 10, "3 - Triangulo", 13, 10, "4 - Ir a Ejercicio 2", 13, 10)
	INVOKE StdIn, ADDR OP, 4
	
	CMP OP, 31H
	JZ CUADRADO

	CMP OP, 32H
	JZ RETANGULO

	CMP OP, 33H
	JZ TRIANGULO

	CMP OP, 34H
	JZ EJERCICIO2

	CMP OP, 34H
	JMP DIFERENTE

	CALL clear_screen

	CUADRADO:
		print chr$("Ingrese un lado del Cuadrado ")
		INVOKE StdIn, ADDR L_A, 4
		SUB L_A, 30H
		A_CUADRADO L_A
		JMP EJERCICIO1

	RETANGULO:
		print chr$("Ingrese el ancho del retangulo ")
		INVOKE StdIn, ADDR L_A, 4
		SUB L_A, 30H
		print chr$(13, 10, "Ingrese el largo del retangulo ")
		INVOKE StdIn, ADDR L_B, 4
		SUB L_B, 30H
		A_RETANGULO L_A, L_B
		JMP EJERCICIO1

	TRIANGULO:
		print chr$("Ingrese la altura del retangulo ")
		INVOKE StdIn, ADDR L_A, 4
		SUB L_A, 30H
		print chr$(13, 10, "Ingrese la base del retangulo ")
		INVOKE StdIn, ADDR L_B, 4
		SUB L_B, 30H
		print chr$(13, 10, "Ingrese la hipotenusa del retangulo ")
		INVOKE StdIn, ADDR L_H, 4
		SUB L_H, 30H
		A_TRIANGULO L_A, L_B, L_H
		JMP EJERCICIO1

	DIFERENTE:
		CALL clear_screen
		JMP EJERCICIO1

	;EJERCICIO 2
	EJERCICIO2:
	MOV L_A, 0H
	MOV L_B, 0H
	MOV L_H, 0H

	;print chr$("Ingrese el valor de a ")
	;INVOKE StdIn, ADDR L_A, 4
	;SUB L_A, 30H
	;print chr$(13, 10, "Ingrese el valor de b ")
	;INVOKE StdIn, ADDR L_B, 4
	;SUB L_B, 30H
	;print chr$(13, 10, "Ingrese el valor de c ")
	;INVOKE StdIn, ADDR L_H, 4
	;SUB L_H, 30H
	;OPERA L_A, L_B, L_H

	;EJERCICIO 3
	print chr$(13, 10, "Ingrese cadena a buscar", 13, 10)
	INVOKE StdIn, ADDR CADENA2, 102
	print chr$(13, 10, "Ingrese cadena grande", 13, 10)
	INVOKE StdIn, ADDR CADENA, 100

	CALL CADENAS

	;FIN DE PROGRAMA
	INVOKE ExitProcess, 0

;PROCEDIMIENTOS
clear_screen proc
    LOCAL hOutPut:DWORD
    LOCAL noc    :DWORD
    LOCAL cnt    :DWORD
    LOCAL sbi    :CONSOLE_SCREEN_BUFFER_INFO
    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov hOutPut, eax
    invoke GetConsoleScreenBufferInfo,hOutPut,ADDR sbi
    mov eax, sbi.dwSize
    push ax
    rol eax, 16
    mov cx, ax
    pop ax
    mul cx
    cwde
    mov cnt, eax
    invoke FillConsoleOutputCharacter,hOutPut,32,cnt,NULL,ADDR noc
    invoke locate,0,0
    ret
clear_screen endp

LIMPIAR PROC
	XOR AX, AX
	XOR BX, BX
	XOR CX, CX
	XOR DX, DX
RET
LIMPIAR ENDP

CADENAS PROC
	print chr$("Ocurrencias: ")
	MOV CL, 0
	LEA ESI, CADENA
	LEA EDI, CADENA2

	L:
	MOV AL, [ESI]
	CMP AL, 0
	JE END_	
	CMP AL, [EDI]
	JE LM
	INC ESI
	JMP L

	LM:
	MOV BL, [EDI]
	CMP BL, 0
	JE LC
	INC ESI
	INC EDI
	MOV AL, [ESI]
	CMP AL, [EDI]
	JE LM
	MOV BL, [EDI]
	CMP BL, 0
	JE LC
	LEA EDI, CADENA2
	JMP L
	
	LC:
	INC CANT
	LEA EDI, CADENA2
	JMP L
	
	END_:
	ADD CANT, 30H
	INVOKE StdOut, ADDR CANT
RET
CADENAS ENDP

END MAIN