@echo off

:: %~dp0busybox\busybox.exe find %CD% -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" > cscope.files
:: find %CD% -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" > cscope.files
find . -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" > cscope.files
cscope.exe -bkq -i cscope.files
ctags.exe -R
