///@desc Init

#macro DT global.dt_steady

global.dt_steady = 0;
global.dt_unsteady = 0;

// The lowest required frame rate before delta time will lag behind Step update.
// Setting this too low can increase chance of sporadic behaviour.
// Setting too high can cause games to lag behind during heavy cpu/gpu load.
min_fps = 10; // Default: 10 -- Not too hot, not too cold, but just right

// The scale factor to multiply with delta time.
// Can be used to create global slow/fast motion affects.
// Negative values can be used, but are not advised under normal circumstances.
scale = 1.0; // Default: 1.0 -- Set higher to increase speed and lower to decrease speed

//***************
// DON'T TOUCH //
//***************
// Internal calculated delta time
dt = delta_time/1000000;
// Previous value of internal delta time
dt_previous = dt;
// Whether or not internal delta time has been restored to previous value
dt_restored = false;