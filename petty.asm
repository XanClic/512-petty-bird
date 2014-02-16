use16

org 0x7c00


DISTANCE = 56
POLE_WIDTH = 20
GAP_HEIGHT = 35


mov     ax,0x13
int     0x10


mov     ax,0xa000
mov     ds,ax
mov     es,ax

out     0x70,al
in      al,0x70
mov     [cs:random],al

xor     bp,bp

main_loop:
inc     bp
mov     cx,200
mov     di,1
draw_pole_loop:
add     di,319
cmp     bp,POLE_WIDTH
ja      no_pole
mov     ax,cx
mov     dl,[cs:random]
and     dx,0x7f
sub     ax,dx
js      is_pole
cmp     ax,GAP_HEIGHT
jae     is_pole
no_pole:
xor     al,al
jmp     draw_bg
is_pole:
mov     al,47
draw_bg:
stosb
loop    draw_pole_loop
cmp     bp,DISTANCE
jb      not_next
sub     bp,DISTANCE
mov     al,[cs:random]
mov     dl,al
shl     dl,7
xor     al,dl
mov     dl,al
shr     dl,5
xor     al,dl
mov     dl,al
shl     dl,3
xor     al,dl
mov     [cs:random],al
not_next:

mov     ah,1
int     0x16
mov     ax,[cs:y_pos]

jnz     flap
inc     word [cs:y_speed]
add     ax,[cs:y_speed]
jmp     draw_bird

flap:
push    ax
xor     ah,ah
int     0x16
pop     ax
mov     word [cs:y_speed],0xfffa
add     ax,0xfffa

draw_bird:
cmp     ax,200
jae     crash

mov     [cs:y_pos],ax
mov     cx,320
mul     cx

add     ax,42
mov     di,ax
cmp     byte [di],0
jne     crash
mov     byte [di],44

mov     si,1
xor     di,di
mov     cx,320*200
rep     movsb

hlt
jmp main_loop

crash:
hlt
jmp     crash


y_pos dw 100
y_speed dw 0

times 510-($-$$) db 0
dw 0xaa55

random:
