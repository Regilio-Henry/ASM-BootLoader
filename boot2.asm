; Second stage of the boot loader

BITS 16

ORG 9000h
	jmp 	Second_Stage

%include "functions_16.asm"
%include "floppy16.asm"
%include "fat12.asm"
%include "a20.asm"
%include "bpb.asm"

;	Start of the second stage of the boot loader	
Second_Stage:
    mov 	si, second_stage_msg	; Output our boot loader is running
    call 	Console_WriteLine_16 ;Console_WriteLine_16
	
	call	Enable_A20
	
	push 	dx						; Save the number containing the mechanism used to enable A20
	mov		si, dx					; Display the appropriate message that indicates how the A20 line was enabled
	add		si, dx
	mov		si, [si + a20_message_list]
	call	Console_WriteLine_16
	pop		dx						; Retrieve the number
	
	Clear_Registers:
	xor     cx, cx					;clear cx register
	xor     ax, ax					;clear ax register
	xor     bx, bx					;clear bx register
	xor		dx, dx					;clear dx register
	
	Sector_NumberInput:	
	mov 	si, userinput1_msg		; Output our userInput message
	call 	Console_Write_CRLF
    call 	Console_WriteLine
	
	Read_Input:
	
	Wait_Input:
	xor ah, ah						;clear ah
	int 16h							;get input
	
	End_Input:
	cmp al, 0dh						;check for enter
	je	Read_Sectors	
	
	CheckForNumber:						; error checking
	cmp		al, '0'						; check our input is above zero
	jb		Wait_Input
	cmp		al, '9'						; check our input is below nine
	ja		Wait_Input
	mov		ah, 0Eh						; print the input to the screen
	
	PutNumber:
	mov ah, 0eh							;shift out
	int 10h
	
	xor ah, ah							;stop reading
	sub al, 30h							;convert the ascii value
	
	cmp cx, 0							;check 	
	jg  Convert_Digit					;if it's a number convert
	
	inc cx			
	push ax
	xor ax, ax							;clear 
	jmp Read_Input						;if no key was pressed loop back 
	
	Convert_Digit:
	pop     	ax
	push		ax						;push ax to keep it clean
	mov		ax, cx						
	push		cx						;push cx to keep it clean
	mov		cx, 10						;multiply cx by 10
	mul		cx							;first input will result in zero for cx
	pop		cx
	mov		cx, ax						;get multiplication result
	pop		ax							
	sub		al, 30h						;convert al register from the ascii value
	mov		ah, 0						;add al to the cx register, so we must clear ah to only add the part we want
	add		cx, ax						
	mov		ax, cx
	push		ax
	
	Read_Sectors:
	pop 	ax				 	 ;starting sector

	Sector_Range:
	mov		cx,  1 				     ;amount of sectors we want to read
	mov     bx, 0D000h			 ;set buffer to read to
	call	ReadSectors 
	xor     dx, dx
	mov     dl, [0d000h]
	mov 	si, 0D000h			 ;set SI to location in memory
	
	Sector_scroll:
	mov		cx,16							 ;the counter for the sector loop
	call 	Console_Write_CRLF
	
	Sector_Print_16:	
	push	cx
											 ;set offset vallue
	
	Sector_Offset:							 ;the offset into the sector
	mov 	dx, si							 ;move current offset si position into dx
	sub     dx, 0d000h						 ;get current offset by substracting the memory location
	push 	si								 ;keep current si position
	mov		bx,dx							 ;prepare for printing
	push 	si
	push 	cx								
	call	Console_Write_Hex				 ;print sector offset
	pop		cx
	pop		si
	call	Console_Write_Space
	push	cx					
	
	mov cx, 16			
	
	Sector_BytesDisplay:						 ;print the byte pairs
	mov 	bx, [si]						 ;get current byte in si
	push    cx
	push	si
	call	Console_Write_Hex_Bytes			 ;print bytes at current position in hex
	pop		si
	pop     cx
	inc 	si								 ;move to next byte
	call	Console_Write_Space
	loop 	Sector_BytesDisplay				 
	pop		cx
	pop     si
	
	mov	    cx,16
		
	Sector_AsciiDisplay:							 ;print the ascii characters for the sector
	push 	si	
	call	Console_Write					 ;print bytes at current position in ascii
	pop 	si
	inc 	si								 ;move to next byte
	loop 	Sector_AsciiDisplay					
	call 	Console_Write_CRLF
	
	pop		cx	

	loop	Sector_Print_16
	push	si
	mov 	si, userinput2_msg		; Output our userInput message
    call 	Console_WriteLine
	pop		si
	
	continue:
	mov 	ah, 00h 			
	int 	16h					;get keystroke into al
	cmp 	al, 0 				;check if any key has been pressed 
	jz 		continue 			;key detection loop
	

	cmp     dx, 1f0h
	jge		finished_sector
	
	jmp		Sector_scroll
	
	finished_sector:
	call 	Console_Write_CRLF
	mov 	si, userinput3_msg		; Output our userInput message
    call 	Console_WriteLine
	jmp		Sector_NumberInput
	
	hlt
	
%include "messages.asm"
	
times 3584-($-$$) db 0	