{ inputs, ... }:

{
  home.file = {
    ".config/nvim" = {
      source = inputs.nvim-v2.outPath;
      recursive = true;
    };
    ".config/nvim/lazy-lock.json" = {
      source = "${inputs.nvim-v2}/lazy-lock.json";
    };
  };
}
