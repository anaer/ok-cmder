:: use this file to run your own startup commands
:: use  in front of the command to prevent printing the command

:: uncomment this to have the ssh agent load when cmder starts
:: call "%GIT_INSTALL_ROOT%/cmd/start-ssh-agent.cmd"

:: uncomment this next two lines to use pageant as the ssh authentication agent
:: SET SSH_AUTH_SOCK=/tmp/.ssh-pageant-auth-sock
:: call "%GIT_INSTALL_ROOT%/cmd/start-ssh-pageant.cmd"

:: you can add your plugins to the cmder path like so
:: set "PATH=%CMDER_ROOT%\vendor\whatever;%PATH%"

@echo off

set WORKSPACE=%~d0\workspace
if not exist %WORKSPACE% (
        md %WORKSPACE%
)

if not exist "%CMDER_ROOT%\vendor\cygwin\home\%USERNAME%" (
        md %CMDER_ROOT%\vendor\cygwin\home\%USERNAME%
)

set "PATH=%CMDER_ROOT%\bin\custom;%PATH%"
set "PATH=%CMDER_ROOT%\bin\busybox;%PATH%"
set "PATH=%CMDER_ROOT%\bin\android;%PATH%"
set "PATH=%CMDER_ROOT%\bin\systools;%PATH%"

set "PATH=%CMDER_ROOT%\vendor\cygwin\usr\x86_64-pc-cygwin\bin;%PATH%"
set "PATH=%CMDER_ROOT%\vendor\cygwin\usr\sbin;%PATH%"
set "PATH=%CMDER_ROOT%\vendor\cygwin\sbin;%PATH%"
set "PATH=%CMDER_ROOT%\vendor\cygwin\bin;%PATH%"
