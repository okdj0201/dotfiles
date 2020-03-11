rem @echo off

rem Script directories. Change as yours.
set DOT_DIR=%USERPROFILE%\repos\dotfiles

rem --- Neovim ---
rem create symbliclinks. Need administrator privilege.
if exist %DOT_DIR%\.vim\init.vim (
    del %DOT_DIR%\.vim\init.vim
)
mklink %DOT_DIR%\.vim\init.vim %DOT_DIR%\.vimrc

if exist %USERPROFILE%\AppData\Local\nvim (
    rmdir %USERPROFILE%\AppData\Local\nvim
)
mklink /D %USERPROFILE%\AppData\Local\nvim %DOT_DIR%\.vim

rem --- Vim ---
rem if exist %USERPROFILE%\.vimrc (
rem     del %USERPROFILE%\.vimrc
rem )
rem mklink %USERPROFILE%\.vimrc %DOT_DIR%\.vimrc

rem if exist %USERPROFILE%\.vim (
rem     rmdir %USERPROFILE%\.vim
rem )
rem mklink /D %USERPROFILE%\.vim %DOT_DIR%\.vim

rem --- Git ---
if exist %USERPROFILE%\.gitconfig (
    del %USERPROFILE%\.gitconfig
)
mklink %USERPROFILE%\.gitconfig %DOT_DIR%\.gitconfig
