..\bin\shader_minifier --format none -o "" qjulia.glsl > qjulia-small.glsl
..\bin\fasm qjulia.asm
..\bin\crinkler /TINYIMPORT /NODEFAULTLIB /TINYHEADER /SUBSYSTEM:WINDOWS /ENTRY:Start /COMPMODE:VERYSLOW /OUT:qjulia.exe /RANGE:opengl32 /LIBPATH:..\bin qjulia.obj kernel32.Lib User32.Lib Gdi32.lib WinMM.Lib OpenGL32.Lib
del qjulia-small.glsl
del qjulia.obj
