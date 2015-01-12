TITLE Program 1 ~ Integer Arithmetic			(Program1.asm)

; Program Description: Takes two values from the user and outputs the sum, difference, product, and quotient with remainder
; Author: Jen Anderson
; Date Created: 06/24/13
; Last Modification Date: 07/07/13

INCLUDE Irvine32.inc

; No constants needed in this program.

.data

 intro	BYTE	"Hi, my name is Jen.  The name of this program is Integer Arithmetic.", 0  
 instructs_1	BYTE	"Enter two numbers when prompted.  The program ", 0
 instructs_2	BYTE "will output the sum, difference, product, and quotient with remainder.", 0
 prompt_1	BYTE	"Please enter your first integer: ", 0
 userInt_1	DWORD	?, 0 ; first integer entered by the user
 prompt_2	BYTE	"Please enter your second integer: ", 0
 userInt_2	DWORD	?,0 ; second integer entered by the user
 sum	DWORD	0, 0
 equalMessage	BYTE " = ", 0
 sumMessage	BYTE	" + ", 0 ; userInt1 + userInt2 = sum
 difference	DWORD	0, 0
 differenceMessage	BYTE	" - ",0 ; userInt1 - userInt2 = difference
 product	DWORD	0, 0
 productMessage	BYTE " x ",0 ; userInt1 x userInt2 = product
 quotient	DWORD	0, 0
 modVal	DWORD	0,0
 quotAndModMessage_1	BYTE " / ",0 ; userInt1 / userInt2 = quotient remainder mod
 quotAndModMessage_2	BYTE " Remainder: ", 0
 runAgain_1	BYTE	"Would you like to run the program again?", 0
 runAgain_2	BYTE "Enter 1 to run again or any other number to quit: ", 0
 playAgain_Answer	DWORD	0, 0
 goodbye	BYTE	"Thanks for using the program. Goodbye!",0

.code
main PROC

; display intro
mov	edx, OFFSET intro
call	WriteString
call	CrLF

; display instructs_1
mov	edx, OFFSET instructs_1
call	WriteString
call	CrLF

; display instructs_2
mov	edx, OFFSET instructs_2
call	WriteString
call	CrLF

top:

; get the first user integer
mov	edx, OFFSET prompt_1	
call WriteString			
call ReadInt
mov	userInt_1, eax
call CrLF

; prompt the user for the second integer
mov	edx, OFFSET prompt_2
call	WriteString
call ReadInt
mov userInt_2, eax
call	CrLF

; calculate the sum
mov	eax, userInt_1
mov	ebx, userInt_2
add	eax, ebx
mov	sum, eax

; display sum message
mov	eax, userInt_1
call	WriteDec
mov	edx, OFFSET	sumMessage
call	WriteString
mov	eax, userInt_2
call	WriteDec
mov	edx, OFFSET	equalMessage
call	WriteString
mov	eax, sum
call	WriteDec
call	CrLF

; calculate the difference
mov	eax,	userInt_1
mov	ebx, userInt_2
sub	eax, ebx
mov	difference, eax

; display difference message
mov	eax,	userInt_1
call	WriteDec
mov	edx,	OFFSET	differenceMessage
call	WriteString
mov	eax,	userInt_2
call	WriteDec
mov	edx, OFFSET	equalMessage
call	WriteString
mov	eax,	difference
call	WriteDec
call	CrLF	

; calculate the product
mov	eax, userInt_1
mov	ebx, userInt_2
mul	ebx
mov	product, eax

; display product message
mov	eax, userInt_1
call	WriteDec
mov	edx, OFFSET	productMessage
call	WriteString
mov	eax, userInt_2
call	WriteDec
mov	edx, OFFSET	equalMessage
call	WriteString
mov	eax,	product
call	WriteDec
call	CrLF

; calculate the quotient and mod
mov edx, 0
mov eax, userInt_1
mov ebx, userInt_2
div ebx
mov quotient, eax
mov modVal, edx

; display quotAndModMessage message
mov	eax, userInt_1
call	WriteDec
mov edx, OFFSET	quotAndModMessage_1
call	WriteString
mov	eax, userInt_2
call	WriteDec
mov	edx, OFFSET	equalMessage
call	WriteString
mov	eax,	quotient
call	WriteDec
mov	edx, OFFSET	quotAndModMessage_2
call WriteString
mov	eax, modVal
call	WriteDec
call CrLF

; display run again options
mov edx, OFFSET runAgain_1
call WriteString
call CrLF
mov edx, OFFSET runAgain_2
call WriteString
call CrLF

; get the play again answer
call ReadInt
mov	playAgain_Answer, eax
call CrLF

; run the program again if the answer is 1
mov eax, playAgain_Answer
cmp eax, 1
je top

; display goodbye
mov	edx, OFFSET goodbye
call	WriteString
call CrLF

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main
