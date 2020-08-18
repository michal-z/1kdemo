@echo off
set NAME=improIntro1
..\bin\shader_minifier --format none -o "" %NAME%.c > small.glsl
..\bin\fasm %NAME%.asm
..\bin\crinkler /TINYIMPORT /NODEFAULTLIB /TINYHEADER /SUBSYSTEM:WINDOWS /ENTRY:Start /COMPMODE:VERYSLOW /OUT:%NAME%.exe /RANGE:opengl32 /LIBPATH:..\bin %NAME%.obj kernel32.Lib User32.Lib Gdi32.lib WinMM.Lib OpenGL32.Lib
del small.glsl
del %NAME%.obj
