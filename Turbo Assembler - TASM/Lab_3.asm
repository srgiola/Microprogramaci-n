.MODEL SMALL
.DATA
	cantPrueba DB 'Cantidad de pruebas realizadas: $'
	PositivasPrueba DB   'Cantidad de resultados positivos: $'
	AVerde DB   'Alerta: verde. $'						
	AAmarilla DB   'Alerta: amarilla. $'
	ANaranja DB   'Alerta: naranja. $'
	UnidaE DW ?
	PTotal DB ?
	PovTotal DB ?
	PTE DW ?
	PosTE DW ?
	ARoja DB   'Alerta: roja. $'
	Unida DB ?
	Dece DB ?
	Cente DB ?
	TMP DB ?
	CentenaE DW ?
	DeceE DW ?
	
.STACK
.CODE
Main:
	MOV AX, @DATA		        
	MOV DS, AX
	MOV DX, OFFSET cantPrueba		
	MOV AH, 09h
	INT 21h
	
	MOV AH, 01h					
	INT 21h

	SUB AL, 30h					
	MOV Unida, AL
	MOV AH, 01h					
	INT 21h

	MOV TMP, AL
	CMP TMP, 0Dh				
	JE   PP					
	SUB AL, 30h					
	MOV TMP, AL					
	MOV AL, Unida
	MOV Dece, AL
	MOV AL, TMP
	MOV Unida, AL
	MOV AL, 0Ah
	MOV BL, Dece
	MUL BL						
	XOR BX, BX					
	MOV BL, Unida				
	ADD AX, BX					
	MOV PTE, AX
	MOV AH, 01h					
	INT 21h

	MOV TMP, AL
	CMP TMP, 0Dh				
	JE  TP					
	SUB AL, 30h					
	MOV TMP, AL				
	MOV AL, Dece
	MOV Cente, AL
	MOV AL, Unida
	MOV Dece, AL
	MOV AL, TMP
	MOV Unida, AL	
	MOV AL, 64h
	MOV BL, Cente			
	MUL BL						
	XOR BX, BX					
	ADD AX, PTE				
	MOV PTE, AX
	MOV DL, 0Ah					
	MOV AH, 02h
	INT 21h
	JMP PC
	
	
	
  PP:
	MOV DX, OFFSET PositivasPrueba		
	MOV AH, 09h
	INT 21h

	MOV AH, 01h					
	INT 21h

	SUB AL, 30h					
	MOV BL, Unida
	MOV Unida AL
	MOV PosTE, AX
	MOV PTE, BX
	JMP Calc
	
 TP:
	MOV DX, OFFSET PositivasPrueba		
	MOV AH, 09h
	INT 21h

	MOV AH, 01h					
	INT 21h

	SUB AL, 30h					
	MOV Unida, AL
	MOV AH, 01h					
	INT 21h

	MOV TMP, AL
	CMP TMP, 0Dh				
	JE  TO						
	JMP  TT					
	
 TO:
	MOV BL, Unida
	MOV PosTE, BX
	JMP Calc

 TT:
	SUB AL, 30h					
	MOV TMP, AL					
	MOV AL, Unida
	MOV Dece, AL
	MOV AL, TMP
	MOV Unida, AL
	MOV AL, 0Ah
	MOV BL, Dece
	MUL BL					
	XOR BX, BX					
	MOV BL, Unida				
	ADD AX, BX					
	MOV PosTE, AX
	
PC:

	MOV DX, OFFSET cantPrueba		
	MOV AH, 09h
	INT 21h
	
	MOV AH, 01h					
	INT 21h

	SUB AL, 30h					
	MOV Unida, AL
	MOV AH, 01h					
	INT 21h

	MOV TMP, AL
	CMP TMP, 0Dh				
	JE   PP					
	SUB AL, 30h					
	MOV TMP, AL					
	MOV AL, Unida
	MOV Dece, AL
	MOV AL, TMP
	MOV Unida, AL
	MOV AL, 0Ah
	MOV BL, Dece
	MUL BL						
	XOR BX, BX					
	MOV BL, Unida				
	ADD AX, BX					
	MOV PTE, AX
	MOV AH, 01h					
	INT 21h

	MOV TMP, AL
	CMP TMP, 0Dh				
	JE  TP					
	SUB AL, 30h					
	MOV TMP, AL				
	MOV AL, Dece
	MOV Cente, AL
	MOV AL, Unida
	MOV Dece, AL
	MOV AL, TMP
	MOV Unida, AL	
	MOV AL, 64h
	MOV BL, Cente			
	MUL BL						
	XOR BX, BX					
	ADD AX, PTE				
	MOV PTE, AX
	
Calc:
	XOR AX, AX					
	XOR BX, BX					
	MOV AL, 64h					
	MOV BX, PosTE				
	MUL BX	
	DIV PTE					
	CMP AL, 04h					
	JE Verde					
	JS Verde					
	CMP AL, 0Fh					
	JE Amarillo					
	JS Amarillo					
	CMP AL, 13h					
	JE Naraja					
	JS Naraja					
	JMP Rojo						
	
Verde:
	MOV DX, OFFSET AVerde			
	MOV AH, 09h
	INT 21h
	JMP FIN

Amarillo:
	MOV DX, OFFSET AAmarilla			
	MOV AH, 09h
	INT 21h
	JMP FIN
	
Naraja:
	MOV DX, OFFSET ANaranja			
	MOV AH, 09h
	INT 21h
	JMP FIN
	
Rojo:
	MOV DX, OFFSET ARoja			
	MOV AH, 09h
	INT 21h

FIN:
	MOV AH, 4Ch					
	INT 21h
END