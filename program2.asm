TITLE Program 2 ~ Fibonnacci number			(Program2.asm)

; Program Description: Program prints a greeting, asks for the user's name, greets the user, asks for an integer
;				   within a range, and then outputs that many terms of the Fibonnacci sequence.  The program
;				   then ends with a parting message.  
; Author: Jen Anderson
; Date Created: 7/9/13
; Last Modification Date: 7/14/13

INCLUDE Irvine32.inc

;constants
UPPER_LIMIT = 46
LOWER_LIMIT = 1;

.data

title_Message	BYTE	"This is the Fibonnacci number program.", 0
prog_Name	BYTE	"The program was written by Jen Anderson.", 0
enter_Name_Instruct	BYTE	"What's your name? ", 0
user_Name	BYTE 33 DUP(0)
user_Greet_1	BYTE	"Hello, ",0
user_Info	BYTE	"When you enter a number, the program will show you that many Fibonnacci terms!", 0
range_Info	BYTE "The number you enter must be an integer between 1 and 46.", 0
prompt	BYTE	"How many Fibonnacci terms would you like to see?", 0
incorrect_Range	BYTE	"That number was not in the range.", 0
user_Terms	DWORD	?, 0
loop_Counter	DWORD	?, 0
five_Spaces	BYTE	"     ", 0
penultimate	DWORD	?, 0
previous	DWORD	?, 0
current_Value	DWORD	?, 0
line_Count	DWORD	0, 0
parting_Message_1	BYTE "Hope you enjoyed seeing ", 0
parting_Message_2	BYTE	" Fibonnacci terms, ", 0
goodBye_Message	BYTE	".  Goodbye!",0

.code
main PROC


introduction:

;display the program title
mov	edx, OFFSET title_Message
call	WriteString
call	CrLF

;display the programmer's name
mov edx, OFFSET prog_Name
call	WriteString
call CrLF

;get the user's name
mov edx, OFFSET enter_Name_Instruct
call	WriteString
mov	edx, OFFSET	user_Name
mov	ecx, 32 
call ReadString

;greet the user
mov	edx, OFFSET	user_Greet_1
call	WriteString
mov	edx, OFFSET	user_Name
call	WriteString
call CrLF

userInstructions:

;program intro
mov edx, OFFSET	user_Info
call	WriteString
call	CrLF

getNumber:

;advise on range
mov edx, OFFSET	range_Info
call	WriteString
call CrLF

;prompt for number 
mov edx, OFFSET	prompt
call	WriteString
call CrLF

getUserData:

;get the input
call ReadInt
mov	user_Terms, eax

comparingLoop:

;validate the input using a post-test loop
mov eax, user_Terms
cmp	eax, UPPER_LIMIT
jg	wrongRange
cmp	eax, LOWER_LIMIT
jl	wrongRange
jmp displayFibs

wrongRange:

mov	edx, OFFSET	incorrect_Range
call	WriteString
call	CrLF
jmp getNumber

displayFibs:

;if the user enters 1 or 2, the program jumps to a specific section that displays the correct output
;if the user enters a number in the range of 3-46, the program jumps to the section that calculates the fib num.
mov	eax, LOWER_LIMIT
cmp	eax, user_Terms
je	user_Terms_Is_One
mov	eax, (LOWER_LIMIT + 1)
cmp	eax, user_Terms
je	user_Terms_Is_Two
jmp	user_Terms_More_Than_Two

user_Terms_Is_One:

;print out one fib number
mov	eax, LOWER_LIMIT
call	WriteDec
call	CrLF
jmp farewell

user_Terms_Is_Two:

;print out two fib numbers
mov	eax, LOWER_LIMIT
call	WriteDec
mov	edx, OFFSET	five_Spaces
call	WriteString
mov	eax, LOWER_LIMIT
call	WriteDec
call CrLF
jmp	farewell

user_Terms_More_Than_Two:

;set loop counter equal to (user terms - 2) and store it in ecx
mov	eax, user_Terms
sub	eax, 2
mov	loop_Counter, eax
mov	ecx, loop_Counter

;print out the two 1 values, since they aren't calculated the same as the others
mov	eax, LOWER_LIMIT
call	WriteDec
mov	edx, OFFSET	five_Spaces
call	WriteString
mov	eax, LOWER_LIMIT
call	WriteDec
mov	eax, 2
add	eax, line_Count
mov	line_Count, eax

;initialize penultimate and previous to 1
mov	penultimate, LOWER_LIMIT
mov	previous, LOWER_LIMIT

print_Values_Loop:

;print an initial 5 spaces
mov	edx, OFFSET	five_Spaces
call	WriteString

;calculate the next value to print
mov	eax, penultimate
mov	ebx, previous
add	eax, ebx
mov	current_Value, eax

;decide how many numbers are currently in the line
mov	ebx, line_Count
cmp	ebx, 5

;if there's 5 numbers in the line, jump to the section that prints a new line first
je	need_New_Line

;if there's less than 5 numbers in the line, print out the current value in the same line
call WriteDec

;increment line count and jump over the need_New_Line section
mov	eax, LOWER_LIMIT
add	eax, line_Count
mov	line_Count, eax
jmp	reassign_Variables

need_New_Line:

;print a new line then call print the value
call CrLF
call	WriteDec

;set line_count to 1
mov	eax, 1
mov	line_Count, eax

reassign_Variables:

;reassign variables
mov	eax, previous
mov	penultimate, eax
mov	eax, current_Value
mov	previous,	eax

;loop to top if ecx doesn't equal 0
Loop	print_Values_Loop

farewell:

;display a parting message, including user's name
call CrLF
call CrLF
mov	edx, OFFSET	parting_Message_1
call	WriteString
mov	eax,	user_Terms
call	WriteDec
mov	edx, OFFSET	parting_Message_2
call	WriteString
mov	edx, OFFSET	user_Name
call	WriteString
mov	edx, OFFSET	goodBye_Message
call	WriteString
call CrLF



exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main
