.MODEL SMALL
.DATA
	TEXTO_A DB 'Ingrese el numero: $'
	TEXTO_B DB 13, 10, 'resultado: $'			
	CADENA DB 300 DUP ('$')		
	CADENA_TMP DB 300 DUP ('$')	
	TMP DW 0
    	CONTADOR DW 0
	INDEX_F DB 0			 	
	INDEX_M DB 0 				
	ACARREO DB 0
	ENTRADA DB ?
    		
.STACK
.CODE	

mov ax, @DATA	                
mov ds, ax
xor ax, ax

call PLEER_ENTRADA
call FACTORIAL
call TEXTOPARSE
xor dx, dx
lea dx, TEXTO_B
mov ah, 09h
int 21h
lea dx, CADENA
int 21h
	
EndProgram:
mov ah, 4Ch
int 21h
    
PLEER_ENTRADA PROC NEAR
    lea dx, TEXTO_A
    mov ah, 09h
    int 21h
    xor ax, ax
    xor bx, bx
    xor dx, dx
    mov INDEX_F, 0
    mov TMP, 0
    mov bl, 10d			
    mov ah, 01h							
    int 21h
    sub al, 30h					
    mov dl, al
    xor ah, ah
    mov TMP, ax			
    mov ah, 01h	 	
    int 21h
    mov cl, al			
    sub cl, 30h			    
    cmp al, 0Dh			
    je LEER_ENTRADA             
    xor ax, ax
    mov ax, TMP
    mul bx				
    mov TMP, ax
    add TMP, cx				
    mov ah, 01h			
    int 21h
    mov cl, al			
    sub cl, 30h			
    cmp al, 0Dh			
    je LEER_ENTRADA       
    xor ax, ax
    mov ax, TMP
    mul bx				
    mov TMP, ax
    add TMP, cx				
    LEER_ENTRADA:
	xor ax, ax
	mov ax, TMP
	mov INDEX_F, al
	RET
	PLEER_ENTRADA ENDP

FACTORIAL PROC NEAR
	call INTPARSE
	PROCESO_F:
	xor dl, dl
	dec INDEX_F			
	cmp INDEX_F, 0h		
        je FIN_F                       
	mov dl, INDEX_F		
	mov INDEX_M, dl
	call MULTICADENAS	
	jmp PROCESO_F		            
	FIN_F:
	mov INDEX_F, 0h					
RET
FACTORIAL ENDP
	
MULTICADENAS PROC NEAR
	call CADENA_MOVER_CADENAS	
	PROCESO_M_CADENAS:
	dec INDEX_M
	cmp INDEX_M, 0h		
	je FIN_M                   
	call AGREGAR_CADENA			
	jmp PROCESO_M_CADENAS		          
	FIN_M:
	mov INDEX_M, 0h
RET

MULTICADENAS ENDP
	AGREGAR_CADENA PROC NEAR
	lea si, CADENA		
	lea di, CADENA_TMP
	LEER_CADENA_INDICE:
		mov al, [si]
		cmp al, 24h				            
		je PROCESO_SUMA			        		
		inc si
		inc di
		inc CONTADOR
		jmp LEER_CADENA_INDICE                    
	PROCESO_SUMA:
		dec si	
		dec di	
		dec CONTADOR
	SUMA:
		xor ax, ax
		xor bx, bx
		xor cx, cx
		mov bl, [si]	
		mov cl, [di]	
		add bl, cl
		add bl, ACARREO
		mov ACARREO, 0h
		cmp bl, 0Ah		
		jl ACARREO_NO               
		mov ACARREO, 1h	
		sub bl, 0Ah	
		ACARREO_NO:
			mov [si], bl
			dec si
			dec di
			dec CONTADOR
			cmp CONTADOR, 0h
			jge SUMA				
		EndAdd:
		    call INICIAR_MOVIMIENTO_CADENA
		    mov CONTADOR, 0h
	RET
	AGREGAR_CADENA ENDP
	
INICIAR_MOVIMIENTO_CADENA PROC NEAR
	cmp ACARREO, 0h		           
	je TERMINAR_PROCESO			          
	call MOVER_DERECHA	            
	call ESPACIO_INICIOt		        
	xor bx, bx			    
	mov bl, ACARREO		    
	lea si, CADENA		    
	mov [si], bl		    
	TERMINAR_PROCESO:
	    mov ACARREO, 0h		    
RET
INICIAR_MOVIMIENTO_CADENA ENDP
MOVER_DERECHA PROC NEAR
	xor cx, cx			
	lea si, CADENA		
	mov cl, 2Bh
	PROCESO_MOVER_DERECHA:
	    xor ax, ax
	    xor bx, bx
	    mov bl, [si]
	    mov [si], cl	
	    mov cl, bl		
	    inc si			
	    mov al, [si]	
	    cmp al, 24h		
	    jne PROCESO_MOVER_DERECHA		             
	    mov [si], cl	
RET
MOVER_DERECHA ENDP
	
ESPACIO_INICIOt PROC NEAR
	xor cx, cx			
	lea si, CADENA_TMP		
	mov cl, 0h			
	PROCESO_MOVER_DTMP:
	    xor ax, ax
	    xor bx, bx
	    mov bl, [si]	
	    mov [si], cl	
	    mov cl, bl		
	    inc si			
	    mov al, [si]	
	    cmp al, 24h		
	    jne PROCESO_MOVER_DTMP		           
	    mov [si], cl	
RET
ESPACIO_INICIOt ENDP	
CADENA_MOVER_CADENAS PROC NEAR
	xor dx, dx
	xor ax, ax
	lea si, CADENA	
	lea di, CADENA_TMP	
	COPIAR:
	    xor dl, dl
	    mov dl, [si]
	    mov [di], dl
	    inc si			
	    inc di
	    mov al, [si]	
	    cmp al, 24h		
	    jne COPIAR	                
RET
CADENA_MOVER_CADENAS ENDP	
	INTPARSE PROC NEAR
	xor bx, bx
	xor cx, cx
	lea si, CADENA	
	mov bl, INDEX_F
	cmp bx, 09h				        
	jle UNIDADs		             
	cmp bx, 63h				
	jle DECENAS		               
	jmp CETENENAS		          
	UNIDAD_TMP:
	    mov [si], cl			    
	    inc si					    
	UNIDADs:
	    mov [si], bl			   
	    jmp EndProc              
	DECENAS_TMP:
	    mov [si], cl
	    inc si					    
	    xor cl, cl
	DECENAS:
	    cmp bl, 09h
	    jle UNIDAD_TMP			       
	    sub bl, 0Ah				    
	    inc cl					   
	    jmp DECENAS		          
	CETENENAS:
	    cmp bl, 63h
	    jbe DECENAS_TMP			       
	    sub bl, 64h			
	    inc cl					  
	    jmp CETENENAS		       
	EndProc:
RET
INTPARSE ENDP
TEXTOPARSE PROC NEAR
	lea si, CADENA	
	Adjust:
		xor ax, ax
		xor bx, bx
		mov bl, [si]
		add bl, 30h		           
		mov [si], bl	
		inc si			
		mov al, [si]	
		cmp al, 24h		
		jne Adjust		          
RET
TEXTOPARSE ENDP

CADENA_LIMPIAR PROC NEAR
	lea si, CADENA	
	LIMPIAR:
	    xor ax, ax
	    mov bl, '$'
	    mov [si], bl
	    inc si			
	    mov al, [si]	
	    cmp al, 24h		
	    jne LIMPIAR	              
RET
CADENA_LIMPIAR ENDP

END