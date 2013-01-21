.code16
.section .text
.global _start
_start:

push %cs
pop %ds
push %cs
pop %es
cld

mov $25, %cx
mov $starlist, %di
0:
rdtsc
xchg %ax, %si
xor %si, %ax
rol $7, %si
stosw
loop 0b

# 320x200x256
mov $0x13, %ax
int $0x10

push $0xa000
pop %es

push $4  # hor
push %es # phase, as long as it's not 0, used in neg %ax, upon which CF is checked

mov $(320*2), %bp
nyan:
xor %di, %di # virtualbox workaround bug
# paint background
mov $126, %ax
xor %cx, %cx
dec %cx
rep stosb

mov $(64*320), %di

mov $5, %cl
rainbow:
push %di
add %bp, %di
neg %bp
# 1 gradient strip
push %cx
mov $5, %cl
mov $40, %al
0:
mov $24, %bx
mov $12, %dx
call rect
add $4, %al
loop 0b
pop %cx
#
pop %di
add $24, %di
loop rainbow

add %bp, %di
push %di

mov $25, %cl
mov $starlist, %bx
starloop:
subw $4, (%bx)
mov (%bx), %di
cmpb $(0x28), (%bx)
ja 2f
mov $star1, %si
jp 1f
mov $star2, %si
1:
push %bx
call xsquares
pop %bx
2:
inc %bx
inc %bx
loop starloop

#
# tail
#

mov $3, %cl
mov $(92*320+100), %di
0:
mov $12, %bx
xor %ax, %ax
call square
add $(320*-8+4), %di
mov $25, %al
mov $4, %dl
call rect
add $(320*-8+-16), %di
sub %bp, %di
sub %bp, %di
loop 0b
pop %di

mov $data, %si

#
# sammish
#


call xslantedrect
call double_xslantedrect

pop %ax
pop %dx
neg %ax
jns hop
neg %bp
neg %dx
hop:
neg %bp
push %dx
push %ax
sub %dx, %di

#
# catface
#
add $(320*24+44), %di

call double_xslantedrect

mov $5, %cl
0:
call xsquares
loop 0b

#
# feet
#

add $(320*8-72), %di
call foot
add $20, %di
call foot
add $36, %di
call foot
add $24, %di
call foot


# ax not signed? probably
# cx=0
cwd
inc %cx
mov $0x86, %ah
int $0x15

#mov $(0x3da), %dx
#wait_for_retrace_end:
#in %dx, %ax
#test $8, %al
#jz wait_for_retrace_end
#wait_for_retrace_start:
#in %dx, %ax
#test $8, %al
#jnz wait_for_retrace_start
jmp nyan

xsquares:
lodsb
xchg %ax, %bx
lodsb
0:
xchg %ax, %dx
lodsb
cmp $4, %al
je some_ret
call load_coord_jump
xchg %ax, %dx
call square
jmp 0b

square:
mov %bx, %dx
rect:
push %cx
0:
push %di
mov %bx, %cx
rep stosb
pop %di
addw $320, %di
dec %dx
jne 0b
pop %cx
some_ret:
ret

double_xslantedrect:
call xslantedrect

xslantedrect:
lodsb
call load_coord_jump
push %di
xor %ax, %ax
lodsb
xchg %ax, %cx
lodsb
xchg %ax, %bx
lodsb
xchg %ax, %dx
lodsb
0:
pusha
call rect
popa
sub $8, %dl
add $8, %bl
add $(320*4-4), %di
loop 0b
pop %di
ret

load_coord_jump: # byte -> ( x:[-10..21], y:[-4..3] ) -> x*4 + y*1280
xor %ah, %ah
shl $2, %ax
add %ax, %di
shr $7, %ax
imul $1152, %ax, %ax
add $-5160, %ax
add %ax, %di
ret

foot:
pusha
call double_xslantedrect
popa
ret

data:
.byte  106
.byte 3,72,72,0

.byte  170
.byte 2,72,64,89

.byte  172
.byte 3,56,56,60

.byte  138
.byte 4,40,40,0

.byte  170
.byte 3,40,32,25

.byte 16,25
.byte  40, 20, 4

.byte 8,65
.byte  225, 85, 4

.byte 8,0
.byte  1, 81, 4

.byte 4,15
.byte  67, 113, 4

.byte 4,0
.byte  32, 74, 74, 74, 75, 107, 139, 138, 113, 74, 75, 107, 139, 138, 138, 138, 197, 166, 138, 107, 107, 107, 107, 107, 107, 74, 103, 4

feet:
.byte  138
.byte 2,8,12,0

.byte  170
.byte 1,8,4,25

star1:
.byte 4, 15
.byte 138, 10, 138, 167, 107, 110, 107, 167, 138 # 4
star2:
.byte 4, 15
.byte 42, 140, 171, 169, 136, 72, 41, 43, 4

starlist:

