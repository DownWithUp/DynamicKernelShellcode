Format Binary
use64


start:
        sub rsp, 0x20
        push rdi                        ; Preserve non volatile registers
        push rsi
        push rbp
        push rbx
        mov r9, rcx                     ; Move function hash into a volatile register
        mov rdx, [gs:0x38]              ; IDT (interrupt dispatch table) from KPCR (kernel processor control region)
        mov ecx, [rdx + 8]              ; _KIDTENTRY64.OffsetHigh (Using the first routine in the table)
        shl rcx, 0x10
        add cx, WORD [rdx + 6]          ; _KIDTENTRY64.OffsetMiddle
        shl rcx, 0x10
        add cx, [rdx]                   ; _KIDENTRY64.OffsetLow
        mov rdx, rcx

        shr rdx, 0xC
        shl rdx, 0xC                    ; Shifts remove the specifics of the address
        @@:
        sub rdx, 0x1000                 ; 0x1000 = PAGE_SIZE
        mov rsi, [rdx]
        cmp si, 0x5A4D                  ; Look for "MZ" string of the DOS header

        jne @b
        mov rcx, rdx                    ; Base address of ntoskrnl.exe
        mov ebx, [rdx + 0x3C]           ; Get the PE header, add instruction converts from RVA to a VA
        add rcx, rbx
        mov ebx, [rcx + 0x88]           ; Get the export directory, add instruction converts from RVA to a VA
        add rbx, rdx
        mov edi, [rbx + 0x20]           ; In the export directory (IMAGE_EXPORT_DIRECTORY), get the AddressOfNames member
        add rdi, rdx
        xor ebp, ebp

        nextAPIName:
        mov esi, [rdi + rbp * 4]        ; Cycle through each pointer, add converts RVA to VA
        add rsi, rdx
        inc ebp
        mov ecx, 5381d                  ; Convert string to hash (djb2 algorithm)
        djb2:
        xor eax, eax
        lodsb
        mov r8d, eax
        cmp r8d, 0                      ; End of string?
        je @f
        mov eax, ecx
        shl eax, 5
        add eax, ecx
        add eax, r8d
        mov ecx, eax
        jmp djb2
        @@:
        cmp rcx, r9                     ; Hash of string to find (first argument)
        jne nextAPIName

        mov edi, [rbx + 0x24]           ; In the export directory get the AddressOfNameOrdinals member
        add rdi, rdx
        mov bp, [rdi + rbp * 2]         ; This gets the name ordinal in the AddressOfNameOrdinals where our function is located (*2 for WORD values)
        mov edi, [rbx + 0x1C]           ; In the export directory get the AddressOfFunctions member
        add rdi, rdx
        mov edi, [rdi + rbp * 4 - 4]    ; This gets the function (DWORD RVA) based on the name ordinal
        add rdi, rdx                    ; Finally adding the base address, gets us the address of the function
        mov rax, rdi                    ; Actually address of function
        pop rbx
        pop rbp
        pop rsi
        pop rdi
        add rsp, 0x20
        ret
