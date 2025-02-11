sap.ui.define([
	"sap/m/Button",
	"sap/m/MessageToast"
], (Button, MessageToast) => {
	"use strict";

	new Button({
		text: "Pronto...",
		press() {
			MessageToast.show("Hello World!");
		}
	}).placeAt("content");

});