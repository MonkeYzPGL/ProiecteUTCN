.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare",0
area_width EQU 640
area_height EQU 480
area DD 0

counter DD 0 ; numara evenimentele de tip timer
sec DD 0 ; numarul de secunde

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

button_size EQU 360
button_x EQU 140
button_y EQU 80
var EQU 0
nrc DD 52

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 061f64dh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp



; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

linie_orizontala macro x, y, l, color
local bucla_linie	
	mov eax, y ; eax=y
	mov ebx, area_width
	mul ebx ;eax = y * area_width
	add eax, x ; eax = (y * area_width) + x
	shl eax, 2 ; eax = ((y * area_width) + x) * 4
	add eax, area
	mov ecx, l
bucla_linie:
	mov dword ptr[eax], color
	add eax, 4
	loop bucla_linie
endm

linie_verticala macro x, y, l, color
local bucla_linie	
	mov eax, y 
	mov ebx, area_width
	mul ebx 
	add eax, x 
	shl eax, 2 
	add eax, area
	mov ecx, l
bucla_linie:
	mov dword ptr[eax], color
	add eax, area_width * 4
	loop bucla_linie
endm	

colorare macro x, y , h, l, color
local bucla_linie, et
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ebx, h
et:
	mov ecx, l
bucla_linie:
	mov dword ptr[eax], color
	add eax, 4
	loop bucla_linie
	add eax, area_width * 4
	sub eax, 4 * l
	dec ebx
	cmp ebx, 0
	jne et
endm



; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 160
	push area
	call memset
	add esp, 12
	colorare button_x , button_y, button_size, button_size, 054d4ffh
	
	;;Trasam chenarul
	linie_orizontala button_x, button_y, button_size, 0FF0000h
	linie_orizontala button_x, button_y + button_size, button_size, 0FF0000h
	linie_verticala button_x,button_y, button_size, 0FF0000h
	linie_verticala button_x + button_size, button_y, button_size, 0FF0000h
	
	linie_verticala button_x + 45, button_y, button_size, 0FF0000h
	linie_verticala button_x + 90, button_y, button_size, 0FF0000h
	linie_verticala button_x + 135, button_y, button_size, 0FF0000h
	linie_verticala button_x + 180, button_y, button_size, 0FF0000h
	linie_verticala button_x + 225, button_y, button_size, 0FF0000h
	linie_verticala button_x + 270, button_y, button_size, 0FF0000h
	linie_verticala button_x + 315, button_y, button_size, 0FF0000h
	
	linie_orizontala button_x, button_y + 45, button_size, 0FF0000h
	linie_orizontala button_x, button_y + 90, button_size, 0FF0000h
	linie_orizontala button_x, button_y + 135, button_size, 0FF0000h
	linie_orizontala button_x, button_y + 180, button_size, 0FF0000h
	linie_orizontala button_x, button_y + 225, button_size, 0FF0000h
	linie_orizontala button_x, button_y + 270, button_size, 0FF0000h
	linie_orizontala button_x, button_y + 315, button_size, 0FF0000h
	jmp afisare_litere

	
evt_click:
	mov edx, [ebp+arg2] ; val x
	mov ebx, [ebp+arg3] ; val y
	
v1: ;patratul 1
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v2
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v9
	colorare button_x, button_y, 45, 45 , 000FF00h
	make_text_macro '1', area, button_x + 22, button_y + 22
	dec nrc
	jmp afisare_litere
v2: ;patratul 2
	cmp edx, 185
	jl v1
	cmp edx, 230
	jg v3
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v10
	colorare button_x+45, button_y, 45, 45 , 000FF00h
	make_text_macro '1', area, button_x+67, button_y + 22
	dec nrc
	jmp afisare_litere
v3: ;patratul 3
	cmp edx, 230
	jl v2
	cmp edx, 275
	jg v4
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v11
	colorare button_x+90, button_y, 45, 45 , 000FF00h
	make_text_macro '1', area, button_x+112, button_y + 22
	dec nrc
	jmp afisare_litere
v4: ;patratul 4
	cmp edx, 275
	jl v3
	cmp edx, 320
	jg v5
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v12
	colorare button_x+135, button_y, 45, 45 , 000FF00h
	make_text_macro '1', area, button_x+157, button_y + 22
	dec nrc
	jmp afisare_litere
v5: 
	cmp edx, 320
	jl v4
	cmp edx, 365
	jg v6
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v13
	colorare button_x+180, button_y, 45, 45 , 000FF00h
	make_text_macro '1', area, button_x+202, button_y + 22
	dec nrc
	jmp afisare_litere
v6: 
	cmp edx, 365
	jl v5
	cmp edx, 410
	jg v7
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v14
	colorare button_x+225, button_y, 45, 45 , 000FF00h
	make_text_macro '3', area, button_x+247 , button_y + 22
	dec nrc
	jmp afisare_litere
v7: 
	cmp edx, 410
	jl v6
	cmp edx, 455
	jg v8
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v15
	colorare button_x+270, button_y, 45, 45 , 0FF0000h
	make_text_macro 'Q', area, button_x+292, button_y + 22
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v8:
	cmp edx, 455
	jl v7
	cmp edx, 500
	jg afara
	cmp ebx, 80
	jl afara
	cmp ebx, 125
	jg v16
	colorare button_x+315, button_y, 45, 45 , 000FF00h
	make_text_macro '2', area, button_x+337, button_y + 22
	dec nrc
	jmp afisare_litere
v9:
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v10
	cmp ebx, 125
	jl v1
	cmp ebx, 170
	jg v17
	colorare button_x, button_y + 45, 45, 45, 000FF00h
	make_text_macro '1', area , button_x + 22, button_y + 67
	dec nrc
	jmp afisare_litere
v10:
	cmp edx, 185
	jl v9
	cmp edx, 230
	jg v11
	cmp ebx, 125
	jl v2
	cmp ebx, 170
	jg v18
	colorare button_x + 45, button_y + 45, 45, 45, 0FF0000h
	make_text_macro 'Q', area , button_x + 67, button_y + 67
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v11:
	cmp edx, 230
	jl v10
	cmp edx, 275
	jg v12
	cmp ebx, 125
	jl v3
	cmp ebx, 170
	jg v19
	colorare button_x + 90, button_y + 45, 45, 45, 000FF00h
	make_text_macro '1', area , button_x + 112, button_y + 67
	dec nrc
	jmp afisare_litere
v12:
	cmp edx, 275
	jl v11
	cmp edx, 320
	jg v13
	cmp ebx, 125
	jl v4
	cmp ebx, 170
	jg v20
	colorare button_x + 135, button_y + 45, 45, 45, 000FF00h
	make_text_macro '1', area , button_x + 157, button_y + 67
	dec nrc
	jmp afisare_litere
v13:
	cmp edx, 320
	jl v12
	cmp edx, 365
	jg v14
	cmp ebx, 125
	jl v5
	cmp ebx, 170
	jg v21
	colorare button_x + 180, button_y + 45, 45, 45, 0FF0000h
	make_text_macro 'Q', area , button_x + 202, button_y + 67
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v14:
	cmp edx, 365
	jl v13
	cmp edx, 410
	jg v15
	cmp ebx, 125
	jl v6
	cmp ebx, 170
	jg v22
	colorare button_x + 225, button_y + 45, 45, 45 , 000FF00h
	make_text_macro '3', area, button_x + 247, button_y + 67
	dec nrc
	jmp afisare_litere
v15: 
	cmp edx, 410
	jl v14
	cmp edx, 455
	jg v16
	cmp ebx, 125
	jl v7
	cmp ebx, 170
	jg v23
	colorare button_x + 270, button_y + 45, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 292, button_y + 67
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v16:
	cmp edx, 455
	jl v15
	cmp edx, 500
	jg afara
	cmp ebx, 125
	jl v8
	cmp ebx, 170
	jg v24
	colorare button_x + 315, button_y + 45, 45 , 45, 000FF00h
	make_text_macro '2', area, button_x + 337, button_y + 67
	dec nrc
	jmp afisare_litere
v17:
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v18
	cmp ebx, 170
	jl v9
	cmp ebx, 215
	jg v25
	colorare button_x, button_y + 90, 45, 45, 000FF00h
	make_text_macro '2', area , button_x + 22, button_y + 112
	dec nrc
	jmp afisare_litere
v18:
	cmp edx, 185
	jl v17
	cmp edx, 230
	jg v19
	cmp ebx, 170
	jl v10
	cmp ebx, 215
	jg v26
	colorare button_x + 45, button_y + 90, 45, 45, 000FF00h
	make_text_macro '3', area , button_x + 67, button_y + 112
	dec nrc
	jmp afisare_litere
v19:
	cmp edx, 230
	jl v18
	cmp edx, 275
	jg v20
	cmp ebx, 170
	jl v11
	cmp ebx, 215
	jg v27
	colorare button_x + 90, button_y + 90, 45, 45, 000FF00h
	make_text_macro '3', area , button_x + 112, button_y + 112
	dec nrc
	jmp afisare_litere
v20:
	cmp edx, 275
	jl v19
	cmp edx, 320
	jg v21
	cmp ebx, 170
	jl v12
	cmp ebx, 215
	jg v28
	colorare button_x + 135, button_y + 90, 45, 45, 000FF00h
	make_text_macro '2', area , button_x + 157, button_y + 112
	dec nrc
	jmp afisare_litere
v21:
	cmp edx, 320
	jl v20
	cmp edx, 365
	jg v22
	cmp ebx, 170
	jl v13
	cmp ebx, 215
	jg v29
	colorare button_x + 180, button_y + 90, 45, 45, 000FF00h
	make_text_macro '1', area , button_x + 202, button_y + 112
	dec nrc
	jmp afisare_litere
v22:
	cmp edx, 365
	jl v21
	cmp edx, 410
	jg v23
	cmp ebx, 170
	jl v14
	cmp ebx, 215
	jg v30
	colorare button_x + 225, button_y + 90, 45, 45, 000FF00h
	make_text_macro '2', area , button_x + 247, button_y + 112
	dec nrc
	jmp afisare_litere
v23:
	cmp edx, 410
	jl v22
	cmp edx, 455
	jg v24
	cmp ebx, 170
	jl v15
	cmp ebx, 215
	jg v31
	colorare button_x + 270, button_y + 90, 45, 45, 000FF00h
	make_text_macro '1', area , button_x + 292, button_y + 112
	dec nrc
	jmp afisare_litere
v24:
	cmp edx, 455
	jl v23
	cmp edx, 500
	jg afara
	cmp ebx, 170
	jl v16
	cmp ebx, 215
	jg v32
	colorare button_x + 315, button_y + 90, 45, 45, 000FF00h
	make_text_macro '1', area , button_x + 337, button_y + 112
	dec nrc
	jmp afisare_litere
v25: 
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v26
	cmp ebx, 215
	jl v17
	cmp ebx, 260
	jg v33
	colorare button_x, button_y + 135, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 22, button_y + 157
	dec nrc
	jmp afisare_litere
v26: 
	cmp edx, 185
	jl v25
	cmp edx, 230
	jg v27
	cmp ebx, 215
	jl v18
	cmp ebx, 260
	jg v34
	colorare button_x + 45, button_y + 135, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 67, button_y + 157
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v27: 
	cmp edx, 230
	jl v26
	cmp edx, 275
	jg v28
	cmp ebx, 215
	jl v19
	cmp ebx, 260
	jg v35
	colorare button_x + 90, button_y + 135, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 112, button_y + 157
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v28: 
	cmp edx, 275
	jl v27
	cmp edx, 320
	jg v29
	cmp ebx, 215
	jl v20
	cmp ebx, 260
	jg v36
	colorare button_x + 135, button_y + 135, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 157, button_y + 157
	dec nrc
	jmp afisare_litere
v29: 
	cmp edx, 320
	jl v28
	cmp edx, 365
	jg v30
	cmp ebx, 215
	jl v21
	cmp ebx, 260
	jg v37
	colorare button_x + 180, button_y + 135, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 202, button_y + 157
	dec nrc
	jmp afisare_litere
v30: 
	cmp edx, 365
	jl v29
	cmp edx, 410
	jg v31
	cmp ebx, 215
	jl v22
	cmp ebx, 260
	jg v38
	colorare button_x + 225, button_y + 135, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 247, button_y + 157
	dec nrc
	jmp afisare_litere
v31: 
	cmp edx, 410
	jl v30
	cmp edx, 455
	jg v32
	cmp ebx, 215
	jl v23
	cmp ebx, 260
	jg v39
	colorare button_x + 270, button_y + 135, 45, 45, 000FF00h
	make_text_macro '0', area, button_x + 292, button_y + 157
	dec nrc
	jmp afisare_litere
v32: 
	cmp edx, 455
	jl v31
	cmp edx, 500
	jg afara
	cmp ebx, 215
	jl v24
	cmp ebx, 260
	jg v40
	colorare button_x + 315, button_y + 135, 45, 45, 000FF00h
	make_text_macro '0', area, button_x + 337, button_y + 157
	dec nrc
	jmp afisare_litere
v33:
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v34
	cmp ebx, 260
	jl v25
	cmp ebx, 305
	jg v41
	colorare button_x, button_y + 180, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 22, button_y + 202
	dec nrc
	jmp afisare_litere
v34:
	cmp edx, 185
	jl v33
	cmp edx, 230
	jg v35
	cmp ebx, 260
	jl v26
	cmp ebx, 305
	jg v42
	colorare button_x + 45, button_y + 180, 45, 45, 000FF00h
	make_text_macro '4', area, button_x + 67, button_y + 202
	dec nrc
	jmp afisare_litere
v35:
	cmp edx, 230
	jl v34
	cmp edx, 275
	jg v36
	cmp ebx, 260
	jl v27
	cmp ebx, 305
	jg v43
	colorare button_x + 90, button_y + 180, 45, 45, 000FF00h
	make_text_macro '3', area, button_x + 112, button_y + 202
	dec nrc
	jmp afisare_litere
v36:
	cmp edx, 275
	jl v35
	cmp edx, 320
	jg v37
	cmp ebx, 260
	jl v28
	cmp ebx, 305
	jg v44
	colorare button_x + 135, button_y + 180, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 157, button_y + 202
	dec nrc
	jmp afisare_litere
v37:
	cmp edx, 320
	jl v36
	cmp edx, 365
	jg v38
	cmp ebx, 260
	jl v29
	cmp ebx, 305
	jg v45
	colorare button_x + 180, button_y + 180, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 202, button_y + 202
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v38:
	cmp edx, 365
	jl v37
	cmp edx, 410
	jg v39
	cmp ebx, 260
	jl v30
	cmp ebx, 305
	jg v46
	colorare button_x + 225, button_y + 180, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 247, button_y + 202
	dec nrc
	jmp afisare_litere
v39:
	cmp edx, 410
	jl v38
	cmp edx, 455
	jg v40
	cmp ebx, 260
	jl v31
	cmp ebx, 305
	jg v47
	colorare button_x + 270, button_y + 180, 45, 45, 000FF00h
	make_text_macro '0', area, button_x + 292, button_y + 202
	dec nrc
	jmp afisare_litere
v40:
	cmp edx, 455
	jl v39
	cmp edx, 510
	jg afara
	cmp ebx, 260
	jl v32
	cmp ebx, 305
	jg v48
	colorare button_x + 315, button_y + 180, 45, 45, 000FF00h
	make_text_macro '0', area, button_x + 337, button_y + 202
	dec nrc
	jmp afisare_litere
v41:
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v42
	cmp ebx, 305
	jl v33
	cmp ebx, 350
	jg v49
	colorare button_x, button_y + 225, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 22, button_y + 247
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v42: 
	cmp edx, 185
	jl v41
	cmp edx, 230
	jg v43
	cmp ebx, 305
	jl v34
	cmp ebx, 350
	jg v50
	colorare button_x + 45, button_y + 225, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 67, button_y + 247
	dec nrc
	jmp afisare_litere
v43:
	cmp edx, 230
	jl v42
	cmp edx, 275
	jg v44
	cmp ebx, 305
	jl v35
	cmp ebx, 350
	jg v51
	colorare button_x + 90, button_y + 225, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 112, button_y + 247
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v44: 
	cmp edx, 275
	jl v43
	cmp edx, 320
	jg v45
	cmp ebx, 305
	jl v36
	cmp ebx, 350
	jg v52
	colorare button_x + 135, button_y + 225, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 157, button_y + 247
	dec nrc
	jmp afisare_litere
v45: 
	cmp edx, 320
	jl v44
	cmp edx, 365
	jg v46
	cmp ebx, 305
	jl v37
	cmp ebx, 350
	jg v53
	colorare button_x + 180, button_y + 225, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 202, button_y + 247
	dec nrc
	jmp afisare_litere
v46: 
	cmp edx, 365
	jl v45
	cmp edx, 410
	jg v47
	cmp ebx, 305
	jl v38
	cmp ebx, 350
	jg v54
	colorare button_x + 225, button_y + 225, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 247, button_y + 247
	dec nrc
	jmp afisare_litere
v47: 
	cmp edx, 410
	jl v46
	cmp edx, 455
	jg v48
	cmp ebx, 305
	jl v39
	cmp ebx, 350
	jg v55
	colorare button_x + 270, button_y + 225, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 292, button_y + 247
	dec nrc
	jmp afisare_litere
v48: 
	cmp edx, 455
	jl v47
	cmp edx, 510
	jg afara
	cmp ebx, 305
	jl v40
	cmp ebx, 350
	jg v56
	colorare button_x + 315, button_y + 225, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 337, button_y + 247
	dec nrc
	jmp afisare_litere
v49:
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v50
	cmp ebx, 350
	jl v41
	cmp ebx, 395
	jg v57
	colorare button_x, button_y + 270, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 22, button_y + 292
	dec nrc
	jmp afisare_litere
v50:
	cmp edx, 185
	jl v49
	cmp edx, 230
	jg v51
	cmp ebx, 350
	jl v42
	cmp ebx, 395
	jg v58
	colorare button_x + 45, button_y + 270, 45, 45, 000FF00h
	make_text_macro '3', area, button_x + 67, button_y + 292
	dec nrc
	jmp afisare_litere
v51:
	cmp edx, 230
	jl v50
	cmp edx, 275
	jg v51
	cmp ebx, 350
	jl v43
	cmp ebx, 395
	jg v59
	colorare button_x + 90, button_y + 270, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 112, button_y + 292
	dec nrc
	jmp afisare_litere
v52:
	cmp edx, 275
	jl v51
	cmp edx, 320
	jg v53
	cmp ebx, 350
	jl v44
	cmp ebx, 395
	jg v60
	colorare button_x + 135, button_y + 270, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 157, button_y + 292
	dec nrc	
	jmp afisare_litere
v53:
	cmp edx, 320
	jl v52
	cmp edx, 365
	jg v54
	cmp ebx, 350
	jl v45
	cmp ebx, 395
	jg v61
	colorare button_x + 180, button_y + 270, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 202, button_y + 292
	dec nrc
	jmp afisare_litere
v54:
	cmp edx, 365
	jl v53
	cmp edx, 410
	jg v55
	cmp ebx, 350
	jl v46
	cmp ebx, 395
	jg v62
	colorare button_x + 225, button_y + 270, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 247, button_y + 292
	dec nrc
	jmp afisare_litere
v55:
	cmp edx, 410
	jl v54
	cmp edx, 455
	jg v56
	cmp ebx, 350
	jl v47
	cmp ebx, 395
	jg v63
	colorare button_x + 270, button_y + 270, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 292, button_y + 292
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v56:
	cmp edx, 455
	jl v55
	cmp edx, 510
	jg afara
	cmp ebx, 350
	jl v47
	cmp ebx, 395
	jg v64
	colorare button_x + 315, button_y + 270, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 337, button_y + 292
	dec nrc
	jmp afisare_litere
v57:
	cmp edx, 140
	jl afara
	cmp edx, 185
	jg v58
	cmp ebx, 395
	jl v49
	cmp ebx, 440
	jg afara
	colorare button_x, button_y + 315, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 22, button_y + 337
	dec nrc
	jmp afisare_litere
v58:
	cmp edx, 185
	jl v57
	cmp edx, 230
	jg v59
	cmp ebx, 395
	jl v50
	cmp ebx, 440
	jg afara
	colorare button_x + 45, button_y + 315, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 67, button_y + 337
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v59:
	cmp edx, 230
	jl v58
	cmp edx, 275
	jg v60
	cmp ebx, 395
	jl v51
	cmp ebx, 440
	jg afara
	colorare button_x + 90, button_y + 315, 45, 45, 000FF000h
	make_text_macro '2', area, button_x + 112, button_y + 337
	dec nrc
	jmp afisare_litere
v60:
	cmp edx, 275
	jl v59
	cmp edx, 320
	jg v61
	cmp ebx, 395
	jl v52
	cmp ebx, 440
	jg afara
	colorare button_x + 135, button_y + 315, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 157, button_y + 337
	dec nrc	
	jmp afisare_litere
v61:
	cmp edx, 320
	jl v60
	cmp edx, 365
	jg v62
	cmp ebx, 395
	jl v53
	cmp ebx, 440
	jg afara
	colorare button_x + 180, button_y + 315, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 202, button_y + 337
	dec nrc
	jmp afisare_litere
v62:
	cmp edx, 365
	jl v61
	cmp edx, 410
	jg v63
	cmp ebx, 395
	jl v54
	cmp ebx, 440
	jg afara
	colorare button_x + 225, button_y + 315, 45, 45, 0FF0000h
	make_text_macro 'Q', area, button_x + 247, button_y + 337	
	make_text_macro 'G', area, 300, 165
	make_text_macro 'A', area, 310, 165
	make_text_macro 'M', area, 320, 165
	make_text_macro 'E', area, 330, 165
	make_text_macro 'O', area, 300, 185
	make_text_macro 'V', area, 310, 185
	make_text_macro 'E', area, 320, 185
	make_text_macro 'R', area, 330, 185
	jmp afisare_litere
v63:
	cmp edx, 410
	jl v62
	cmp edx, 455
	jg v64
	cmp ebx, 395
	jl v55
	cmp ebx, 440
	jg afara
	colorare button_x + 270, button_y + 315, 45, 45, 000FF00h
	make_text_macro '2', area, button_x + 292, button_y + 337
	dec nrc
	jmp afisare_litere
v64:
	cmp edx, 455
	jl v63
	cmp edx, 510
	jg afara
	cmp ebx, 395
	jl v56
	cmp ebx, 440
	jg afara
	colorare button_x + 315, button_y + 315, 45, 45, 000FF00h
	make_text_macro '1', area, button_x + 337, button_y + 337
	dec nrc
	jmp afisare_litere
afara: 

evt_timer:
	inc counter
	cmp counter, 5
	jz o_sec
	jmp nu_sec
	
o_sec:
	inc sec
	mov counter, 0
	
nu_sec:

afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, sec
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, nrc
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 600, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 590, 10
	
	cmp dword ptr nrc, 0
	jne fi
	make_text_macro 'Y', area, 305, 165
	make_text_macro 'O', area, 315, 165
	make_text_macro 'U', area, 325, 165
	make_text_macro 'W', area, 305, 185
	make_text_macro 'I', area, 315, 185
	make_text_macro 'N', area, 325, 185
	fi:
	
	;numele jocului
	make_text_macro 'Q', area, 195, 10
	make_text_macro 'M', area, 215, 10
	make_text_macro 'I', area, 235, 10
	make_text_macro 'N', area, 255, 10
	make_text_macro 'E', area, 275, 10
	make_text_macro 'S', area, 295, 10
	make_text_macro 'W', area, 315, 10
	make_text_macro 'E', area, 335, 10
	make_text_macro 'E', area, 355, 10
	make_text_macro 'P', area, 375, 10
	make_text_macro 'E', area, 395, 10
	make_text_macro 'R', area, 415, 10
	make_text_macro 'Q', area, 435, 10
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
