.386
.MODEL flat, stdcall
OPTION casemap:none
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA?
    NOMBRE DB 100 DUP(?)
    CARNE DB 100 DUP(?)
    CARRERA DB 100 DUP(?)
.CODE
Program:
    print chr$("INGRESE NOMBRE: ")
	INVOKE StdIn, ADDR NOMBRE, 100
	print chr$("INGRESE CARNE: ")
	INVOKE StdIn, ADDR CARNE, 100
	print chr$("INGRESE CARRERA: ")
    INVOKE StdIn, ADDR CARRERA, 100
	print chr$("HOLA ")
	INVOKE StdOut, ADDR NOMBRE
	print chr$(" SU CARNE ES ")
	INVOKE StdOut, ADDR CARNE
	print chr$(13, 10, "BIENVENIDO A LA CARRERA DE ")
	INVOKE StdOut, ADDR CARRERA
    INVOKE ExitProcess, 0
END Program