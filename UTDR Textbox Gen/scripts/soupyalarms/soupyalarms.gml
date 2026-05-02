#region Alarm Functions
	///@desc Create a custom alarm (should be ran in the step events).
	///@param {string} name_ The name of the alarm (gets set as a new variable).
	///@param {real} time_ If the alarm is counting down, this is what the alarm should count down from, before reaching 0. If we're counting up, then this should be where the alarm starts from.
	///@param {bool} looping_ Should the alarm loop?
	///@param {bool} deltatime_ Should the alarm use delta timing?
	///@param {array} up_ An array containing if the alarm should count up instead and the time before the alarm stops. (Ex:[false], [true, 180])
	function soupy_alarm(name_ = "default", time_ = -1, looping_ = false, deltatime_ = false, up_ = [false]) 
	{
		/*
		Example uses:
		soupy_alarm("test", 180); //Just sets a standard alarm that counts down from 180 till it reaches 0.
		soupy_alarm("test", 180, true); //This sets a looping alarm.
		soupy_alarm("test", 180, , true); //This sets a standard alarm with delta timing.
		soupy_alarm("test", 0, true, , [true, 180]); //This sets a looping alarm to start at 0 and count up till 180.
		
		var testtt = soupy_alarm("test", 0, , , [true, -1]);
		print_log(testtt.timer_);
		soupy_alarm_run(testtt.timer_, 180, game_end);
		*/
		var alarmsoup = $"soupy_{name_}_alarm"; //Alarm variable name
		var alarmid = id; //Instance ID

		if ( !variable_instance_exists(alarmid, alarmsoup) ) { //If the alarm variable doesn't exist, create a new one
			var alarmstruct = {
				timer_: time_, //Alarm timer
				frozen_: false, //Whether the alarm is paused or not
				loop_: looping_, //Whether the alarm should loop
				countup_: up_, //If the alarm should count up instead. If so, set the alarm timer(Ex:[false], [true, 180])
				delta_: deltatime_, //Should we use delta timing?
				loopto_: time_, //The value the timer should go back to when looping
				myname_: alarmsoup, //Name of the alarm
		
				//You can add more variables here and use the getter and setter functions to get and change the variable.
			}
			variable_instance_set(alarmid, alarmsoup, alarmstruct); //Create a new variable holding the struct
			return alarmstruct;
		}
		//If the alarm exists, run the system
		var myalarm = variable_instance_get(alarmid, alarmsoup); //Get the variable containing the struct
	
		if ( !myalarm.frozen_ ) { //Don't run if the alarm is frozen
			if ( !myalarm.countup_[0] ) { //Are we counting down?
				if ( myalarm.timer_ > 0 ) { myalarm.timer_ -= !myalarm.delta_ ? 1 : 1 * deltaizer(); } //Count the timer down
				else { myalarm.timer_ = !myalarm.loop_ ? -1 : myalarm.loopto_; } //Either stop at -1 or at the loop point
			}
			else { //Are we counting up?
				var countup = method({ myalarm: variable_instance_get(alarmid, alarmsoup) }, function() { myalarm[$ "timer_"] += !myalarm[$ "delta_"] ? 1 : 1 * deltaizer(); });
				if ( myalarm.countup_[1] >= 0 ) { //Count up till the end
					if ( myalarm.timer_ < myalarm.countup_[1] ) { countup(); } //Count the timer up
					else { myalarm.timer_ = !myalarm.loop_ ? myalarm.countup_[1] + 1 : myalarm.loopto_; } //Either stop at the endpoint or at the loop point
				}
				else { countup(); } //Count the timer up infinitely
			}
		}
	
		//print_log($"Alarm name: '{alarmsoup}' | Timer: {myalarm.timer_} | Paused: {myalarm.frozen_} | Looping: {myalarm.loop_} | Delta Timing: {myalarm.delta_} |Counting Up?: {myalarm.countup_}");
		return myalarm;
	}

	///@desc Changes an alarm variable's value depending on the prop_ argument you give it.
	///@param {string} name_ The name of the alarm.
	///@param {string} prop_ The name of the variable within the alarm struct to look for.
	///@param {any} arg_ The argument to change the value of a variable into.
	///@param {bool} forcenew_ Whether to force a new timer if it doesn't exist.
	function soupy_alarm_set(name_ = "default", prop_ = "timer", arg_ = 0, forcenew_ = true)
	{
		/*
		Example use:

		//Switch for loop alarms
		if ( keyboard_check_pressed(vk_space) )  { soupy_alarm_set("test", "loop", !soupy_alarm_get("test", "loop")); } //Sets the alarm's looping state to switch between being on and off.

		//Make an alarm counting up now count down instead
		soupy_alarm("test", 0, true, true, [true, 180]); //Creates a alarm with the name "test", starts at 0, looping is true, uses delta timing, and inside the array it tells the alarm that it should count up till it gets to 180.

		if ( keyboard_check_pressed(vk_space) )  {
			soupy_alarm_set("test", "timer", 180); //Count down from 180
			soupy_alarm_set("test", "loopto", soupy_alarm_get("test", "timer")); //Loop back to 180 when the timer reaches 0
			soupy_alarm_set("test", "countup", [false]); //Don't count up anymore
		}

		//Switch for freezing alarms
		if ( keyboard_check_pressed(vk_space) )  { soupy_alarm_set("test", "frozen", !soupy_alarm_get("test", "frozen")); } //Sets the alarm's frozen state to switch between being on and off.
		*/
		var alarmsoup = string_search(name_, "soupy_") ? name_ : $"soupy_{name_}_alarm"; //Alarm variable name
		var alarmid = id;
		if ( variable_instance_exists(alarmid, alarmsoup) ) { //Check if the timer exists
			var myalarm = variable_instance_get(id, alarmsoup); //Get the variable containing the struct
			struct_set(myalarm, $"{prop_}_", arg_); //Changes a variable's value depending on the prop_ argument you give it
		}
		else { if ( forcenew_ ) { with ( alarmid ) { soupy_alarm(name_); soupy_alarm_set(name_, prop_, arg_); } } else { return -1; } } //Force a new timer struct
	}

	///@desc Returns an alarm variable's value depending on the prop_ argument you give it.
	///@param {string} name_ The name of the alarm.
	///@param {string} prop_ The name of the variable within the alarm struct to look for.
	///@param {bool} forcenew_ Whether to force a new timer if it doesn't exist.
	function soupy_alarm_get(name_ = "default", prop_ = "timer", forcenew_ = true)
	{
		/*
		Example uses:
		var gettime = soupy_alarm_get("test", "timer");
		print_log(gettime);

		Prints to the debug console about the current alarm time.
		*/
		var alarmsoup = string_search(name_, "soupy_") ? name_ : $"soupy_{name_}_alarm"; //Alarm variable name
		var alarmid = id;
		
		if ( variable_instance_exists(alarmid, alarmsoup) ) { //Check if the timer exists
			var myalarm = variable_instance_get(id, alarmsoup); //Get the variable containing the struct
			var getval = variable_struct_get(myalarm, $"{prop_}_"); //Gets a variable's value depending on the prop_ argument you give it
			return getval;
		}
		else { if ( forcenew_ ) { with ( alarmid ) { soupy_alarm(name_); soupy_alarm_get(name_, prop_); } } else { return -1; } } //Force a new timer struct
	}

	///@desc Stops an alarm from running.
	///@param {string} name_ The name of the alarm.
	///@param {bool} countup_ Whether the alarm counts up.
	function soupy_alarm_stop(name_ = "default", countup_ = false)
	{
		var alarmsoup = string_search(name_, "soupy_") ? name_ : $"soupy_{name_}_alarm"; //Alarm variable name
		var alarmid = id;

		if ( variable_instance_exists(alarmid, alarmsoup) ) { //Check if the timer exists
			var myalarm = variable_instance_get(alarmid, alarmsoup); //Get the variable containing the struct

			myalarm.timer_ = countup_ ? myalarm.countup_[1] + 1 : -1;
			myalarm.frozen_ = false;
			myalarm.loop_ = false; 
		}
		else { return -1; }
	}

	///@desc Returns whether the alarm's timer is at the specified time.
	///@param {string} name_ The name of the alarm.
	///@param {real} time_ The time to check and see if the alarm has reached it.
	function soupy_alarm_moment(name_ = "default", time_)
	{
		/*
		Example use:
		if ( soupy_alarm_moment("test", 60) ) {
			sfx_play(snd_footstep);
			camera_rotate(random(360), 0.07);
		}

		When the "test" timer is at 60, play a sound when rotating the camera.
		*/
		var alarmsoup = string_search(name_, "soupy_") ? name_ : $"soupy_{name_}_alarm"; //Alarm variable name
		var alarmid = id;

		if ( variable_instance_exists(alarmid, alarmsoup) ) {
			var gettime = soupy_alarm_get(alarmsoup, "timer");
			if ( round(gettime) == time_ ) { return true; } else  { return false; }
		}
		else { return -1; }
	}

	///@desc Runs a script function when the alarm's timer is at the specified time.
	///@param {string} name_ The name of the alarm.
	///@param {real} time_ The time to check and see if the alarm has reached it.
	///@param {function} func_ The function to run.
	function soupy_alarm_run(name_ = "default", time_, func_)
	{
		/*
		Example use:
		soupy_alarm_run("test", 60, function() {
			sfx_play(snd_footstep);
			camera_rotate(random(360), 0.07);
		});

		When the "test" timer is at 60, run a function that plays a sound when rotating the camera.
		*/
		var alarmsoup = string_search(name_, "soupy_") ? name_ : $"soupy_{name_}_alarm"; //Alarm variable name
		var alarmid = id;

		if ( variable_instance_exists(alarmid, alarmsoup) ) { //Check if the timer exists
			var gettime = soupy_alarm_get(alarmsoup, "timer");
			if ( floor(gettime) == time_ ) { func_(); return true; } else  { return false; }
		}
		else { return -1; }
	}
#endregion