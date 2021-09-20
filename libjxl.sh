#!/bin/sh

source ./0_append_distro_path.sh

untar_file libjxl-0.5.tar --exclude=libjxl-0.5/tools/benchmark/metrics

patch -d /c/temp/gcc/libjxl-0.5 -p1 < libjxl-brotli.patch

cd /c/temp/gcc
mv libjxl-0.5 src
mkdir build dest
cd build

../src/deps.sh

cmake \
"-DBUILD_TESTING=OFF" \
"-DCMAKE_C_FLAGS=-s -O3 -Wno-format -Wno-attributes" \
"-DCMAKE_CXX_FLAGS=-s -O3 -Wno-format -Wno-attributes" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DJPEGXL_ENABLE_BENCHMARK=OFF" \
"-DJPEGXL_ENABLE_EXAMPLES=OFF" \
"-DJPEGXL_ENABLE_MANPAGES=OFF" \
"-DJPEGXL_STATIC=ON" \
-G Ninja /c/temp/gcc/src

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest libjxl-0.5
cd libjxl-0.5
rm -rf FIXME

7z -mx0 a ../libjxl-0.5.7z *
