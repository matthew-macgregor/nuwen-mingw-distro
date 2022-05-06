# MinGW Distro: [nuwen.net/mingw.html](https://nuwen.net/mingw.html)

This document describes the process to build the nuwen.net mingw distribution in greater detail. It took me several different attempts to get this right, so I'm going to capture the details for next time.

Original distro maintainer: [Stephan J. Lavavej](https://nuwen.net/mingw.html)<br>
Updates and detailed notes: [Matthew MacGregor](https://bytecoil.com)

## Install Prerequisites

See the Download Links section below to install the following:

- 7-zip
- MSYS2

You don't need the installer for MSYS2, just get the prebuilt tar.xz.

- Extract `msys2` to `C:\Temp\msys64`.
- Run `msys2_shell.cmd`. Restart MSYS2 when you're instructed.
- Run `pacman -Syuu` until you see the message:

```
  :: Synchronizing package databases...
   mingw32 is up to date
   mingw64 is up to date
   ucrt64 is up to date
   clang64 is up to date
   msys is up to date
  :: Starting core system upgrade...
   there is nothing to do
  :: Starting full system upgrade...
   there is nothing to do
```

Install the build dependencies:

```
pacman -Su cmake diffutils m4 make nasm ninja patch tar texinfo
pacman -Syuu
```

Answer `Y` if you're asked:

```
  :: Replace pkg-config with msys/pkgconf? [Y/n]
```

## Install MinGW Distribution

Download the latest distribution of the nuwen mingw tools: https://nuwen.net/mingw.html. Extract to `C:\MinGW` (the `bin` folder should be at `C:\MinGW\bin`). Alternatively, you can also use a previous version of the distribution that you built from scratch.

The folder structure will look like this:

```
C:\MinGW                           => Current version of the Nuwen MinGW Distribution
C:\Temp
C:\Temp\gcc                        => working folder for builds
C:\Temp\msys64                     => MSYS2 directory
C:\Temp\gcc\scripts-VERSION        => clone https://github.com/StephanTLavavej/mingw-distro to here
C:\Temp\gcc\scripts-VERSION\*.tar  => place sources alongside of the build scripts 
```

You will of course need to extract the tar file from each component's source distribution. An easy (but manual) way is to open the compressed file in 7-zip and simply drag-and-drop the `.tar` file to Windows Explorer.

TODO: command line from bash for extracting to tar files.

## The Builds

To build each component, open the `msys2` shell and run the build script. It's highly recommended to build each individually, for example:

`./binutils.sh`

A successful build will result in a 7z file in the `C:\Temp\gcc` folder, which is one component. Extracting all the components to a folder and adding the batch files will create the entire distribution.

You can, of course, decide which components you want to build to customize your distro. You definitely need `gcc` and `binutils`.

## Download Links (Distro Version 18)

PGP Verify: `gpg --verify x.y.z.sig` or `gpg --verify --keyring ./gnu-keyring.gpg foo.tar.xz.sig`

- [MSYS2](https://github.com/msys2/msys2-installer/releases/latest)
  - [msys2-base-x86_64-20220319.tar.xz](https://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-20220319.tar.xz)
  - [msys2-base-x86_64-20220319.tar.xz.sig](https://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-20220319.tar.xz.sig)
  - [Pubkey](http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0ebf782c5d53f7e5fb02a66746bd761f7a49b0ec)
  - Download: `msys2-base-x86_64-<RELEASE_DATE>.tar.xz`
- Nuwen MinGW Distributions:
  - [Nuwen Git Repo](https://github.com/StephanTLavavej/mingw-distro)
  - [mingw-18.0.exe](https://nuwen.net/files/mingw/mingw-18.0.exe)
  - [mingw-18.0-without-git.exe](https://nuwen.net/files/mingw/mingw-18.0-without-git.exe)
  - I used the first one (with git) for my local build.
  - [components-18.0.7z](https://nuwen.net/files/mingw/components-18.0.7z): Pre-compiled individual components if you want to pick and choose.

- [MinGW 64](https://www.mingw-w64.org/)
  - Public key: `gpg --recv-keys CAF5641F74F7DFBA88AE205693BDB53CD4EBC740`
  - [Releases](https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/)
  - [MinGW 64 v9.0.0](https://iweb.dl.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v9.0.0.zip)
  - [MinGW 64 v9.0.0 Signature](https://iweb.dl.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v9.0.0.zip.sig)
  - PGP Key: `CAF5641F74F7DFBA88AE205693BDB53CD4EBC740`
  - SHA256: `1929b94b402f5ff4d7d37a9fe88daa9cc55515a6134805c104d1794ae22a4181`
- [gcc](https://www.gnu.org/software/gcc/)
  - [gcc-11.2.0](https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/)
  - [gcc-11.2.0.tar.gz](https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz)
  - [gcc-11.2.0.tar.gz.sig](https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz.sig)
- [gnu gcc infra server](https://gcc.gnu.org/pub/gcc/infrastructure/)
  - [GNU Keyring gnu-keyring.gpg](https://ftp.gnu.org/gnu/gnu-keyring.gpg)
     - Verify files: `gpg --verify --keyring ./gnu-keyring.gpg foo.tar.xz.sig`
  - [sha512](https://gcc.gnu.org/pub/gcc/infrastructure/sha512.sum)
  - [md5](https://gcc.gnu.org/pub/gcc/infrastructure/md5.sum)
  - [isl-0.24.tar.bz2](https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2)
  - Note: couldn't find a signature for `isl-0.24`, but verified its sha512 checksum:  
    - `aab3bddbda96b801d0f56d2869f943157aad52a6f6e6a61745edd740234c635c38231af20bc3f1a08d416a5e973a90e18249078ed8e4ae2f1d5de57658738e95  isl-0.24.tar.bz2`
  - [mpc-1.2.1.tar.gz](https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz)
  - [mpc-1.2.1.tar.gz.sig](https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz.sig)
  - [mpfr-4.1.0.tar.gz](https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.gz)
  - [mpfr-4.1.0.tar.gz.asc](https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.gz.asc)
  - [gmplib GNU Bignum Library](https://gmplib.org/)
    - [gmp-6.2.1.tar.xz](https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz)
    - [gmp-6.2.1.tar.xz.sig](https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz.sig)
- [binutils](https://www.gnu.org/software/binutils/)
  - [binutils-2.37.tar.gz](http://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.gz)
  - [binutils-2.37.tar.gz.sig](http://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.gz.sig)

## [Download Links (Original)](https://nuwen.net/mingw.html)
<table class="border ratings">
<tr>
<td>Essentials
</td><td>Libraries
</td><td>Utilities
</td><td>Utilities (Binary)
</td></tr><tr>
<td><a href="https://ftp.gnu.org/gnu/binutils/?C=N;O=D">binutils 2.37</a>
</td><td><a href="https://www.boost.org">Boost 1.77.0</a>
</td><td><a href="https://ftp.gnu.org/gnu/coreutils/?C=N;O=D">coreutils 9.0</a> ***
</td><td><a href="https://7-zip.org">7-Zip 19.00</a>
</td></tr><tr>
<td><a href="https://gcc.gnu.org">GCC 11.2.0</a>
</td><td><a href="https://freetype.org">FreeType 2.11.0</a>
</td><td><a href="https://ftp.gnu.org/gnu/gdb/?C=N;O=D">gdb 11.1</a>
</td><td><a href="https://github.com/cli/cli">gh 2.2.0</a>
</td></tr><tr>
<td><a href="https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/">mingw-w64 9.0.0</a>
</td><td><a href="https://github.com/cginternals/glbinding">glbinding 3.1.0</a>
</td><td><a href="https://ftp.gnu.org/gnu/grep/?C=N;O=D">grep 3.7</a>
</td><td><a href="https://git-scm.com">git 2.33.1</a>
</td></tr><tr>
<td></td><td><a href="https://www.glfw.org">GLFW 3.3.5</a>
</td><td><a href="https://sourceforge.net/projects/lame/files/lame/">LAME 3.100</a>
</td><td></td></tr><tr>
<td></td><td><a href="https://github.com/g-truc/glm">GLM 0.9.9.8</a>
</td><td><a href="https://ftp.gnu.org/gnu/make/?C=N;O=D">make 4.3</a>
</td><td></td></tr><tr>
<td></td><td><a href="https://libjpeg-turbo.org">libjpeg-turbo 2.1.1</a> *
</td><td><a href="https://sourceforge.net/projects/optipng/files/OptiPNG/">OptiPNG 0.7.7</a>
</td><td></td></tr><tr>
<td></td><td><a href="https://xiph.org/downloads/">libogg 1.3.5</a>
</td><td><a href="http://libpng.org/pub/png/apps/pngcheck.html">pngcheck 3.0.3</a>
</td><td></td></tr><tr>
<td></td><td><a href="http://libpng.org/pub/png/libpng.html">libpng 1.6.37</a>
</td><td><a href="https://ftp.gnu.org/gnu/sed/?C=N;O=D">sed 4.8</a>
</td><td></td></tr><tr>
<td></td><td><a href="https://xiph.org/downloads/">libvorbis 1.3.7</a>
</td><td><a href="https://xiph.org/downloads/">vorbis-tools 1.4.2</a>
</td><td></td></tr><tr>
<td></td><td><a href="https://pcre.org">PCRE 8.45</a> **
</td><td></td><td></td></tr><tr>
<td></td><td><a href="https://pcre.org">PCRE2 10.37</a> **
</td><td></td><td></td></tr><tr>
<td></td><td><a href="https://libsdl.org">SDL 2.0.16</a>
</td><td></td><td></td></tr><tr>
<td></td><td><a href="https://libsdl.org/projects/SDL_mixer/">SDL_mixer 2.0.4</a>
</td><td></td><td></td></tr><tr>
<td></td><td><a href="https://zlib.net">zlib 1.2.11</a>
</td><td></td><td></td></tr><tr>
<td></td><td><a href="https://github.com/facebook/zstd">zstd 1.5.0</a>
</td><td></td><td></td></tr>
<tr><td colspan=4>
* With jpegtran.<br>
** With pcregrep and pcre2grep.<br>
*** Only sort, uniq, and wc.<br>
</td></tr>
</table>

## Verify GNU Signatures

From [the GNU project README](https://ftp.gnu.org/README):

There are also .sig files, which contain detached GPG signatures of the above
files, automatically signed by the same script that generates them.

You can verify the signatures for gnu project files with the keyring file from:
  https://ftp.gnu.org/gnu/gnu-keyring.gpg

In a directory with the keyring file, the source file to verify and the
signature file, the command to use is:

  `$ gpg --verify --keyring ./gnu-keyring.gpg foo.tar.xz.sig`

## Windows Sandbox

To allow for a clean and reproducible build, I've been using [Windows Sandbox](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview) to create a temporary workspace. Create a file called `Sandbox.wsb` and put it into the host folder. Change the `<HostFolder>` path in the XML to match.

Windows Sandbox is a feature only available in Windows Pro.

```xml
<Configuration>
  <VGpu>Disable</VGpu>
  <Networking>Default</Networking>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\Users\YOUR_USER\host-path\nuwen-mingw-build</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Desktop\nuwen-mingw-build</SandboxFolder>
      <ReadOnly>false</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>cmd</Command>
  </LogonCommand>
</Configuration>
```

### Minor Modifications

I made a few tweaks to the build scripts. In `0_append_distro_path.sh`:

```
 function untar_file {
-    tar --extract --directory=/c/temp/gcc --file=$*
+    tar --extract --overwrite --directory=/c/temp/gcc --file=$*
 }
```

In `mingw-w64+gcc.sh`:

```diff
-mkdir build-mingw-w64 dest
+mkdir -p build-mingw-w64 dest

...

 # Prepare to build gcc.
-mv gcc-11.2.0 src
-mv gmp-6.2.1 src/gmp
-mv mpfr-4.1.0 src/mpfr
-mv mpc-1.2.1 src/mpc
-mv isl-0.24 src/isl
+mv -f gcc-11.2.0 src
+mv -f gmp-6.2.1 src/gmp
+mv -f mpfr-4.1.0 src/mpfr
+mv -f mpc-1.2.1 src/mpc
+mv -f isl-0.24 src/isl

...

-../src/configure --enable-languages=c,c++ --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 \
+../src/configure --enable-languages=c,c++,fortran --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 \
```

Fortran is a must for my purposes, modify `--enable-languages` as needed.

## Important Notes from Stephan Lavavej

The build scripts assume that:

* `C:\MinGW` contains the current (previous) version of the distro.
  + This assumption is centralized in `0_append_distro_path.sh`, where it says `export X_DISTRO_ROOT=/c/mingw`.
* `C:\Temp\gcc` is usable as a working directory.
  + This assumption isn't centralized.
* The build scripts live next to the sources, *not* directly within `C:\Temp\gcc`.
  + I put the build scripts and the sources into `C:\Temp\gcc\sources-VERSION`.

I **highly** recommend that you execute each build script **by hand** before attempting to run it in one shot.

> Stephan T. Lavavej - stl@nuwen.net