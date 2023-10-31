# Tools for development

* This is basic toolset of tools for Ufolinux development environment. Sets up everything from pkg management to source clones ( basic env for all new devs )

# Packages needed to work with these scriptlets

```
## modules deps ( docker, mkiso and builder )
$ kepler -Syu --needed make cmake docker ninja meson llvm clang bash libisofs libisoburn
```

## Getting started

Use directory named as ufo in home directory of user ( user with sudo powers )

```
$ cd ~ && mkdir ufo && git clone https://github.com/ufolinux/toolset.git

$ ln -sf toolset/envsetup.sh envsetup

$ ./envsetup -h

$ ./envsetup --mkiso
```
