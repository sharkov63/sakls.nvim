# sakls.nvim
Syntax-Aware Keyboard Layout Switching ([SAKLS](https://github.com/sharkov63/sakls)) plugin for [Neovim](https://neovim.io/)!

![sakls nvim-tex-demo](https://github.com/sharkov63/sakls.nvim/assets/39223464/85014f6a-25c7-49e7-a95f-68122b44e5fa)

When editing a file containing text in multiple languages, there is always the burden of manually switching keyboard layout. A notable example (which was actually the motivation behind this project) is writing [TeX](https://en.wikipedia.org/wiki/TeX) documents in a non-English language. While the text has to be typed in that other language, the formulae (in math mode) still have to be entered in English!

[SAKLS project](https://github.com/sharkov63/sakls) aims to eliminate this inconvenience by automatically switching keyboard layout based on the syntax information in the current window. SAKLS aims to become a large project, supporting many platforms and many text editors; `sakls.nvim` plugin is only a small fraction of the project, providing Neovim support.

## Key Features

* Automatic switching of the current keyboard layout upon a transition to a new syntax element in Vim buffer, which is when
  * writing text and/or moving cursor in insert mode;
  * entering or exiting insert mode.
* Layout switching algorithm is flexibly configured by a _SAKLS schema_ (TODO insert link).
* Potential support for many platforms via selecting a suitable layout backend (TODO insert link) in SAKLS library.
  * However, at this moment only [xkb-switch](https://github.com/grwlf/xkb-switch) layout backend is supported, which is for Unix platforms with [X server](https://x.org/wiki/).
* Potential support for many _syntax providers_ (TODO insert link), like tree-sitter, or (perhaps) LSP.
  * However, at this moment the only supported syntax provider is the provider based on native Vim syntax highlighting, called here `vimsyn`.

## Install

* Obtain SAKLS shared library by following instructions from [SAKLS repository](https://github.com/sharkov63/sakls).
* Make sure that SAKLS library is compiled with your preferred layout backend (TODO insert link). Alternatively, obtain a suitable layout plugin (TODO insert link).
* Install `sakls.nvim` plugin in Neovim with your favorite package manager. For example, with [packer.nvim](https://github.com/wbthomason/packer.nvim) you would say
    ```lua
    use 'sharkov63/sakls.nvim'
    ```

## Quick Start

First step is to initialize `sakls.nvim` by calling `init` function. For example:
```lua
local sakls = require 'sakls'
sakls.init {
  sakls_lib = {
    path = '/home/danila/workspace/sakls/sakls/build/lib/libSAKLS.so',
  },
  layout_backend = 'xkb-switch',
}
```
