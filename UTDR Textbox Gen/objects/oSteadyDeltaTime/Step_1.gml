///@desc System

// Store previous internal delta time
dt_previous = dt;
// Update internal delta time
dt = delta_time/1000000;
// Set raw unsteady delta time affected by time scale
global.dt_unsteady = dt*scale;

// Prevent delta time from exhibiting sporadic behaviour
if (dt > 1/min_fps) {
	if (dt_restored) { 
		dt = 1/min_fps; 
	} else { 
		dt = dt_previous;
		dt_restored = true;
	}
} else {
	dt_restored = false;
}

// Assign internal delta time to global delta time affected by the time scale
global.dt_steady = dt*scale;