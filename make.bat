bin\shader_minifier --format none -o "" 1kdemo.glsl > 1kdemo-small.glsl
bin\fasm 1kdemo.asm
bin\crinkler /TINYIMPORT /TINYHEADER /SUBSYSTEM:WINDOWS /ENTRY:Start /COMPMODE:SLOW /OUT:1kdemo.exe /RANGE:opengl32 /LIBPATH:bin 1kdemo.obj kernel32.Lib User32.Lib Gdi32.lib WinMM.Lib OpenGL32.Lib
del 1kdemo-small.glsl
del 1kdemo.obj