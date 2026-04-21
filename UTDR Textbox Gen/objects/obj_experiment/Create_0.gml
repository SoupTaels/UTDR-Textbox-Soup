live_auto_call_nr 
my_style = new LuiStyle()
	.setPadding(15)
	.setFonts(fnt_determination, fnt_determination, fnt_determination)
	.setSprites(spr_border_undertale, spr_border_undertale).setSounds(snd_select)
	.setColorText(c_white).setColorHover(c_yellow).setColors(, c_orange)
game_ui = new LuiMain().setStyle(my_style);

hello_button = new LuiButton({width: 128, height: 32, name: "btnHelloWorld", text: "Hello world!"})

game_ui.addContent([
	new LuiPanel().setGap(10).addContent([
		hello_button
	])
]);