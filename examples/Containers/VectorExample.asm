.386
.model flat, stdcall
option casemap : none
include \masm32\include\msvcrt.inc
includelib \masm32\lib\msvcrt.lib

include .\libs\MASM_STL\inc\Containers\Vector.inc
includelib FULL_PATH_TO_LIBS\libs\MASM_STL\libs\Vector.lib


.data
    fmt_eq db "Is array equal to its copy: %d", 10, 0
    fmt_elem db "arr[%d] = %d", 10, 0

.code
Main PROC
    LOCAL vec: ptr Vector
    LOCAL copy: ptr Vector
    LOCAL move: ptr Vector

    invoke Vector_New_Empty
    mov vec, eax
    mov ecx, 1
    mov edx, [eax].Vector.pData
    VECTOR_METHOD vec, reserve, 13
    .WHILE ecx != 14
        VECTOR_METHOD vec, push_back, ecx
        inc ecx
    .ENDW
    
    invoke Vector_New_Copy, vec
    mov copy, eax
    
    VECTOR_METHOD vec, is_eq, copy
    mov ebx, eax
    
    invoke Vector_New_Move, copy
    mov move, eax
    
    VECTOR_METHOD move, erase, 1
    VECTOR_METHOD move, insert, 1, 99
    VECTOR_METHOD move, push_back, 42
    
    VECTOR_METHOD move, get_size
    mov edx, eax
    mov ecx, 0
    .WHILE ecx != edx
        VECTOR_METHOD move, get_at, ecx
        push edx
        push ecx
        invoke crt_printf, addr fmt_elem, ecx, eax
        pop ecx
        pop edx
        inc ecx
    .ENDW
    
    invoke crt_printf, addr fmt_eq, ebx
    invoke Vector_Free, vec
    invoke Vector_Free, copy
    invoke Vector_Free, move

    xor eax, eax
    ret
Main ENDP

start:
    call Main
    ret
end start