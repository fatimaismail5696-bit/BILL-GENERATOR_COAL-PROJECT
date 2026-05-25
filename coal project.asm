.model small
.stack 100h

.data

menu db 10,13,"***** FRIENDS CAFE ****",10,13
     db "1. Parmesan Chicken    1000",10,13
     db "2. Chicken Alfredo     850",10,13
     db "3. Mac N Cheese        1200",10,13
     db "4. Club Sandwich       750",10,13
     db "5. Stuffed Chicken     1300",10,13
     db "6. Cold Coffee         450",10,13
     db "7. Honey Wings         500",10,13,'$'

ask_name db 10,13,"Enter Customer Name: $"
inv_msg db 10,13,"Invoice #: 1001",10,13,'$'

msg1 db 10,13,"Select Item (1-7): $"
msg2 db 10,13,"Quantity: $"
msg3 db 10,13,"More? (Y/N): $"

bill db 10,13,"***** FINAL BILL *****",10,13
     db "Item              Qty     Price",10,13
     db "--------------------------------",10,13,'$'

total_msg db 10,13,"--------------------------------",10,13,"TOTAL = $"
invalid db 10,13,"Invalid Selection!",10,13,'$'

; ITEMS
item1 db "Parmesan Chicken      $"
item2 db "Chicken Alfredo       $"
item3 db "Mac N Cheese          $"
item4 db "Club Sandwich         $"
item5 db "Stuffed Chicken       $"
item6 db "Cold Coffee           $"
item7 db "Honey Wings           $"

prices dw 1000,850,1200,750,1300,450,500

item_id dw 20 dup(0)
item_qty dw 20 dup(0)
item_price dw 20 dup(0)

count dw 0
total dw 0

cust db 20,?,20 dup('$')

.code

main proc
    mov ax,@data
    mov ds,ax

    lea dx,menu
    mov ah,9
    int 21h

; NAME
    lea dx,ask_name
    mov ah,9
    int 21h

    lea dx,cust
    mov ah,0Ah
    int 21h

; INVOICE
    lea dx,inv_msg
    mov ah,9
    int 21h

start:

; ITEM INPUT
    lea dx,msg1
    mov ah,9
    int 21h

    mov ah,1
    int 21h
    sub al,'0'
    mov bl,al

    cmp bl,1
    jb bad
    cmp bl,7
    ja bad

    mov bh,0
    mov bp,bx        ; SAFE STORE ORIGINAL ITEM NO

    dec bx
    shl bx,1
    mov si,bx

    mov ax,prices[si]
    push ax

; QUANTITY
    lea dx,msg2
    mov ah,9
    int 21h

    mov ah,1
    int 21h
    sub al,'0'
    mov cl,al

    pop ax
    xor ch,ch
    mul cx

; STORE DATA
    mov di,count
    shl di,1

    mov item_price[di],ax
    mov item_qty[di],cx
    mov item_id[di],bp

    add total,ax
    inc count

; MORE?
    lea dx,msg3
    mov ah,9
    int 21h

    mov ah,1
    int 21h

    cmp al,'Y'
    je start
    cmp al,'y'
    je start

; ? ONE LINE SPACE AFTER PRESSING N/n
    mov dl,10
    mov ah,2
    int 21h

; PRINT BILL
print_bill:

    lea dx,bill
    mov ah,9
    int 21h

    lea dx,cust+2
    mov ah,9
    int 21h

    mov cx,count
    xor si,si

print_loop:
    push cx

    mov bx,item_id[si]

    cmp bx,1
    je p1
    cmp bx,2
    je p2
    cmp bx,3
    je p3
    cmp bx,4
    je p4
    cmp bx,5
    je p5
    cmp bx,6
    je p6
    cmp bx,7
    je p7
    jmp bad

p1:
 lea dx,item1 
 jmp show
p2:
 lea dx,item2
  jmp show
p3:
 lea dx,item3 
 jmp show
p4:
 lea dx,item4
  jmp show
p5:
 lea dx,item5
  jmp show
p6:
 lea dx,item6
  jmp show
p7:
 lea dx,item7

show:
    mov ah,9
    int 21h

    mov dl,' '
    mov ah,2
    int 21h
    int 21h
    int 21h

    mov ax,item_qty[si]
    call print_num

    mov dl,' '
    mov ah,2
    int 21h
    int 21h
    int 21h

    mov ax,item_price[si]
    call print_num

    mov dl,10
    mov ah,2
    int 21h

    add si,2
    pop cx
    loop print_loop

    lea dx,total_msg
    mov ah,9
    int 21h

    mov ax,total
    call print_num

    mov ah,4ch
    int 21h

bad:
    lea dx,invalid
    mov ah,9
    int 21h
    jmp start

main endp


print_num proc
    mov bx,10
    xor cx,cx

L1:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne L1

L2:
    pop dx
    add dl,'0'
    mov ah,2
    int 21h
    loop L2

    ret
print_num endp

end main



