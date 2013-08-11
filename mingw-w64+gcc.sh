#!/bin/sh

source 0_append_distro_path.sh

# Extract vanilla sources.
7z x '-oC:\Temp\gcc' mingw-w64-code-5986-trunk.zip > NUL || fail_with mingw-w64-code-5986-trunk.zip - EPIC FAIL
7z x '-oC:\Temp\gcc' gcc-4.8.1.tar > NUL || fail_with gcc-4.8.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gmp-5.1.2.tar > NUL || fail_with gmp-5.1.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpfr-3.1.2.tar > NUL || fail_with mpfr-3.1.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpc-1.0.1.tar > NUL || fail_with mpc-1.0.1.tar - EPIC FAIL

# Change the default mode to C++11.
patch -d /c/temp/gcc/gcc-4.8.1 -p1 < gcc.patch

cd /c/temp/gcc

# Build mingw-w64.
mv mingw-w64-code-5986-trunk src
mkdir build dest
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-lib32 --prefix=/c/temp/gcc/dest/x86_64-w64-mingw32 --with-sysroot=/c/temp/gcc/dest/x86_64-w64-mingw32 --enable-wildcard || fail_with mingw-w64 configure - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with mingw-w64 make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

# Prepare to build gcc - set up the in-tree builds of gmp, mpfr, and mpc.
mv gcc-4.8.1 src
mv gmp-5.1.2 src/gmp
mv mpfr-3.1.2 src/mpfr
mv mpc-1.0.1 src/mpc

# Prepare to build gcc - perform magic directory surgery.
cp -r dest/x86_64-w64-mingw32/lib dest/x86_64-w64-mingw32/lib64
cp -r dest/x86_64-w64-mingw32 dest/mingw
mkdir -p src/gcc/winsup/mingw
cp -r dest/x86_64-w64-mingw32/include src/gcc/winsup/mingw/include

# Configure.
mkdir build
cd build
../src/configure --enable-languages=c,c++ --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/dest --with-sysroot=/c/temp/gcc/dest --disable-libstdcxx-pch --disable-lto --disable-nls --disable-shared --disable-win32-registry --enable-checking=release --with-tune=core-avx-i || fail_with gcc configure - EPIC FAIL

# --enable-languages=c,c++        : I want C and C++ only.
# --build=x86_64-w64-mingw32      : I want a native compiler.
# --host=x86_64-w64-mingw32       : Ditto.
# --target=x86_64-w64-mingw32     : Ditto.
# --disable-multilib              : I want 64-bit only.
# --prefix=/c/temp/gcc/dest       : I want the compiler to be installed here.
# --with-sysroot=/c/temp/gcc/dest : Ditto. (This one is important!)
# --disable-libstdcxx-pch         : I don't use this, and it takes up a ton of space.
# --disable-lto                   : http://sourceforge.net/apps/trac/mingw-w64/wiki/LTO%20and%20GCC
# --disable-nls                   : I don't want Native Language Support.
# --disable-shared                : I don't want DLLs.
# --disable-win32-registry        : I don't want this abomination.
# --enable-checking=release       : I don't want expensive checking if this came from SVN or a snapshot.
# --with-tune=core-avx-i          : Tune for Ivy Bridge by default.

# Build and install.
make bootstrap install "CFLAGS=-g0 -O3" "CXXFLAGS=-g0 -O3" "CFLAGS_FOR_TARGET=-g0 -O3" "CXXFLAGS_FOR_TARGET=-g0 -O3" "BOOT_CFLAGS=-g0 -O3" "BOOT_CXXFLAGS=-g0 -O3" || fail_with gcc make - EPIC FAIL

# Cleanup.
cd /c/temp/gcc
rm -rf build src
mv dest mingw-w64+gcc
cd mingw-w64+gcc
find -name "*.la" -type f -print -exec rm {} ";"
rm -rf bin/c++.exe bin/x86_64-w64-mingw32-* share
rm -rf mingw x86_64-w64-mingw32/lib64
find -name "*.exe" -type f -print -exec strip -s {} ";"

7z -mx0 a ../mingw-w64+gcc.7z *