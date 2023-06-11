var allPanels = panels()

for (var panelIndex = 0; panelIndex < allPanels.length; panelIndex++) {
	var p = allPanels[panelIndex]
	p.remove()
}
