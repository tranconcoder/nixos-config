# Remove Copilot from nvim-v2 repo & update NixOS

## 1. Clone & modify repo

```bash
cd /tmp
git clone git@github.com:tranconcoder/nvim-v2.git nvim-v2-cleanup
cd nvim-v2-cleanup

# Xóa file copilot plugin
rm lua/modules/plugins/copilot.lua

# Xóa entry copilot.vim trong lazy-lock.json
python3 -c "
import json
with open('lazy-lock.json') as f:
    d = json.load(f)
del d['copilot.vim']
with open('lazy-lock.json', 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
"

# Commit & push
git add -A
git commit -m "Remove copilot.vim plugin"
git push origin main
```

## 2. Update nixos-config flake

```bash
cd ~/nixos-config
nix flake lock --update-input nvim-v2
```

## 3. Rebuild NixOS

```bash
sudo nixos-rebuild switch --flake .#nixos
```

## 4. Cleanup nvim data (xóa plugin copilot đã cài local)

```bash
rm -rf ~/.local/share/nvim/lazy/copilot.vim
```