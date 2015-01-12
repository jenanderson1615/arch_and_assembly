TITLE Combinatoric Driller			(program6.asm)

; Program Description:  The program outputs a combinatoric problem and asks for an answer.  The program then
;				    gives feedback about whether the answer is correct or incorrect.  
; Author:
; Date Created:
; Last Modification Date:

INCLUDE Irvine32.inc

SET_MIN = 3
SET_MAX = 12
CHOICES_MIN = 1

.data

;;;;;;;;;;
;
; Text
;
;;;;;;;;;;

title_Message	BYTE	"Welcome to the Combinatoric Driller!",0
author_Message	BYTE	"Written by Jen Anderson.", 0
instruct_1	BYTE	"The program gives you a combinatoric problem.", 0  
instruct_2	BYTE	"Type in the answer and the program will ",0
instruct_3	BYTE "tell you if your answer is right or wrong.",0
problem		BYTE	"Here's your problem: ", 0
question_1	BYTE "     How many ways can you chose ",0
question_2	BYTE	"     elements from a set of ", 0
question_3	BYTE	" elements?", 0
answer_prompt	BYTE	"Your answer: ", 0
answer_1		BYTE	"There are ", 0
answer_2		BYTE	" ways to chose ",0
answer_3		BYTE	" elements from a set of ", 0
answer_4		BYTE	".", 0
result_Right	BYTE	"You answered right!", 0
result_Wrong	BYTE	" was not correct.", 0
farewell		BYTE	"Thanks for playing!  Goodbye.", 0

;;;;;;;;;;
;
; Numbers
;
;;;;;;;;;;

number_To_Choose	DWORD	0
number_In_Set		DWORD	0
range			DWORD	0
user_Answer		DWORD	?
correct_Answer		DWORD	0
factorial_Arg		DWORD	0
factorial_Answer	DWORD	0

.code
main PROC
	call randomize
	call introduction
	call CrLF

	push OFFSET	number_To_Choose
	push	OFFSET	number_In_Set
	call showProblem

	push OFFSET	user_Answer
	call getData

	push number_To_Choose
	push number_In_Set
	push	OFFSET	correct_Answer
	push	factorial_Arg
	push factorial_Answer
	call factorial

	mov	eax, factorial_Answer
	call WriteDec
	call CrLF

	push	number_To_Choose
	push	number_In_Set
	push	user_Answer
	push	correct_Answer
	call showResults

	exit
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description:
; Receives:
; Returns:  
; Preconditions: 
; Registers Changed: 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

writeStringMac	MACRO	a_String
	push	edx
	mov	edx, OFFSET	a_String
	call WriteString
	pop edx
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Displays the introduction
; Receives: None
; Returns:  None, but prints the introduction
; Preconditions: None
; Registers Changed: edx
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

introduction	PROC
	writeStringMac title_Message
	call CrLF
	writeStringMac	author_Message
	call CrLF
	call CrLF
	writeStringMac instruct_1
	call CrLF
	writeStringMac	instruct_2
	call CrLF
	writeStringMac	instruct_3
	call CrLF
	ret
introduction	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Displays the combinatorics problem
; Receives: numbers_In_Set (address)
;	       numbers_To_Choose (address)
; Returns:  The value at the address numbers_In_Set is a random value between 3 and 12.
;		  The value at the address numbers_To_Choose is a random value between 1 and numbers_In_Set.
;		  Prints out the problem
; Preconditions: None
; Registers Changed: 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showProblem	PROC
	push ebp
	mov ebp, esp

	mov	ecx, [ebp + 8]	 ;address of number_In_Set
	mov	esi, [ebp + 12] ;address of number_To_Choose

	;set number_In_Set to a random number between 3 and 12
		mov	eax, SET_MAX
		mov	ebx, SET_MIN
		sub	eax, ebx
		add	eax, 1
		call randomrange
		add eax, SET_MIN
		mov	[ecx], eax

	;set number_To_Choose to a random number between 1 and number_In_Set
		mov	eax, [ecx]
		mov	ebx, CHOICES_MIN
		sub	eax, ebx
		add	eax, 1
		call randomrange
		add	eax, CHOICES_MIN
		mov	[esi], eax

	;show the problem with the values put in
		writeStringMac problem
		call CrLF
		writeStringMac	question_1
		mov	eax, [esi]
		call WriteDec
		call CrLF
		writeStringMac	question_2
		mov	eax, [ecx]
		call WriteDec
		writeStringMac	question_3
		call CrLF
		call CrLF

	pop ebp
	ret 8
showProblem	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Gets the user's answer as a string and determines if it's a number.
; Receives: user_Answer (address)
; Returns:  user_Answer (address), with a valid number stored at the address
; Preconditions: None
; Registers Changed: 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getData	PROC

	push ebp
	mov	ebp, esp

	mov	esi, [ebp + 8]

	writeStringMac answer_prompt

	;have eax store the user's input as a string
	mov	eax, [esi]
	call ReadDec
	call CrLF

	;convert the string to numeric form

	;if non-digits, make them re-enter

	;store their entry in [ebp + 8]

	pop ebp
	ret 4

getData ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Calculates the factorial of the value passed to it recursively
; Receives: factorial_Arg
; Returns:  factorial_Answer, as the factorial of factorial_Arg
; Preconditions: 
; Registers Changed: 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

factorial	PROC

	push ebp
	mov	ebp, esp

	;compare factorial_Arg to 1
	;if equal, return factor_Answer
	;else 
	;factorial answer = factorial answer * factorial_Arg
	;factorial_Answer-1

	pop ebp
	ret 20

factorial ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Compares the user's answer to the correct answer and tells the user if they are right or wrong.
; Receives: user_Answer (value)
;		  correct_Answer (value)
;		  numbers_To_Choose (value)
;		  numbers_In_Set (value)
; Returns:  None, but prints out a results message
; Preconditions: 
; Registers Changed: 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showResults	PROC

	push ebp
	mov	ebp, esp

	writeStringMac answer_1
	mov	eax, [ebp + 8]
	call WriteDec
	writeStringMac answer_2
	mov	eax, [ebp + 20]
	call WriteDec
	writeStringMac answer_3
	mov	eax, [ebp + 16]
	call WriteDec
	writeStringMac answer_4
	call CrLF

	pop ebp
	ret 16

showResults ENDP


END main
