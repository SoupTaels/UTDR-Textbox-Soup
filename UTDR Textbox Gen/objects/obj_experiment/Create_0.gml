my_style = new LuiStyle()
	.setPadding(16)
	.setFonts(fnt_determination, fnt_determination, fnt_determination)
	.setSprites(spr_border_undertale, spr_border_undertale)
	.setSounds(snd_sel_switch)
	.setColorText(c_white)
game_ui = new LuiMain().setStyle(my_style);
instance_create_depth(0, 0, 0, oSteadyDeltaTime);

hello_button = new LuiButton({width: 128, height: 32, name: "btnHelloWorld", text: "Hello world!"}).addEvent(LUI_EV_CLICK, function(element_) { element_.main_ui.setVisible(false); });
second_button = new LuiButton({width: 128, height: 32, name: "btn2", text: "Second button"}).addEvent(LUI_EV_CLICK, function(element_) { static yst = element_.y; TweenFire("?", element_, "$15", "~oback", "y", yst + 5, yst); });
third_button = new LuiButton({width: 128, height: 32, name: "btn3", text: "Third button"});
TweenScript(third_button, 0, 1, function() { self[$ "ystart_"] = self.y; });
third_button.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { TweenFire("?", element_, "$15", "~oback", "y>", "ystart_+5"); });
third_button.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { TweenFire("?", element_, "$15", "~oback", "y>", "ystart_"); });

game_ui.addContent([
	new LuiRow().setGap(10).addContent([
		hello_button, second_button, third_button
	])
]);