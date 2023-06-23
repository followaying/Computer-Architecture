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
duplication: .asciiz "Error: DUPLICATION!"
outofrange: .asciiz "Error: OUTOFRANAGE!"
arrayX: .word 40
arrayO: .word 40
.text
li $v0,4		
la $a0,text
syscall	
################### CHOOSE THE SIGN ##################
li $v0, 5								#CIN>> 1 or 2 (X or O)
syscall
move $t0,$v0					#t0 = sign (X/O)
beq $t0,1,X					#if you choose X, junb X
beq $t0,2,O					#if you choose O, junb O
j Outofrange					#if you choose a number different 1,2, print "Error: OUTOFRANAGE!"
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
	addi $t6,$zero,0			#t6 = countX (0, 4, 8 ...)
	addi $t7,$zero,0			#t7 = countO (0, 4, 8 ...)
	addi $t8,$zero,0			#t8 = count of play time (0, 4, 8 ...)
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
	 	beq $t8,0,next
Duplication:	la $t2,string			
		add $t5,$t2,$zero
		mul $t3,$t1,4
		add $t5,$t5,$t3	
		lw $t5,($t5)	
		addi $t9,$zero,'X'
		beq $t5,$t9,ErrorDuplication
		addi $t9,$zero,'O'
		beq $t9,$t5,ErrorDuplication
next:		addi $t8,$t8,4			#t8+=4
		beq $t0,1,Xturn			#if (you are X) jumb Xturn
		bge $t7,8,checkO			#else is O turn: {if (arrayO.size >=2) jumb CheckO // if arrayO had >=2 elements
		j PutO					#else jumb putO	//insert the newest number in array O}				
Xturn:	bge $t6,8,checkX			#if (arrayX.size >=2) jumb CheckX // if arrayX had >=2 elements
	j PutX					#else jumb putX	//insert the newest number in array O
#To check win or not 	
checkX:	move $t3,$t6				#t3 = countX
	la $t9,arrayX
	add $t4,$t9,$zero
	j check					#jumb check
checkO:	move $t3,$t7				#t3 = countO
	la $t9,arrayO
	add $t4,$t9,$zero
	j check					#jumb check
#Input newest value in array
back:	beq $t0,1,PutX				#if (t0== 1) jumb putX
	j PutO					#else jumb putO
#check the first number (newest number)		(pN: we have number N to win --> continue check in array)
check:	addi $t5,$zero,0			#t5 = 0
	beq $t1,0,p0				#if (t1 == 0) jumb p0
	beq $t1,1,p1				#if (t1 == 1) jumb p1
	beq $t1,2,p2				#if (t1 == 2) jumb p2
	beq $t1,3,p3				#if (t1 == 3) jumb p3
	beq $t1,4,p4				#if (t1 == 4) jumb p4
	beq $t1,5,p5				#if (t1 == 5) jumb p5
	beq $t1,6,p6				#if (t1 == 6) jumb p6
	beq $t1,7,p7				#if (t1 == 7) jumb p7
	j p8					#else jumb p8 (No case to win)
#check the second number			(pNM: we have number N and M to win)
p0:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,1,p01				#if (t2 == 1) jumb p01
	beq $t2,2,p02				#if (t2 == 2) jumb p02
	beq $t2,3,p03				#if (t2 == 3) jumb p03
	beq $t2,4,p04				#if (t2 == 4) jumb p04
	beq $t2,6,p06				#if (t2 == 6) jumb p06
	beq $t2,8,p08				#if (t2 == 8) jumb p08
	addi $t5,$t5,4				#else t2 = array[i+1]
	bne $t5,$t3,p0				#if (t2!= t3) jumb p0 //check the next number in array 
	j back					#else jumb back // wiht the newest value, can't win
p1:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,p01				
	beq $t2,2,p12
	beq $t2,4,p14
	beq $t2,7,p17
	addi $t5,$t5,4				
	bne $t5,$t3,p1				
	j back
p2:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,p02
	beq $t2,1,p12
	beq $t2,4,p24
	beq $t2,5,p25
	beq $t2,6,p26
	beq $t2,8,p28
	addi $t5,$t5,4				
	bne $t5,$t3,p2				
	j back
p3:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,p03
	beq $t2,4,p34
	beq $t2,6,p36
	beq $t2,5,p35
	addi $t5,$t5,4				
	bne $t5,$t3,p3				
	j back
p4:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,p04
	beq $t2,1,p14
	beq $t2,2,p24
	beq $t2,3,p34
	beq $t2,5,p45
	beq $t2,6,p46
	beq $t2,7,p47
	beq $t2,8,p48
	addi $t5,$t5,4				
	bne $t5,$t3,p4				
	j back
p5:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,2,p25
	beq $t2,3,p35
	beq $t2,4,p45
	beq $t2,8,p58
	addi $t5,$t5,4				
	bne $t5,$t3,p5				
	j back
p6:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,p06
	beq $t2,2,p26
	beq $t2,3,p36
	beq $t2,4,p46
	beq $t2,7,p67
	beq $t2,8,p68
	addi $t5,$t5,4				
	bne $t5,$t3,p6				
	j back
p7:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,1,p17
	beq $t2,4,p47
	beq $t2,6,p67
	beq $t2,8,p78
	addi $t5,$t5,4				
	bne $t5,$t3,p7				
	j back
p8:	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,p08
	beq $t2,2,p28
	beq $t2,4,p48
	beq $t2,5,p58
	beq $t2,6,p68
	beq $t2,7,p78
	addi $t5,$t5,4				
	bne $t5,$t3,p8				
	j back
#Check the third number				(pNM: we have number N and M to win)
#win firt row 0|1|2
p01:	addi $t5,$t5,4				#t2 = array[i+1]
	beq $t5,$t3,back			#if (t2 == t3) jumb back //there is no number to check
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,2,Exit				#if (t2 == 2) jumb Exit //wint
	j p01					#else juum p01 // to check the next number in array
p12:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,Exit
	j p12
p02:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,1,Exit
	j p02
#win second row 3|4|5
p34:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,5,Exit	
	j p34
p45:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,3,Exit
	j p45
	
p35:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,4,Exit
	j p35
#win third row 6|7|8
p67:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,8,Exit	
	j p67
p78:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,6,Exit
	j p78
p68:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,7,Exit
	j p68
#win firt collum 0|3|6
p03:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,6,Exit	
	j p03
p36:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,Exit
	j p36
p06:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,3,Exit
	j p06
#win second collum 1|4|7
p14:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,7,Exit	
	j p14
p47:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,1,Exit
	j p47
p17:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,4,Exit
	j p17
#win third collum 2|5|8
p25:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,8,Exit	
	j p25
p58:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,2,Exit
	j p58
p28:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,5,Exit
	j p28
#win  0|4|8
p04:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,8,Exit	
	j p04
p48:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,0,Exit
	j p48
p08:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,4,Exit
	j p08
#win 2|4|6
p24:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,6,Exit	
	j p24
p46:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,2,Exit
	j p46
p26:	addi $t5,$t5,4
	beq $t5,$t3,back			
	add $t2,$t4,$t5				#t2 = arrayX[t5]
	lw $t2,($t2)
	beq $t2,4,Exit
	j p26
#Input newest number in arrayX/arrayO (if X/O turn)
PutX:	la $t2,arrayX		# t2= arrayX
	add $t5,$t2,$zero	#t5= arrayX[0]
	add $t5,$t5,$t6		
	sw $t1,($t5)		#save
	addi $t6,$t6,4		#t6+=4 (countX++)
	addi $t0,$t0,1		#t0 = 2 (next turn is O)	
	j Replace		#jumb Replace
PutO:	la $t2,arrayO		# t2= arrayO
	add $t5,$t2,$zero	#t5= arrayO[0]
	add $t5,$t5,$t7		
	sw $t1,($t5)
	addi $t7,$t7,4		#t7+=4 (countO++)
	subi $t0,$t0,1		#t0 = 1 (next turn is O)
	j Replace		#jumb Replace
###################### Replace #######################
Replace:#replace the newest location by 'X' or 'O'
	beq $t0,1,insertO	#if the next turn is X, replace 'O' at newest index in string 
	la $t2,string		#else replace 'X' at newest index in string 	#t2 = string
	add $t5,$t2,$zero	#t5= string[0]
	mul $t1,$t1,4		
	add $t5,$t5,$t1		#t5 = string[t1]
	addi $t9,$zero,'X'	#t9 = 'X'
	sw $t9,($t5)		#string[t1] = 'X'
	j Print			#jumb Print
insertO:la $t2,string		#t2 = string
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
	beq $t8,36,stop		#if is the nineth play time, stop game
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
ErrorDuplication:
	li $v0,4							#PRINT: "Error: DUPLICATION!"
	la $a0,duplication
	syscall
	j exit			#End game
Outofrange:li $v0,4							#PRINT: "Error: OUTOFRANGE!"
	la $a0,outofrange
	syscall
	j exit			#End game
stop:	li $v0,4							#PRINT: "draw"
	la $a0,draw
	syscall
	j exit			#End game
Exit:	li $v0,4							#PRINT: "You Win"
	la $a0,win
	syscall
exit:				#End game
