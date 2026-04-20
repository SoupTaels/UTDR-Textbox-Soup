live_auto_call_nr 
my_style = new LuiStyle()
	.setPadding(16)
	.setFonts(fnt_determination, fnt_determination, fnt_determination)
	.setSprites(spr_border_undertale, spr_border_undertale)
	.setSounds(snd_sel_switch)
	.setColorText(c_white)
game_ui = new LuiMain().setStyle(my_style);
instance_create_depth(0, 0, 0, oSteadyDeltaTime);

hello_button = new LuiButton({width: 128, height: 32, name: "btnHelloWorld", text: "Hello world!"}).addEvent(LUI_EV_CLICK, function(element_) { element_.main_ui.setVisible(false); });

second_button = new LuiButton({width: 128, height: 32, name: "btn2", text: "Second button"});
TweenScript(second_button, 0, 1, function() { self[$ "ystart_"] = self.y; });
second_button.addEvent(LUI_EV_CLICK, function(element_) { TweenFire("?", element_, "$15", "~oback", "y", element_.ystart_ + 5, element_.ystart_); });

third_button = new LuiButton({width: 128, height: 32, name: "btn3", text: "Third button"});
TweenScript(third_button, 0, 1, function() { self[$ "ystart_"] = self.y; });
third_button.addEvent(LUI_EV_CLICK, function(element_) { var vis_state = second_button.visible; if ( vis_state ) { second_button.hide(); } else { second_button.show(); } });

game_ui.addContent([
	new LuiPanel().setGap(10).addContent([
		hello_button, second_button, third_button
	])
]);