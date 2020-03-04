rem @echo off

rem Related directories. Change as yours.
set DOT_DIR=%USERPROFILE%\repos\dotfiles

rem create symbliclinks. Need administrator privilege.
if exist %USERPROFILE%\.gitconfig (
    del %USERPROFILE%\.gitconfig
)
mklink %USERPROFILE%\.gitconfig %DOT_DIR%\.gitconfig

if exist %USERPROFILE%\.vimrc (
    del %USERPROFILE%\.vimrc
)
mklink %HOMEPATH%\.vimrc %DOT_DIR%\.vimrc

if exist %USERPROFILE%\AppData\Local\nvim (
    del %USERPROFILE%\AppData\Local\nvim
)
mklink /D %USERPROFILE%\AppData\Local\nvim %DOT_DIR%\.vim
