{ ... }:

{
  home.file = {
    ".config/fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=unikey

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=unikey
      Layout=

      [GroupOrder]
      0=Default
    '';

    ".config/fcitx5/config".text = ''
      [Hotkey]
      TriggerKey=Super+space
    '';

    ".config/fcitx5/addon/unikey.conf".text = ''
      [Addon]
      Name=unikey
      Version=5.1.9
      Comment=Unikey input method for Fcitx5
      Category=InputMethod
      GeneralConfig=unikey:profile
      Module=libunikey.so
      Enabled=True
    '';

    ".config/fcitx5/inputmethod/unikey.conf".text = ''
      [InputMethod]
      Name=Unikey
      Code=unikey
      Annotation=Unikey Vietnamese Input Method
      Icon=org.fcitx.Fcitx5.fcitx-unikey
      Label=VI
      Lang[vi]=Vietnamese
      Lang[en]=English
      Enabled=True
    '';
  };
}
