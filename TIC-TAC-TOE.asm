.data
text: .asciiz "Tic-Tac-Toe game\nWelcome you and your friend to this game\nPlease choose the sign: \n1.X\n2.O\n"
textChooseX: .asciiz "You are X and your friend is O\n"
textChooseO: .asciiz "You are O and your friend is X\n"
textStart: .asciiz "Let's play now!\nX first!\n"
ChooseLocation: .asciiz "Please choose your location you want (from 0 to 8):"
textbase: .asciiz "|0|1|2|\n|3|4|5|\n|6|7|8|\n"
textnextX: .asciiz "The next turn is X turn\n"
textnextO: .asciiz "The next turn is O turn\n"
string: .word '0','1','2','3','4','5','6','7','8'
tex: .asciiz "|\n"
te: .asciiz "|"
win: .asciiz "You Win"
draw: .asciiz "Draw"
outofrange: .asciiz "Error: OUTOFRANAGE!\nPlease input another number."
duplication: .asciiz "Error: DUPLICATION!\nPlease input another number: "
.text
li $v0,4		
la $a0,text
syscall	
addi $s0,$zero,0	#space 0
addi $s1,$zero,0	#space 1
addi $s2,$zero,0	#space 2
addi $s3,$zero,0	#space 3
addi $s4,$zero,0	#space 4
addi $s5,$zero,0	#space 5
addi $s6,$zero,0	#space 6
addi $s7,$zero,0	#space 7
addi $t8,$zero,0	#space 8
################### CHOOSE THE SIGN ##################
Choose:
li $v0, 5								#CIN>> 1 or 2 (X or O)
syscall
move $t0,$v0					#t0 = sign (X/O)
beq $t0,1,X					#if you choose X, junb X
beq $t0,2,O					#if you choose O, junb O
j Notallow					#if you choose a number different 1,2, print "Error: OUTOFRANAGE!"
O:	li $v0,4				#if you choose O	#PRINT: "YYou are O and your friend is X\n"
	la $a0,textChooseO						
	syscall
	j Play						#jumb PLAY
X:	li $v0,4				#if you choose X	PRINT: "YYou are X and your friend is O\n"
	la $a0,textChooseX
	syscall
######################## PLAY ########################	
Play:	li $v0,4							#PRINT: "Let's play now!\nX first\n"
	la $a0,textStart 
	syscall				
	addi $t7,$zero,0			#t7 = count (<=9)
	li $v0,4							#PRINT: "|0|1|2|\n|3|4|5|\n|6|7|8|\n"
	la $a0,textbase 
	syscall	
#choose wanted location
Location:	addi $t1,$zero,0
		li $v0,4						#PRINT: "Please choose your location you want (from 0 to 8):  "
		la $a0,ChooseLocation
		syscall
		li $v0, 5						#CIN: wanted lcation/ newest number/ input number from player
		syscall
		move $t1,$v0			#t1 = wanted location/ newest number/ input number from player
		bgt $t1,8,Outofrange		#if you choose a number greater than 8, print "Error: OUTOFRANAGE!"
		blt $t1,0,Outofrange		#else if you choose a number less than 0, print "Error: OUTOFRANAGE!"
#check duplication: in t1 index, if string[t1] == 'X' or 'O' --> Duplication 			
	 	beq $t7,0,next
Duplication:	la $t2,string			
		add $t5,$t2,$zero
		mul $t3,$t1,4
		add $t5,$t5,$t3	
		lw $t5,($t5)	
		addi $t9,$zero,'X'
		beq $t5,$t9,ErrorDuplication
		addi $t9,$zero,'O'
		beq $t9,$t5,ErrorDuplication
next:		addi $t7,$t7,1			#t7+=1
		beq $t0,1,Xturn	
		j Oturn
# CHECK X	
Xturn: beq $t1,0,p0				#if (t1 == 0) jumb p0
	beq $t1,1,p1				#if (t1 == 1) jumb p1
	beq $t1,2,p2				#if (t1 == 2) jumb p2
	beq $t1,3,p3				#if (t1 == 3) jumb p3
	beq $t1,4,p4				#if (t1 == 4) jumb p4
	beq $t1,5,p5				#if (t1 == 5) jumb p5
	beq $t1,6,p6				#if (t1 == 6) jumb p6
	beq $t1,7,p7				#if (t1 == 7) jumb p7
	j p8
p0: addi $s0,$zero,1	
	add $t2,$s1,$s2
	beq $t2,2,Exis
	add $t2,$s3,$s6
	beq $t2,2,Exis
	add $t2,$s4,$t8
	beq $t2,2,Exis
	j Replace
p1: addi $s1,$zero,1
	add $t2,$s0,$s2
	beq $t2,2,Exis
	add $t2,$s4,$s7
	beq $t2,2,Exis
	j Replace
p2: addi $s2,$zero,1	
	add $t2,$s0,$s1
	beq $t2,2,Exis
	add $t2,$s4,$s6
	beq $t2,2,Exis
	add $t2,$s5,$t8
	beq $t2,2,Exis
	j Replace
p3: addi $s3,$zero,1
	add $t2,$s0,$s6
	beq $t2,2,Exis
	add $t2,$s4,$s5
	beq $t2,2,Exis
	j Replace	
p4: addi $s4,$zero,1
	add $t2,$s0,$t8
	beq $t2,2,Exis
	add $t2,$s1,$s7
	beq $t2,2,Exis
	add $t2,$s2,$s6
	beq $t2,2,Exis
	add $t2,$s3,$s5
	beq $t2,2,Exis
	j Replace	
p5: addi $s5,$zero,1	
	add $t2,$s2,$t8
	beq $t2,2,Exis
	add $t2,$s3,$s4
	beq $t2,2,Exis
	j Replace
p6: addi $s6,$zero,1
	add $t2,$s0,$s3
	beq $t2,2,Exis
	add $t2,$s2,$s4
	beq $t2,2,Exis
	add $t2,$s7,$t8
	beq $t2,2,Exis
	j Replace
p7: addi $s7,$zero,1	
	add $t2,$s1,$s4
	beq $t2,2,Exis
	add $t2,$s6,$t8
	beq $t2,2,Exis
	j Replace
p8: addi $t8,$zero,1
	add $t2,$s0,$s4
	beq $t2,2,Exis
	add $t2,$s2,$s5
	beq $t2,2,Exis
	add $t2,$s6,$s7
	beq $t2,2,Exis
	j Replace

#CHECK O	
Oturn: beq $t1,0,P0				#if (t1 == 0) jumb P0
	beq $t1,1,P1				#if (t1 == 1) jumb P1
	beq $t1,2,P2				#if (t1 == 2) jumb P2
	beq $t1,3,P3				#if (t1 == 3) jumb P3
	beq $t1,4,P4				#if (t1 == 4) jumb P4
	beq $t1,5,P5				#if (t1 == 5) jumb P5
	beq $t1,6,P6				#if (t1 == 6) jumb P6
	beq $t1,7,P7				#if (t1 == 7) jumb P7
	j P8
P0: addi $s0,$zero,4	
	add $t2,$s1,$s2
	beq $t2,8,Exis
	add $t2,$s3,$s6
	beq $t2,8,Exis
	add $t2,$s4,$t8
	beq $t2,8,Exis
	j Replace
P1: addi $s1,$zero,4
	add $t2,$s0,$s2
	beq $t2,8,Exis
	add $t2,$s4,$s7
	beq $t2,8,Exis
	j Replace
P2: addi $s2,$zero,4	
	add $t2,$s0,$s1
	beq $t2,8,Exis
	add $t2,$s4,$s6
	beq $t2,8,Exis
	add $t2,$s5,$t8
	beq $t2,8,Exis
	j Replace
P3: addi $s3,$zero,4
	add $t2,$s0,$s6
	beq $t2,8,Exis
	add $t2,$s4,$s5
	beq $t2,8,Exis
	j Replace	
P4: addi $s4,$zero,4
	add $t2,$s0,$t8
	beq $t2,8,Exis
	add $t2,$s1,$s7
	beq $t2,8,Exis
	add $t2,$s2,$s6
	beq $t2,8,Exis
	add $t2,$s3,$s5
	beq $t2,8,Exis
	j Replace	
P5: addi $s5,$zero,4	
	add $t2,$s2,$t8
	beq $t2,8,Exis
	add $t2,$s3,$s4
	beq $t2,8,Exis
	j Replace
P6: addi $s6,$zero,4
	add $t2,$s0,$s3
	beq $t2,8,Exis
	add $t2,$s2,$s4
	beq $t2,8,Exis
	add $t2,$s7,$t8
	beq $t2,8,Exis
	j Replace
P7: addi $s7,$zero,4	
	add $t2,$s1,$s4
	beq $t2,8,Exis
	add $t2,$s6,$t8
	beq $t2,8,Exis
	j Replace
P8: addi $t8,$zero,4
	add $t2,$s0,$s4
	beq $t2,8,Exis
	add $t2,$s2,$s5
	beq $t2,8,Exis
	add $t2,$s6,$s7
	beq $t2,8,Exis
	j Replace
###################### Replace #######################
Replace:#replace the newest location by 'X' or 'O'
	beq $t0,2,insertO	#if the next turn is X, replace 'O' at newest index in string 
	addi $t0,$t0,1
	la $t2,string		#else replace 'X' at newest index in string 	#t2 = string
	add $t5,$t2,$zero	#t5= string[0]
	mul $t1,$t1,4		
	add $t5,$t5,$t1		#t5 = string[t1]
	addi $t9,$zero,'X'	#t9 = 'X'
	sw $t9,($t5)		#string[t1] = 'X'
	j Print			#jumb Print
insertO:subi $t0,$t0,1
	la $t2,string		#t2 = string
	add $t5,$t2,$zero	#t5= string[0]
	mul $t1,$t1,4
	add $t5,$t5,$t1		#t5 = string[t1]
	addi $t9,$zero,'O'	#t9 = 'X'
	sw $t9,($t5)		#string[t1] = 'X'
	j Print			#jumb Print
######################## PRINT #######################
Print:	addi $t5, $zero,0	#t5 = 0 
while:	lw $t2,string($t5)	#t2 = string[t5]
	li $v0,4							#PRINT: "|"
	la $a0,te								
	syscall	
	li $v0,11							#PRINT: string[t5]
	move $a0,$t2		
	syscall
	addi $t5,$t5,4		#t5 += 4
	addi $t4,$zero,3	#t4 =3
	div $t5,$t4		#t4 = t5%t4
	mfhi $t4
	beq $t4,0,jumb		#if t3 (t5 % t3) jumb jumb // if end a row, print "|\n"
	bne $t5,36,while	#else if t5 != 36 jumb while 
	j Location		#else jumb Location // countinue play )(next turn)
jumb:	li $v0,4							#PRINT: "|\n"		
	la $a0,tex
	syscall	
	bne $t5,36,while	#if (t5!=36) jumb while// if not end table, countinue print the next row
	beq $t7,9,stop		#if is the nineth play time, stop game
	beq $t0,2 nextO		#else if (t0 =2) jumb nextO (if the next turn is O turn, jumb to nextO)
	li $v0,4		#else 					#PRINT: "The next turn is X turn\n"
	la $a0,textnextX
	syscall	
	addi $t2,$zero,0	#t2 = 0 //to reset t2 prepare next turn
	j Location		#jumb Location
nextO:	li $v0,4							#PRINT: "The next turn is O turn\n"
	la $a0,textnextO
	syscall
	addi $t2,$zero,0	#t2 = 0 //to reset t2 prepare next turn
	j Location		#jumb Location
Notallow:li $v0,4							#"Error: OUTOFRANAGE!\nPlease input another number: "
	la $a0,outofrange
	syscall
	j Choose
Outofrange:li $v0,4							#"Error: OUTOFRANAGE!\nPlease input another number: "
	la $a0,outofrange
	syscall
	j Location			
ErrorDuplication:
	li $v0,4							#"Error: DUPLICATION!\nPlease input another number: "
	la $a0,duplication
	syscall
	j Location			
stop:	li $v0,4							#PRINT: "draw"
	la $a0,draw
	syscall
	j exit			
Exis:	li $v0,4							#PRINT: "You Win"
	la $a0,win
	syscall
exit:				#End game
