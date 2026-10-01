IFNDEF MASM_STL_VECTOR_INC
MASM_STL_VECTOR_INC equ 1

include <Core/Types.inc>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                TYPES                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Vector STRUCT
    pData elem_t ?
    dwSize size_t ?
    dwCapacity capacity_t ?
    pVTable DWORD ? 
Vector ENDS

Vector_get_at_t TYPEDEF PROTO STDCALL : ptr Vector, : index_t
Vector_get_data_t TYPEDEF PROTO STDCALL : ptr Vector
Vector_get_size_t TYPEDEF PROTO STDCALL : ptr Vector
Vector_empty_t TYPEDEF PROTO STDCALL : ptr Vector
Vector_resize_t TYPEDEF PROTO STDCALL : ptr Vector, : size_t
Vector_reserve_t TYPEDEF PROTO STDCALL : ptr Vector, : capacity_t
Vector_capacity_t TYPEDEF PROTO STDCALL : ptr Vector
Vector_clear_t TYPEDEF PROTO STDCALL : ptr Vector
Vector_insert_t TYPEDEF PROTO STDCALL : ptr Vector, : index_t, : elem_t
Vector_erase_t TYPEDEF PROTO STDCALL : ptr Vector, : index_t
Vector_push_back_t TYPEDEF PROTO STDCALL : ptr Vector, : elem_t
Vector_is_eq_t TYPEDEF PROTO STDCALL : ptr Vector, : ptr Vector

VectorVTable STRUCT
    get_at DWORD ?
    get_data DWORD ?
    get_size DWORD ?
    empty DWORD ?
    resize DWORD ?
    reserve DWORD ?
    capacity DWORD ?
    clear DWORD ?
    insert DWORD ?
    erase DWORD ?
    push_back DWORD ?
    is_eq DWORD ?
VectorVTable ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;         PUBLIC FUNCTIONS            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Vector_New_Empty PROTO

Vector_New_Filled PROTO dwSize: size_t, dwData: elem_t

Vector_New_Copy PROTO pVec: ptr Vector

Vector_New_Move PROTO pVec: ptr Vector

Vector_Free PROTO pThis: ptr Vector

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                MACROS               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VECTOR_METHOD MACRO pObj, methodName, args:VARARG
    mov eax, pObj
    mov eax, [eax].Vector.pVTable
    IFB <args>
        invoke Vector_&methodName&_t PTR [eax + VectorVTable.methodName], pObj
    ELSE
        invoke Vector_&methodName&_t PTR [eax + VectorVTable.methodName], pObj, args
    ENDIF
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              VARIABLES              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EXTERNDEF Vector_vt: VectorVTable

ENDIF