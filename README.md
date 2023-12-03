<p align="center">
  <h1 align="center">better-ts-errors.nvim</h2>
</p>

<p align="center">
    > If you are unlucky enough to work with TypeScript and stuck in Vim mode (using Neovim tho), then at least have a better formatted TypeScript errors.
</p>

## ⚡️ Features

> Will be added when possible..

- Hihglights variables in error messages
- Uses your current Theme colors, no funky stuff of my own
- Does its best to format JS objects (if they are or TS types mentioned in the error)

## 📋 Installation
### If you want JS Objects in error messages to be formatted, ensure you have Prettier installed and available in PATH.
```
npm install -g prettier
```

> I haven't used any other package managers than folke/lazy.nvim, so not sure exactly how to install it via others, because you need to specify dependency.

<div align="center">
<table>
<thead>
<tr>
<th>Package manager</th>
<th>Snippet</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

</td>
<td>

```lua
-- stable version
-- No idea how to set dependency in packer, pls let me know if you use it
-- You need to have "MunifTanjim/nui.nvim" as Dependency
use {"better-ts-errors.nvim", tag = "*" }
```

</td>
</tr>
<tr>
<td>

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

</td>
<td>

```lua
-- No idea how to set dependency in vim-plug, pls let me know if you use it
-- You need to have "MunifTanjim/nui.nvim" as Dependency
Plug "better-ts-errors.nvim", { "tag": "*" }
```

</td>
</tr>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
-- stable version
return {
  "OlegGulevskyy/better-ts-errors.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = {
    keymap = "<leader>dd"
  }
}
```

</td>
</tr>
</tbody>
</table>
</div>

## ☄ Getting started

Simple thing at the moment - set your keymap via config options `keymap` and use it to `toggle` pretty TS error message

## ⚙ Configuration

> The configuration list sometimes become cumbersome, making it folded by default reduce the noise of the README file.

<details>
<summary>Click to unfold the full list of options with their default values</summary>

> **Note**: The options are also available in Neovim by calling `:h better-ts-errors.options`

```lua
require("better-ts-errors").setup({
    keymap = '<leader>dd' -- Toggling keymap
})
```

</details>

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## 🎭 Motivations

I am forced to work with TypeScript, and at times it can be quite alright, but one thing that sucks from it is its error messages.
This small plugin is inspired by `pretty-ts-errors` for VSCode users.
https://github.com/yoavbls/pretty-ts-errors

So, I'd like to have some niceties in Neovim also, that's it for Motivations section.

### Few things to note:
- I suck at Lua. It's my very first Lua project. I have no idea about Lua's conventions, best practices etc. I am happy to learn and adjust, if you'd be kind enough to point out, in a friendly manner.
- I suck at Neovim plugins. I used a plugins boilerplate (which you can find here - https://github.com/shortcuts/neovim-plugin-boilerplate) to create this plugin. Again, happy to learn and improve, if you are kind enough to point out mistakes. Better yet - suggest improvements in a form of a PR, that I am more than happy to accept.
- In general I am a mediocre programmer, so any weird logic bits you find (and I know there is some and some more), please do let me know, with a way to  improve it. I am very open to it.
- I just needed something working and I didn't plan to open source it as a plugin.
- I plan to add features


## 🪶 Sort of roadmap
- Go to definition of types mentioned in the actual error
- More robust highlighting system (highlight different variable types in different colors)
- Better parsing (show an actual problem of huge nested TS errors on top as first line as these are usually where the issue is really coming from)
- Better testing (I haven't thoroughly tested it at all)
