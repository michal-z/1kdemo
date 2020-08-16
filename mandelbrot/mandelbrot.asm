format MS COFF

extrn '__imp__ExitProcess@4' as ExitProcess:dword
extrn '__imp__CreateWindowExA@48' as CreateWindowEx:dword
extrn '__imp__SetPixelFormat@12' as SetPixelFormat:dword
extrn '__imp__ChoosePixelFormat@8' as ChoosePixelFormat:dword
extrn '__imp__ShowCursor@4' as ShowCursor:dword
extrn '__imp__GetDC@4' as GetDC:dword
extrn '__imp__GetAsyncKeyState@4' as GetAsyncKeyState:dword
extrn '__imp__PeekMessageA@20' as PeekMessage:dword
extrn '__imp__timeGetTime@0' as timeGetTime:dword
extrn '__imp__SwapBuffers@4' as SwapBuffers:dword
extrn '__imp__ChangeDisplaySettingsA@8' as ChangeDisplaySettings:dword
extrn '__imp__wglMakeCurrent@8' as wglMakeCurrent:dword
extrn '__imp__wglCreateContext@4' as wglCreateContext:dword
extrn '__imp__wglGetProcAddress@4' as wglGetProcAddress:dword
extrn '__imp__glRecti@16' as glRecti:dword
extrn '__imp__glTexCoord1f@4' as glTexCoord1f:dword

section '.text' code readable executable

public _Start
_Start:
        push    00000004h               ; CDS_FULLSCREEN
        push    ScreenSettings
        call    [ChangeDisplaySettings]
        push    0                       ; lpParam
        push    0                       ; hInstance
        push    0                       ; hMenu
        push    0                       ; hWndParent
        push    0                       ; nHeight
        push    0                       ; nWidth
        push    0                       ; y
        push    0                       ; x
        push    91000000h               ; dwStyle = WS_POPUP|WS_VISIBLE|WS_MAXIMIZE
        push    0                       ; lpWindowName
        push    S.WinClassName          ; lpClassName
        push    0                       ; dwExStyle
        call    [CreateWindowEx]
        push    eax                     ; hwnd
        call    [GetDC]
        mov     ebx, eax                ; ebx = hdc
        push    PixelFormatDesc
        push    ebx                     ; hdc
        call    [ChoosePixelFormat]
        push    PixelFormatDesc
        push    eax                     ; pixel format id
        push    ebx                     ; hdc
        call    [SetPixelFormat]
        push    ebx                     ; hdc
        call    [wglCreateContext]
        push    eax                     ; GL context
        push    ebx                     ; hdc
        call    [wglMakeCurrent]
        push    0
        call    [ShowCursor]
        push    S.glUseProgram
        call    [wglGetProcAddress]
        mov     esi, eax                ; esi = pointer to glUseProgram
        push    S.glCreateShaderProgramv
        call    [wglGetProcAddress]
        push    ShaderCodePtr
        push    1
        push    8B30h                   ; GL_FRAGMENT_SHADER
        call    eax                     ; glCreateShaderProgramv
        push    eax                     ; GL program to use
        call    esi                     ; glUseProgram
        call    [timeGetTime]
        mov     edi, eax                ; edi = beginTime
.mainLoop:
        push    0001h                   ; PM_REMOVE
        push    0
        push    0
        push    0
        push    Message
        call    [PeekMessage]
        call    [timeGetTime]
        sub     eax, edi                 ; currentTime = time - beginTime
        push    eax
        fild    dword [esp]
        fstp    dword [esp]
        call    [glTexCoord1f]
        push    1
        push    1
        push    -1
        push    -1
        call    [glRecti]
        push    ebx                     ; hdc
        call    [SwapBuffers]
        push    1Bh                     ; VK_ESCAPE
        call    [GetAsyncKeyState]
        test    eax, eax
        jnz     .exit
        jmp     .mainLoop
.exit:  call    [ExitProcess]

section '.data' data readable writeable

Message:
PixelFormatDesc:
    dd 0
    dd 00000025h                          ; PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER | PFD_DRAW_TO_WINDOW
ScreenSettings:
    db 32 dup 0
    dd 0
    dw .size
    dw 0
    dd 001c0000h                          ; DM_PELSWIDTH | DM_PELSHEIGHT | DM_BITSPERPEL
    db 60 dup 0
    dd 32, 1920, 1080
    dd 11 dup 0
    .size = $-ScreenSettings

ShaderCodePtr dd ShaderCode
ShaderCode:
    file 'small.glsl'
    db 0

S.WinClassName db 'edit', 0
S.glCreateShaderProgramv db 'glCreateShaderProgramv', 0
S.glUseProgram db 'glUseProgram', 0
