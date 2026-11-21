# ja++

ja++ modification for jedi academy - best used with [openjk](http://github.com/JACoders/OpenJK)  
see [japp.jkhub.org](http://japp.jkhub.org) for more information

[![build](https://github.com/Razish/japp/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/Razish/japp/releases/tag/latest)

## supports

| | Windows | Linux | macOS |
| - | - | - | - |
| x86 | ✅ | ✅ | ❓ |
| x86_64 | ✅ | ✅ | ✅ |
| Arm (RPi) | ❌ | ✅ | ❌ |
| Apple Silicon | ❌ | ❌ | ✅ |

## development requirements (general)

- Python 3.11
- [Scons](https://github.com/SCons/scons) 4.4

### windows

[TDM-GCC](https://jmeubank.github.io/tdm-gcc/) or MSVC (if you pass `tools=default` to scons)

### linux (debian-based)

- `git scons gcc g++ libreadline-dev`
- [asdf-vm](https://asdf-vm.com/guide/getting-started.html) (optional, recommended)

## compiling

just run `scons` or `build.sh`

Options:

- `force32` 1 to build a 32-bit binary on a 64-bit machine
- `debug` 1 to generate debug information, 2 to also optimise code
- `no_sql` 1 to disable MySQL/SQLite support
- `no_crashhandler` 1 to disable the crash handler/logger functionality

Environment Variables

- `NO_SSE` 1 to not generate SSE2 instructions - closer to basejka. This is used for official builds
- `MORE_WARNINGS` 1 to enable more compiler warnings

## WebAssembly (OpenJK Web)

Build `SIDE_MODULE=2` `.wasm` modules (`cgamewasm32.wasm`, `jampgamewasm32.wasm`, `uiwasm32.wasm`) and package a ready-to-import `japp-wasm.zip` for [openjk-wasm](https://github.com/pdewilde/openjk-wasm):

```bash
source /path/to/emsdk/emsdk_env.sh
bash build-wasm.sh
```

Then drag and drop `dist-wasm/japp-wasm.zip` into the **Multiplayer Mods** section on [openjk.pdewil.de](https://openjk.pdewil.de/).

## contributors ([full list](https://github.com/Razish/japp/graphs/contributors))

- Raz0r (lead)
- AstralSerpent
- Ensiform
- EpicLoyd
- Morabis
- teh

## credits

- JK2MV
- loda
- OJP
- OpenJK
