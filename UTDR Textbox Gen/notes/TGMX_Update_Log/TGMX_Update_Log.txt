
[TweenGMX]

[v1.0.8]

- o_SharedTweener object is no longer added automatically to first room
	* This caused issues for various updates/platforms (e.g. Recent HTML5 update)
	* Not required, but if you want to ensure everything runs like before, 
	  call this function on game launch: SharedTweener()


[v1.0.7]

- Fixed TweenGroupSetTimeScale() not being applied
- Fixed TweenGet(tween, "amount") returning an irrelevant value
- Fixed TweenSet(tween, "ease", curve_ref) when trying to apply an Animation Curve reference

- Fixed default values not being set when using TweenPlay()/TweenDefine()
	* Please note that various values are still retained and not reset to default values:
		Target
		Events
		Group
		Delta
		Time Scale
		Auto Destroy
	
- Improved support for TweenSet()/TweenGet() when using EASE and DURATION swapping
	* Built-in ease types will now attempt to return string identifiers rather than raw values
		-> This can be helpful if saving/loading ease information
	* TweenGet() will now return an array when ease/duration swapping is used
	* TweenSet() now supports ease/duration swapping
	e.g.
		TweenSet(t, "ease", [EaseLinear, EaseInOutSine]);
		TweenSet(t, "duration", [60, 180]);


[v1.0.6]

- Fix for Advanced Properties when using To/From (">", "<") in a tween played more than once
  (e.g.)
	tween = TweenCreate(self, "outSine", 0, true, 0, 1, TPCol("color1>"), targetColor);
	TweenPlay(tween);
	TweenPlay(tween); // ERROR would occur here


[v1.0.5]

- Fix for inline callbacks involving built-in functions with passed arguments
	* e.g.
		TweenFire(..., "@finish", [show_message, "Done!"]);

- Added "soft" and "softer" variations for EaseBack* types
	* e.g.
		EaseOutBackSoft
		"ioBackSofter"
	

[v1.0.4]

- Fixes for recent GameMaker changes

- Fixed "rawstart" returning improper value
	e.g.
		tween = TweenFire(self, "io", 0, true, 0, 1, "x", "mouse_x", "mouse_x+100"); 
		raw_start = TweenGet("rawstart", tween); // Returns "mouse_x"

- Officially removed deprecated multi-tween "array support" for TweenIsActive(), TweenIsPlaying(), etc...
  Instead of TweenIsActive([tween1, tween2]) use the Tweens Selection convention.
  (Please read about "Tween Selection" in the Script Reference Guide)
	e.g.
		isActive = TweenIsActive({list: [tween1, tween2]});

