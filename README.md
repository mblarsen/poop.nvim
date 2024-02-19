# DISCLAIMER
This is a lua implementation of https://github.com/ddl004/poop.nvim I created because I couldn't figure out how to use pynvim 🤦.

All credit goes to ddl004.

I'm not going to maintain this and the repo only servers as a way for testing ddl004/poop.nvim without having to set up pynvim if you are having trouble doing that.

# 💩 poop.nvim
A neovim plugin to help embrace the code smell.

![Peek 2024-01-02 20-46](https://github.com/ddl004/poop.nvim/assets/18647028/236436d8-971e-4880-bb3c-15de9e1c6827)

## Features
- Call `eject` to eject from the current cursor position!
    - Takes two arguments, `left` and `right`. e.g. `:lua require('poop').setup().eject(💩,💀)`
- Option for customizing the projectile ejected and animation properties.
- Optional configuration provided to eject emojis randomly while in insert mode.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

<details>
<summary>simple setup (ejects poop all the time)</summary>

```lua
return {
  "mblarsen/poop.nvim",
  config = function()
    local poop = require('my-plugins.poop').setup()

    vim.on_key(function()
      if vim.api.nvim_get_mode().mode ~= 'i' then
        return
      end

      vim.schedule_wrap(function()
        poop.eject()
      end)()
    end, nil)

  end
}
```
</details>

<details>
<summary>ejects poop occasionally</summary>

```lua
return {
  "mblarsen/poop.nvim",
  config = function()
    local poop = require('my-plugins.poop').setup()

    local period = 10

    vim.on_key(function()
      if vim.api.nvim_get_mode().mode ~= 'i' then
        return
      end

      vim.schedule_wrap(function()
        local should_eject = math.random(1, period) == 1
        if should_eject then
          poop.eject()
        end
      end)()
    end, nil)

  end
}
```
</details>

<details>
<summary>ejects multiple emojis</summary>

```lua
return {
  "mblarsen/poop.nvim",
  config = function()
    local poop = require('my-plugins.poop').setup()
    local emojis = { '💩', '🌈', '👻' }

    local period = 10

    vim.on_key(function()
      if vim.api.nvim_get_mode().mode ~= 'i' then
        return
      end

      vim.schedule_wrap(function()
        local left = emojis[math.random(1, #emojis)]
        local right = emojis[math.random(1, #emojis)]
        local should_eject = math.random(1, period) == 1
        if should_eject then
          poop.eject(left, right)
        end
      end)()
    end, nil)

  end
}
```
</details>

## License
This project is licensed under the MIT License.

## Related
This project was inspired by [duck.nvim](https://github.com/tamton-aquib/duck.nvim)
