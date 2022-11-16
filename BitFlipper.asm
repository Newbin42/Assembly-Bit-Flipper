;External Dependencies
include		Irvine32.inc
includelib	Irvine32.lib

;Execution parameters
.386
.model flat, stdcall

.stack 4096

;Prototypes
ExitProcess PROTO, dwExitCode:DWORD

;Data
.data
;Constants
black		=	0
gray		=	8
light_green	=	10
light_cyan	=	11
light_red	=	12
yellow		=	14
white		=	15

;Bit Data
positions		dword	0,1,2,3,4,5,6,7
bitArray		dword	7 dup(0)
bitColors		dword	7 dup(gray)
;ascii 0 - 7 = 48 - 55; x = 120

;Menu
pressMessage	byte	"Press any key between 0, 7 corresponding to the bit you would like to flip",0ah,0dh,"Press x to exit",0ah,0dh,0
entryExample_0	byte	"Press '0' to shift the bit in position 0...",0ah,0dh,0
entryExample_1	byte	"Press '1' to shift the bit in position 1...",0ah,0dh,0
entryExample_2	byte	"Press '2' to shift the bit in position 2...",0ah,0dh,0
entryExample_3	byte	"Press '3' to shift the bit in position 3...",0ah,0dh,0
entryExample_4	byte	"Press '4' to shift the bit in position 4...",0ah,0dh,0
entryExample_5	byte	"Press '5' to shift the bit in position 5...",0ah,0dh,0
entryExample_6	byte	"Press '6' to shift the bit in position 6...",0ah,0dh,0
entryExample_7	byte	"Press '7' to shift the bit in position 7...",0ah,0dh,0
InputQuery		byte	">>",0	

;Color Codes
pattern			byte	light_cyan,light_green,light_red,yellow,white
patternPointer	dword	0

;User Input Storage
input			byte	?

;Array Indexng
offset_			dword	0

.code
main proc
	menu:
		;Draw Bits
		call DrawBits

		call Newline

		;Draw Menu
		call OutputMenu

		;Wait for keyboard press
		call WaitForKeyPress

		call Newline

		movzx eax, input
		cmp eax, 120
		je Done

		notDone:
			;Update Color
			call UpdateColor

			;Refresh
			call Clrscr
			jmp menu

	Done:
		call WaitMsg
		invoke ExitProcess, 0

main endp

DrawBits proc uses eax ecx
	mov ecx, lengthof positions
	mov offset_, 0
	drawPositions:
		mov eax, offset_
		mov eax, [positions + (eax * type positions)]
		call WriteDec

		mov eax, offset_
		inc eax
		mov offset_, eax

	loop drawPositions

	call Newline

	mov ecx, lengthof bitArray
	mov offset_, 0
	drawBitArray:
		mov eax, [pattern + patternPointer * type pattern]
		mov eax, black + (eax * 16)
		call SetTextColor

		mov eax, offset_
		mov eax, [bitArray + (eax* type bitArray)]
		call WriteDec

		mov eax, offset_
		inc eax
		mov offset_, eax

	loop drawBitArray

	mov eax, black + (gray * 16)
	call SetTextColor

	ret

drawBits endp

OutputMenu proc uses edx
	mov edx, offset pressMessage
	call WriteString

	mov edx, offset entryExample_0
	call WriteString

	mov edx, offset entryExample_1
	call WriteString

	mov edx, offset entryExample_2
	call WriteString

	mov edx, offset entryExample_3
	call WriteString

	mov edx, offset entryExample_4
	call WriteString

	mov edx, offset entryExample_5
	call WriteString

	mov edx, offset entryExample_6
	call WriteString

	mov edx, offset entryExample_7
	call WriteString

	ret

outputMenu endp

WaitForKeyPress proc uses edx eax
	mov edx, offset InputQuery
	call WriteString

	call ReadChar
	mov input, al

	movzx eax, input
	call WriteDec

	ret

waitForKeyPress endp

UpdateColor proc uses eax
	mov eax, patternPointer
	test eax, lengthof pattern - 1

	jz increment
	
	reset:
		mov patternPointer, 0

		jmp done

	increment:
		inc eax
		mov patternPointer, eax

	done:
		mov eax, input


		ret

UpdateColor endp

Newline proc uses eax
	;Carriage return
	mov AL, 0dh
	call WriteChar

	;Newline
	mov AL, 0ah
	call WriteChar

	ret
newline endp

end main