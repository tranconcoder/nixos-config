{ ... }:

{
  home.file = {
    ".config/kitty/kitty.conf".text = ''
      font_size 16.0

      # Clear shortcuts
      clear_shortcuts clear_terminal

      # Ctrl+Backspace to delete word
      map ctrl+backspace send_text normal \x17
      map ctrl+backspace send_text application \x17
    '';
  };
}
