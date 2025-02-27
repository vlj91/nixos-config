# notfiles
Not dotfiles (nix + nix-darwin + home-manager)

### Setup (wip)
1. Sign into App Store to allow installation of Mac Apps
2. Install xcode command line tools
```sh
xcode-select --install
```
3. Install nix with the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --no-confirm
```