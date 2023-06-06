dotfiles:
  #!/bin/bash
  echo "Create directories"
  mkdir -p $HOME/.config/autostart
  mkdir -p $HOME/.config/git
  mkdir -p $HOME/.config/tmux
  mkdir -p $HOME/.config/zsh
  mkdir -p $HOME/.local/share/distrobox/home/dev/.config/VSCodium/User
  mkdir -p $HOME/.local/share/distrobox/home/dev/.config/git
  mkdir -p $HOME/.local/share/distrobox/home/dev/C/
  mkdir -p $HOME/.local/share/distrobox/home/dev/R/
  mkdir -p $HOME/.local/share/distrobox/home/dev/go/
  mkdir -p $HOME/.local/share/distrobox/home/dev/julia/
  mkdir -p $HOME/.local/share/distrobox/home/dev/latex/
  mkdir -p $HOME/.local/share/distrobox/home/dev/misc/
  mkdir -p $HOME/.local/share/distrobox/home/dev/octave/
  mkdir -p $HOME/.local/share/distrobox/home/dev/python/
  mkdir -p $HOME/.local/share/distrobox/home/dev/rust/
  mkdir -p $HOME/Sync/
  echo "Copying files over"
  cp files/git/config $HOME/.config/git/config
  cp files/git/config $HOME/.local/share/distrobox/home/dev/.config/git/config
  cp files/syncthing/stignore $HOME/Sync/.stignore
  cp files/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
  cp files/zsh/zshrc $HOME/.zshrc
  cp files/autostart/org.ferdium.Ferdium.desktop $HOME/.config/autostart/org.ferdium.Ferdium.desktop
  cp files/vscode/*.json $HOME/.local/share/distrobox/home/dev/.config/VSCodium/User/
  echo "Removing unwanted files"
  if [ -f $HOME/.local/share/applications/dev.desktop ]; then rm $HOME/.local/share/applications/dev.desktop; fi

system user_password=`read -p 'Sudo password: ' -s password && echo $password`:
  #!/bin/bash
  echo "Copying over system files and configurations"
  set -e
  cmp -s /etc/hosts files/hosts || echo "{{user_password}}" | sudo -S cp files/hosts /etc/hosts
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S mkdir -p /etc/dconf/db/gdm.d
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S mkdir -p /etc/dconf/db/local.d
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S mkdir -p /etc/dconf/profile
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S cp files/dconf/db/gdm.d/* /etc/dconf/db/gdm.d/
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S cp files/dconf/db/local.d/* /etc/dconf/db/local.d/
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S cp files/dconf/profile/* /etc/dconf/profile/
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S dconf update
  [ "$SHELL" = "/bin/zsh" ] || echo "{{user_password}}" | chsh -s /bin/zsh
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S flatpak override --env=GTK_THEME="Adwaita-dark"
  [ -f /usr/bin/gnome-shell ] && echo "{{user_password}}" | sudo -S flatpak override --env=ICON_THEME="Papirus-Dark"

gnome-settings gnome_terminal_profile=`gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'"`:
  #!/bin/bash
  xdg-settings set default-web-browser com.brave.Browser.desktop
  if ! [ -f $HOME/.var/app/org.ferdium.Ferdium/config/Ferdium/config/settings.json ]; then
    echo "Opening Ferdium to generate config file"
    flatpak run org.ferdium.Ferdium > /dev/null 2>&1 &
    while ! [ -f $HOME/.var/app/org.ferdium.Ferdium/config/Ferdium/config/settings.json ]; do sleep 1; done
    sleep 5
    jq ".startMinimized=true" $HOME/.var/app/org.ferdium.Ferdium/config/Ferdium/config/settings.json > $HOME/.var/app/org.ferdium.Ferdium/config/Ferdium/config/settings.json.tmp && mv $HOME/.var/app/org.ferdium.Ferdium/config/Ferdium/config/settings.json.tmp $HOME/.var/app/org.ferdium.Ferdium/config/Ferdium/config/settings.json
    pkill ferdium
  fi
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'gtk-launch dev-emacsclient.desktop'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "'gtk-launch org.ferdium.Ferdium.desktop'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "'gtk-launch net.lutris.Lutris.desktop'"
  gsettings set org.gnome.shell favorite-apps "['com.brave.Browser.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop']"
  dconf write /org/gnome/terminal/legacy/profiles:/:{{gnome_terminal_profile}}/use-system-font false
  dconf write /org/gnome/terminal/legacy/profiles:/:{{gnome_terminal_profile}}/use-transparent-background true
  dconf write /org/gnome/terminal/legacy/profiles:/:{{gnome_terminal_profile}}/background-transparency-percent 15

dev-python:
  #!/bin/bash
  distrobox enter dev -- "sudo pacman -S --noconfirm --needed ipython python python-pipx tk pyright"
  echo 'for package in black jupyter-core mypy pytest isort pyflakes pycodestyle pydocstyle; do pipx install $package; done' | distrobox enter dev

dev-R:
  #!/bin/bash
  echo "mkdir -p ~/R/lib" | distrobox enter dev
  echo 'echo "R_LIBS_USER=~/R/lib" > ~/.Renviron' | distrobox enter dev
  distrobox enter dev -- "sudo pacman -S --noconfirm --needed r r-nnet r-mass"
  echo "R -e 'install.packages(c(\"RSNNS\", \"gam\", \"glmnet\", \"languageserver\", \"leaps\", \"testthat\", \"tidyverse\", \"tree\"), repos=\"https://cloud.r-project.org\")'" | distrobox enter dev

dev-julia:
  #!/bin/bash
  echo '[ -f $HOME/.juliaup/bin/juliaup ] && $HOME/.juliaup/bin/juliaup update' | distrobox enter dev
  echo '[ -f $HOME/.juliaup/bin/juliaup ] || curl -fsSL https://install.julialang.org | sh -s -- --yes' | distrobox enter dev
  echo 'sudo ln -s ~/.juliaup/bin/julia /usr/bin/julia' | distrobox enter dev
  echo '$HOME/.juliaup/bin/julia -e "using Pkg; Pkg.add.([\"Distributions\", \"Plots\", \"LanguageServer\", \"JuliaFormatter\", \"IJulia\"])"' | distrobox enter dev

dev-latex:
  #!/bin/bash
  distrobox enter dev -- "sudo pacman -S --noconfirm --needed pandoc texlive"
