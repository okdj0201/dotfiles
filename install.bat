rem This bat file link or copy only .vimrc to INS_DIR\_vimrc and do
rem NOT anything about other dotfiles.

rem @echo off

rem directories. change as yours.
set INS_DIR=%HOMEPATH%
set DOT_DIR=%HOMEPATH%\git\dotfiles

rem make symbliclink. need administrator privilege.
rem If you does not have the priviliege, copy the file as described
rem below.
if exist %HOMEPATH%\_vimrc (
    del %HOMEPATH%\_vimrc
)
mklink %HOMEPATH%\_vimrc %DOT_DIR%\.vimrc

rem If you want to copy the file instead of symbliclink, enable
rem following line.
rem copy /Y %DOT_DIR%\.vimrc %HOMEPATH%\_vimrc

