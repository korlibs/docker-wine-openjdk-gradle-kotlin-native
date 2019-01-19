#!/usr/bin/env bash
umask 0000
if [ -f /root/.wine/drive_c/users/root/.konan/dependencies/libffi-3.2.1-mingw-w64-x86-64 ]
then
    echo "Unzipping libffi-3.2.1-mingw-w64-x86-64.zip..."
    unzip /libffi-3.2.1-mingw-w64-x86-64.zip /root/.wine/drive_c/users/root/.konan/dependencies
fi
$*