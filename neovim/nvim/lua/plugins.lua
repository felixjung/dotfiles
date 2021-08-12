local packer = require("util.packer")

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
}

local function plugins(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "marko-cerovac/material.nvim",
    config = function()
      require("config.theme")
    end,
  })

  -- Theme: icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })
end

return packer.setup(config, plugins)
