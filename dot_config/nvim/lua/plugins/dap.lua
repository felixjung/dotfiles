return {
  {
    "mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "delve" },
    },
  },
  {
    "leoluz/nvim-dap-go",
    opts = {
      tests = {
        -- enables verbosity when running the test.
        verbose = false,
      },
    },
  },
}
