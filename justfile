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
  # cp files/autostart/* $HOME/.config/autostart/
  cp files/vscode/*.json $HOME/.local/share/distrobox/home/dev/.config/VSCodium/User/
  echo "Removing unwanted files"
  if [ -f $HOME/.local/share/applications/dev.desktop ]; then
    rm $HOME/.local/share/applications/dev.desktop
  fi

  echo "Dotfiles/settings for dev container apps"
  echo 'echo "# ZSH CONFIG\nPATH=\"$PATH:$HOME/.local/bin\"\nsource /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\nsource /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh\nalias gst=\"git status\"\nalias gad=\"git add\"\nalias gco=\"git commit\"\nalias gpu=\"git push\"" > ~/.zshrc' | distrobox enter dev

  echo "Apply flatpak theme"
  flatpak --user override --filesystem=xdg-config/gtk-3.0:ro
  flatpak --user override --filesystem=xdg-config/gtk-4.0:ro

system user_password=`read -p 'Sudo password: ' -s password && echo $password`:
  #!/bin/bash
  echo "Copying over system files and configurations"
  set -e
  cmp -s /etc/hosts files/hosts || echo "{{user_password}}" | sudo -S cp files/hosts /etc/hosts
  if [ -f /usr/bin/sddm ]; then
    echo "{{user_password}}" | sudo -S mkdir -p /etc/sddm.conf.d/
    echo "{{user_password}}" | sudo -S cp ./files/kde/kde_settings.conf /etc/sddm.conf.d
  fi
  [ "$SHELL" = "/bin/zsh" ] || echo "{{user_password}}" | chsh -s /bin/zsh
  mkdir -p $HOME/.config/gtk-3.0
  mkdir -p $HOME/.config/gtk-4.0
  touch $HOME/.config/gtk-3.0/settings.ini
  touch $HOME/.config/gtk-4.0/settings.ini

gnome-settings gnome_terminal_profile=`gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'"`:
  #!/bin/bash
  xdg-settings set default-web-browser com.brave.Browser.desktop
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'gtk-launch dev-emacsclient.desktop'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "'gtk-launch net.lutris.Lutris.desktop'"
  gsettings set org.gnome.shell favorite-apps "['com.brave.Browser.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop']"
  dconf write /org/gnome/terminal/legacy/profiles:/:{{gnome_terminal_profile}}/use-system-font false
  dconf write /org/gnome/terminal/legacy/profiles:/:{{gnome_terminal_profile}}/use-transparent-background true
  dconf write /org/gnome/terminal/legacy/profiles:/:{{gnome_terminal_profile}}/background-transparency-percent 15
  gsettings set org.gnome.shell enabled-extensions "['pop-shell@system76.com', 'appindicatorsupport@rgcjonas.gmail.com']"
  gsettings set org.gnome.shell.extensions.pop-shell activate-launcher "[]"
  gsettings set org.gnome.shell.extensions.pop-shell active-hint true
  gsettings set org.gnome.shell.extensions.pop-shell gap-inner 4
  gsettings set org.gnome.shell.extensions.pop-shell gap-outer 4
  gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba 'rgba(120, 117, 122, 1)'
  gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-down "[]"
  gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-left "[]"
  gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-right "[]"
  gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-up "[]"
  gsettings set org.gnome.shell.extensions.pop-shell pop-workspace-down "[]"
  gsettings set org.gnome.shell.extensions.pop-shell pop-workspace-up "[]"
  gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
  gsettings set org.gnome.shell.extensions.pop-shell tile-enter "['<Super>a']"
  gsettings set org.gnome.shell.extensions.pop-shell tile-orientation "[]"
  gsettings set org.gnome.shell.extensions.pop-shell tile-swap-down "[]"
  gsettings set org.gnome.shell.extensions.pop-shell tile-swap-left "[]"
  gsettings set org.gnome.shell.extensions.pop-shell tile-swap-right "[]"
  gsettings set org.gnome.shell.extensions.pop-shell tile-swap-up "[]"
  gsettings set org.gnome.shell.extensions.pop-shell toggle-floating "['<Super>s']"
  gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking "[]"
  gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking-global "[]"
  gsettings set org.gnome.shell.extensions.pop-shell toggle-tiling "[]"
  gsettings set org.gnome.shell.extensions.pop-shell active-hint-border-radius 10
  gsettings set org.gnome.shell disable-user-extensions false

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys email "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys help "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Alt>f']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-in "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-out "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenreader "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Shift>s']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Alt>w']"

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Alt>Return'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Launch terminal'

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Alt>e'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Launch editor'
  
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Alt>m'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Launch mail client'
  
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Alt>g'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Launch game launcher'

  
  gsettings set org.gnome.shell.keybindings focus-active-notification "[]"
  gsettings set org.gnome.shell.keybindings toggle-application-view "[]"
  gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"
  gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>r']"

  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
  gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Super>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"

  gsettings set org.gnome.desktop.background picture-options 'zoom'
  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/keys-l.webp'
  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/keys-d.webp'

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

  gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,close"
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 8

  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.mutter overlay-key ""
  gsettings set org.gnome.mutter workspaces-only-on-primary false

  gsettings set org.gnome.mutter.keybindings switch-monitor "[]"
  gsettings set org.gnome.mutter.keybindings toggle-tiled-left "[]"
  gsettings set org.gnome.mutter.keybindings toggle-tiled-right "[]"

  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1200

  echo "Set gtk 3/4 config files"
  printf "[Settings]\ngtk-theme-name = Adwaita-dark\ngtk-application-prefer-dark-theme = true" > $HOME/.config/gtk-3.0/settings.ini
  cp $HOME/.config/gtk-3.0/settings.ini $HOME/.config/gtk-4.0/settings.ini

kde-settings:
  #!/bin/bash
  echo "Apply kde layout"
  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat ./files/kde/resetlayout.js)"
  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat ./files/kde/layout.js)"

  echo "Set kde keybindings and settings"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window Maximize' 'Meta+F,,Maximize Window'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 1' 'Meta+1,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 2' 'Meta+2,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 3' 'Meta+3,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 4' 'Meta+4,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 5' 'Meta+5,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 6' 'Meta+6,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 7' 'Meta+7,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Switch to Desktop 8' 'Meta+8,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 1' 'Meta+!,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 2' 'Meta+",,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 3' 'Meta+#,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 4' 'Meta+¤,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 5' 'Meta+%%,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 6' 'Meta+&,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 7' 'Meta+/,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" 'Window to Desktop 8' 'Meta+(,,'

  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Desktops" "Number" "8"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Desktops" "Rows" "2"

  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.krunner.desktop" "_k_friendly_name" "Krunner"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.krunner.desktop" "_launch" "Meta+R,Search,KRunner"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.konsole.desktop" "_k_friendly_name" "Konsole"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.konsole.desktop" "_launch" "Alt+Return,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.dolphin.desktop" "_launch" "Alt+F,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "com.brave.Browser.desktop" "_k_friendly_name" "Brave Browser"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "com.brave.Browser.desktop" "_launch" "Alt+W,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "dev-emacsclient.desktop" "_k_friendly_name" "Editor"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "dev-emacsclient.desktop" "_launch" "Alt+E,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.kontact.desktop" "_k_friendly_name" "Email"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "org.kde.kontact.desktop" "_launch" "Alt+M,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "net.lutris.Lutris.desktop" "_k_friendly_name" "Game Launcher"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "net.lutris.Lutris.desktop" "_launch" "Alt+G,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Plugins" "bismuthEnabled" "true"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Script-bismuth" "tileLayoutGap" "12"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Script-bismuth" "screenGapLeft" "12"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Script-bismuth" "screenGapRight" "12"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Script-bismuth" "screenGapTop" "12"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Script-bismuth" "screenGapBottom" "12"

  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "focus_bottom_window" "Meta+J,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "focus_upper_window" "Meta+K,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "focus_right_window" "Meta+L,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "focus_left_window" "Meta+H,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "move_window_to_bottom_pos" "Meta+Shift+J,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "move_window_to_upper_pos" "Meta+Shift+K,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "move_window_to_left_pos" "Meta+Shift+H,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "move_window_to_right_pos" "Meta+Shift+L,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "rotate" "none,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "bismuth" "toggle_window_floating" "Meta+S,,"

  ./files/kde/write_keybinding_abs.py "$HOME/.config/krunnerrc" "General" "FreeFloating" "true"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" "Window to Next Screen" 'Alt+Shift+L,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" "Window to Previous Screen" 'Alt+Shift+H,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "Switch to Previous Screen" "Alt+H,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "Switch to Next Screen" "Alt+L,,"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "kwin" "Window Close" "Meta+Q,,"

  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "ksmserver" 'Lock Session' 'ScreenSaver\tMeta+Shift+S,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "ksmserver" 'Log Out' 'Meta+Shift+E,,'

  echo "Disable some keybindings"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'stop current activity' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'manage activities' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 1' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 2' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 3' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 4' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 5' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 6' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 7' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 8' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 9' 'none,,'
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kglobalshortcutsrc" "plasmashell" 'activate task manager entry 10' 'none,,'

  echo "Power management settings"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/powermanagementprofilesrc" "AC][DPMSControl" "idleTime" "300"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/powermanagementprofilesrc" "AC][DimDisplay" "idleTime" "250000"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/powermanagementprofilesrc" "AC][SuspendSession" "suspendType" "32"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/powermanagementprofilesrc" "Battery][DPMSControl" "idleTime" "300"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/powermanagementprofilesrc" "Battery][DimDisplay" "idleTime" "250000"
  ./files/kde/write_keybinding_abs.py "$HOME/.config/kwinrc" "Windows" "ActiveMouseScreen" "false"

  echo "Set theme and wallpaper"
  plasma-apply-lookandfeel -a org.kde.breezedark.desktop
  plasma-apply-wallpaperimage /usr/share/wallpapers/Cluster/

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
