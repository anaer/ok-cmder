@echo off

:: *****************************
:: Configure local git config
set gitcmd=git.exe
set option=null
set /p option="Please input user name: "
if not "%option%"=="null" (
	%gitcmd% config --local user.name %option%
)
set /p option="Please input user email: "
if not "%option%"=="null" (
	%gitcmd% config --local user.email %option%
)

%gitcmd% config --local alias.st status
%gitcmd% config --local alias.co checkout
%gitcmd% config --local alias.ci commit
%gitcmd% config --local alias.br branch
%gitcmd% config --local alias.df diff