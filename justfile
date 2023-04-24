install-dotfiles:
  #!/bin/bash
  echo "Create directories"
  mkdir -p $HOME/.config/autostart
  mkdir -p $HOME/.config/git
  mkdir -p $HOME/.config/tmux
  mkdir -p $HOME/.config/zsh
  mkdir -p $HOME/.local/share/distrobox/home/dev/.config/VSCodium/User
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
  cp files/syncthing/stignore $HOME/Sync/.stignore
  cp files/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
  cp files/zsh/zshrc $HOME/.zshrc
  cp files/autostart/org.ferdium.Ferdium.desktop $HOME/.config/autostart/org.ferdium.Ferdium.desktop
  cp files/vscode/*.json $HOME/.local/share/distrobox/home/dev/.config/VSCodium/User/
  echo "Copying over system files"
  cmp -s /etc/hosts files/hosts || sudo cp files/hosts /etc/hosts

set-shell:
  #!/bin/bash
  [ "$SHELL" = "/bin/zsh" ] || chsh -s /bin/zsh

user-gnome-settings:
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
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'gtk-launch dev-codium.desktop'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "'gtk-launch org.ferdium.Ferdium.desktop'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "'gtk-launch net.lutris.Lutris.desktop'"
  gsettings set org.gnome.shell favorite-apps "['com.brave.Browser.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop']"

setup-dev-python:
  #!/bin/bash
  distrobox enter dev -- "sudo dnf install -y ipython python-unversioned-command python3 python3-pip python3-tkinter"
  distrobox enter dev -- "pip install black jupyter matplotlib mypy numpy pandas pytest scikit-learn scipy seaborn"

setup-dev-R:
  #!/bin/bash
  distrobox enter dev -- "sudo dnf -y copr enable iucar/cran"
  distrobox enter dev -- "sudo dnf install -y R R-CoprManager"
  distrobox enter dev -- "R -e 'install.packages(c(\"MASS\", \"RSNNS\", \"gam\", \"glmnet\", \"languageserver\", \"leaps\", \"nnet\", \"testthat\", \"tidyverse\"), repos=\"https://cloud.r-project.org\")'"

setup-dev-julia:
  #!/bin/bash
  distrobox enter dev -- "sudo dnf install -y julia"
  distrobox enter dev -- "julia -e 'using Pkg; Pkg.add.([\"Distributions\", \"Plots\"])'"

setup-dev-latex:
  #!/bin/bash
  distrobox enter dev -- "sudo dnf install -y pandoc texlive-scheme-medium"
