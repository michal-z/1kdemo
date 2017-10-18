format MS COFF

extrn '__imp__ExitProcess@4' as w32ExitProcess:dword
extrn '__imp__CreateWindowExA@48' as w32CreateWindowEx:dword
extrn '__imp__SetPixelFormat@12' as w32SetPixelFormat:dword
extrn '__imp__ChoosePixelFormat@8' as w32ChoosePixelFormat:dword
extrn '__imp__ShowCursor@4' as w32ShowCursor:dword
extrn '__imp__GetDC@4' as w32GetDC:dword
extrn '__imp__GetAsyncKeyState@4' as w32GetAsyncKeyState:dword
extrn '__imp__PeekMessageA@20' as w32PeekMessage:dword
extrn '__imp__DispatchMessageA@4' as w32DispatchMessage:dword
extrn '__imp__SetProcessDPIAware@0' as w32SetProcessDPIAware:dword
extrn '__imp__timeGetTime@0' as w32timeGetTime:dword
extrn '__imp__timeBeginPeriod@4' as w32timeBeginPeriod:dword
extrn '__imp__SwapBuffers@4' as w32SwapBuffers:dword
extrn '__imp__ChangeDisplaySettingsA@8' as w32ChangeDisplaySettings:dword
extrn '__imp__wglMakeCurrent@8' as wglMakeCurrent:dword
extrn '__imp__wglCreateContext@4' as wglCreateContext:dword
extrn '__imp__wglGetProcAddress@4' as wglGetProcAddress:dword
extrn '__imp__glRecti@16' as glRecti:dword
extrn '__imp__glTexCoord1f@4' as glTexCoord1f:dword

section '.text' code readable executable

public _Start
_Start:
        call    [w32SetProcessDPIAware]
        push    00000004h               ; CDS_FULLSCREEN
        push    ScreenSettings
        call    [w32ChangeDisplaySettings]
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
        push    WinClassName            ; lpClassName
        push    0                       ; dwExStyle
        call    [w32CreateWindowEx]
        push    eax                     ; hwnd
        call    [w32GetDC]
        mov     ebx,eax                 ; ebx = hdc
        push    PixelFormatDesc
        push    ebx                     ; hdc
        call    [w32ChoosePixelFormat]
        push    PixelFormatDesc
        push    eax                     ; pixel format id
        push    ebx                     ; hdc
        call    [w32SetPixelFormat]
        push    ebx                     ; hdc
        call    [wglCreateContext]
        push    eax                     ; GL context
        push    ebx                     ; hdc
        call    [wglMakeCurrent]
        push    0
        call    [w32ShowCursor]
        push    @glUseProgram
        call    [wglGetProcAddress]
        mov     esi,eax                 ; esi = pointer to glUseProgram
        push    @glCreateShaderProgramv
        call    [wglGetProcAddress]
        push    ShaderCodePtr
        push    1
        push    8B30h                   ; GL_FRAGMENT_SHADER
        call    eax                     ; glCreateShaderProgramv
        push    eax                     ; GL program to use
        call    esi                     ; glUseProgram
        push    1                       ; ask for 1 ms timer resolution
        call    [w32timeBeginPeriod]
        call    [w32timeGetTime]
        mov     edi,eax                 ; edi = beginTime
.mainLoop:
        push    0001h                   ; PM_REMOVE
        push    0
        push    0
        push    0
        push    Message
        call    [w32PeekMessage]
        call    [w32timeGetTime]
        sub     eax,edi                 ; currentTime = time - beginTime
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
        call    [w32SwapBuffers]
        push    1Bh                     ; VK_ESCAPE
        call    [w32GetAsyncKeyState]
        test    eax,eax
        jnz     .exit
        jmp     .mainLoop
.exit:  push    0
        call    [w32ExitProcess]
        ret

section '.data' data readable writeable

Message:
PixelFormatDesc:
    dd 0
    dd 00000021h                          ; PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
ScreenSettings:
    db 32 dup 0
    dd 0
    dw .size
    dw 0
    dd 001C0000h                          ; DM_PELSWIDTH | DM_PELSHEIGHT | DM_BITSPERPEL
    db 60 dup 0
    dd 32,1920,1080
    dd 11 dup 0
    .size = $-ScreenSettings

ShaderCodePtr dd ShaderCode
ShaderCode:
    file '1kdemo-small.glsl'
    db 0

WinClassName db 'edit',0
@glCreateShaderProgramv db 'glCreateShaderProgramv',0
@glUseProgram db 'glUseProgram',0
