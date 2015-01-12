TITLE Program 3~ Number Summary			(Program3.asm)

; Program Description:  Number Summary gathers integers from the user until the user enters a negative number.  
;				    The program then outputs the number of valid entries, the sum of the entries, and
;				    the average of the entries.  
; Author: Jen Anderson
; Date Created: 7/16/13
; Last Modification Date: 7/27/13

INCLUDE Irvine32.inc

;constants
UPPER_LIMIT = 100

.data

title_Message	BYTE	"This is the Number Summary Program.", 0
prog_Name	BYTE	"The program was written by Jen Anderson.", 0
enter_Name_Instruct	BYTE	"What's your name? ", 0
user_Name	BYTE 33 DUP(0)
user_Greet_1	BYTE	"Hello, ",0
user_Instructions_1	BYTE	"When prompted, enter an integer between 0 and 100.  ",0
user_Instructions_2	BYTE	"If you enter an integer greater than 100 or a non-integer, ", 0
user_Instructions_3	BYTE "the entry will not count.  If you enter a negative number, ",0
user_Instructions_4	BYTE	"no more entries will be collected and the program will print out ", 0
user_Instructions_5	BYTE "the results of your valid entries, including the total number of integers ",0
user_Instructions_6	BYTE "you entered, the sum of your numbers, and the average of your valid entries.",0
user_Prompt_1	BYTE "(Entry ", 0
user_Prompt_2	BYTE ")", 0
user_Prompt_3	BYTE	"  Please enter a number: ",0
user_Entry	DWORD	?, 0
entry_Line_Count	DWORD	0, 0
number_Of_Valid_Ints	DWORD	0, 0
number_Message_1	BYTE	"You entered ",0
number_Message_2	BYTE	" valid entries.", 0
sum_Of_Valid_Ints	DWORD	0,0
sum_Message	BYTE	"The sum of your numbers is ", 0
aver_Of_Valid_Ints	DWORD	?,0
aver_Message	BYTE	"The average of your numbers is ", 0
no_Valid_Ints_Message	BYTE	"You didn't enter any valid numbers.", 0
goodbye_Message_1	BYTE "Thanks for using the Number Summary Program, ", 0
goodbye_Message_2	BYTE	".  Goodbye!",0

.code
main PROC

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
call CrLF

;Display instructions
mov	edx, OFFSET	user_Instructions_1
call	WriteString
call CrLF
mov	edx, OFFSET	user_Instructions_2
call	WriteString
call CrLF
mov	edx, OFFSET	user_Instructions_3
call WriteString
call CrLF
mov	edx, OFFSET	user_Instructions_4
call	WriteString
call CrLF
mov	edx, OFFSET	user_Instructions_5
call	WriteString
call CrLF
mov	edx, OFFSET	user_Instructions_6
call	WriteString
call	CrLF
call CrLF

input:

;Prompt for a number
mov	edx,	OFFSET	user_Prompt_1
call	WriteString
mov	eax, entry_Line_Count
mov	ebx, 1
add	eax, ebx
mov	entry_Line_Count, eax
call	WriteDec
mov	edx, OFFSET	user_Prompt_2
call	WriteString
mov	edx, OFFSET	user_Prompt_3
call	WriteString
call	ReadInt
mov	user_Entry, eax
call	CrLf

;Check which category the user entry falls into: 
mov	eax, user_Entry
CMP	eax, 0
;if the user input is less than 0, jump to the summary
JL	summary
CMP	eax, UPPER_LIMIT
;if the user input is greater than 100, jump back to the input loop without counting the input
JG	input

;If the user input is within the correct range, increment the counter variable and add the value to the sum
;and then go back to the input label in the following sections.  

;add 1 to the number_Of_Valid_Ints
mov	eax, number_Of_Valid_Ints
add	eax, 1
mov	number_Of_Valid_Ints, eax

;add the new value to the sum
mov	eax, sum_Of_Valid_Ints
mov	ebx, user_Entry
add	eax, ebx
mov	sum_Of_Valid_Ints, eax

;jump back up to the input section
jmp	input

summary:
;if no valid integers are added, the result section is skipped.  
mov eax, number_Of_Valid_Ints
CMP eax, 0
JLE no_Valid_Ints

;calculate the average
mov	edx, 0
mov	eax, sum_Of_Valid_Ints
mov	ebx, number_Of_Valid_Ints
div	ebx
mov aver_Of_Valid_Ints, eax

;display the number of nonnegative numbers entered
mov	edx, OFFSET	number_Message_1
call	WriteString
mov	eax, number_Of_Valid_Ints
call	WriteDec
mov	edx, OFFSET	number_Message_2
call	WriteString
call CrLf

;display the sum of the numbers
mov	edx, OFFSET	sum_Message
call WriteString
mov	eax, sum_Of_Valid_Ints
call	WriteDec
call CrLf

;display the average
mov	edx, OFFSET	aver_Message
call	WriteString
mov	eax, aver_Of_Valid_Ints
call WriteDec
call	CrLf
;jump to the parting message
jmp	partingMessage

no_Valid_Ints:
;if no valid integers are added, a message is sent to the user
mov edx, OFFSET	no_Valid_Ints_Message
call WriteString
call CrLf

partingMessage:
;display a parting message
mov	edx, OFFSET	goodbye_Message_1
call WriteString
mov	edx, OFFSET	user_Name
call WriteString
mov	edx, OFFSET	goodbye_Message_2
call	WriteString
call	CrLF

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)
END main
