@echo off
set NAME=empty
..\bin\shader_minifier --format none -o "" %NAME%.glsl > small.glsl
..\bin\fasm %NAME%.asm
..\bin\crinkler /TINYIMPORT /TINYHEADER /SUBSYSTEM:WINDOWS /ENTRY:Start /COMPMODE:VERYSLOW /OUT:%NAME%.exe /RANGE:opengl32 /LIBPATH:..\bin %NAME%.obj kernel32.Lib User32.Lib Gdi32.lib WinMM.Lib OpenGL32.Lib
del small.glsl
del %NAME%.obj
