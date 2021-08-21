local M = {}

function M.bootstrap()
  local fn = vim.fn
  -- TODO: what's the actual location here?
  local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd("packadd packer.nvim")
  end
  vim.cmd([[packadd packer.nvim]])
  vim.cmd("autocmd BufWritePost plugins.lua PackerCompile") -- Auto compile when there are changes in plugins.lua
end

function M.get_name(pkg)
  local parts = vim.split(pkg, "/")
  return parts[#parts], parts[1]
end

function M.setup(config, fn)
  -- HACK: see https://github.com/wbthomason/packer.nvim/issues/180
  vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")

  M.bootstrap()
  local packer = require("packer")
  packer.init(config)
  return packer.startup({
    function(use)
      fn(use)
    end,
  })
end

return M
