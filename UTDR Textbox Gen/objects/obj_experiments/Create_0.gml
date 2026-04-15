///@desc 
soupGUI = new MajorGUI();
soupGUI.Setup(new Vector2(640, 480));

//testPanel = soupGUI.PanelCreate(new Vector3(15, 15, 0), new Vector2(10, 10), , , , new Vector2(500, 300) );
//soupGUI.PanelPush(testPanel, "Test Panel");
//	soupGUI.PanelPush(testPanel);
//		textBox = soupGUI.PanelElementCreate(testPanel,
//			soupGUI.TextboxCreate(undefined, new Vector2(200, 200), testPanel)
//		);
//		soupGUI.TextboxSetFont(textBox, fnt_speech);
//		soupGUI.TextboxSetMultiline(textBox, true);
//	soupGUI.PanelPop(testPanel);
//soupGUI.PanelPop(testPanel);

textBox = soupGUI.TextboxCreate(new Vector3(320, 240), new Vector2(200, 200), , 10, , 10);
soupGUI.TextboxSetFont(textBox, fnt_speech);
soupGUI.TextboxSetMultiline(textBox, true);
soupGUI.TextboxSetText(textBox, "Test text 1, 2, 3.\nTest text 4, 5, 6.\nTest text 7, 8, 9.");

// Create a simple button
helloButton = soupGUI.ButtonCreate( new Vector3(320, 200), "Get Text", ,
	function ( ) {
		var result = soupGUI.TextboxGetText(textBox);
		show_message_async(result);
	}
, new Vector2(200, 30));