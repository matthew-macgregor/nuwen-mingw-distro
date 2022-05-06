# MinGW Distro: [nuwen.net/mingw.html](https://nuwen.net/mingw.html)

Update 5/5/2022:

- More detailed instructions added by Matthew MacGregor. See [Readme detailed](./README_detailed.md).

Here are the build scripts for my MinGW distro.

You'll need to run them in MSYS2, which you can set up without an installer:

* Go to: https://github.com/msys2/msys2-installer/releases/latest
* Download: `msys2-base-x86_64-<RELEASE_DATE>.tar.xz`
* Extract it to: `C:\Temp\msys64`
* Run: `msys2_shell.cmd`
* Restart MSYS2 when you're instructed to.
* In MSYS2, repeatedly run `pacman -Syuu` until you see:
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
* In MSYS2, run: `pacman -Su cmake diffutils m4 make nasm ninja patch tar texinfo`
* In MSYS2, repeatedly run `pacman -Syuu` again. Answer `Y` if you're asked:
  ```
  :: Replace pkg-config with msys/pkgconf? [Y/n]
  ```
* You can customize the terminal's appearance with **Right Click > Options...**. I prefer:
  + Text: Consolas, 16pt
  + Window: 120 Columns, 50 Rows

## Important Notes

The build scripts assume that:

* `C:\MinGW` contains the previous version of the distro.
  + This assumption is centralized in `0_append_distro_path.sh`, where it says `export X_DISTRO_ROOT=/c/mingw`.
* `C:\Temp\gcc` is usable as a working directory.
  + This assumption isn't centralized.
* The build scripts live next to the sources, *not* directly within `C:\Temp\gcc`.
  + I put the build scripts and the sources into `C:\Temp\gcc\sources-VERSION`.

I **highly** recommend that you execute each build script **by hand** before attempting to run it in one shot.

Stephan T. Lavavej - stl@nuwen.net
