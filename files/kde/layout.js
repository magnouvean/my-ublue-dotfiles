var allPanels = panels();

for (var panelIndex = 0; panelIndex < allPanels.length; panelIndex++) {
    var p = allPanels[panelIndex];
    p.remove();
}

var panel = new Panel;
var panelScreen = panel.screen;

panel.height = 32;
panel.alignment = "center";
panel.location = "top";
panel.addWidget("org.kde.plasma.appmenu");
panel.addWidget("org.kde.plasma.panelspacer");
panel.addWidget("org.kde.plasma.digitalclock");
panel.addWidget("org.kde.plasma.notifications");
panel.addWidget("org.kde.plasma.systemtray");
