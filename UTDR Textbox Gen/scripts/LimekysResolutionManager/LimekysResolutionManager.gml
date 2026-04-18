//Simple Resolution Manager by Limekys (This script has MIT Licence)
//Dependencies: -
#macro LIME_RESOLUTION_MANAGER_VERSION "2025.02.25"
#macro LIME_RESOLUTION getLimeResolutionManager()

function getLimeResolutionManager() {
	static LimeResolutionManager = function() constructor {
		self.last_window_width = window_get_width();
		self.last_window_height = window_get_height();
		self.screen_width = -1; // -1 means auto (window or screen size)
		self.screen_height = -1; // -1 means auto (window or screen size)
		self.gui_width = -1; // -1 means auto (follows screen resolution)
		self.gui_height = -1; // -1 means auto (follows screen resolution)
		self.gui_scale = 1.0; // Default GUI scale

		// Initialize resolution settings
		static init = function() {
			updateResolution();
			return self;
		}

		// Update resolution based on window or fullscreen mode
		static updateResolution = function() {
			var win_width = window_get_width();
			var win_height = window_get_height();

			if (win_width <= 0 || win_height <= 0) return self;

			var render_width, render_height;

			// Determine screen rendering resolution
			if (window_get_fullscreen()) {
				if (self.screen_width == -1 || self.screen_height == -1) {
					// Use screen resolution if no target is set
					render_width = display_get_width();
					render_height = display_get_height();
				} else {
					// Use user-specified resolution
					render_width = self.screen_width;
					render_height = self.screen_height;
				}
			} else {
				// Windowed mode: adapt to window size
				render_width = win_width;
				render_height = win_height;
			}

			// Update viewport to stretch to window size
			view_set_wport(0, win_width);
			view_set_hport(0, win_height);

			// Update application surface to render resolution
			surface_resize(application_surface, render_width, render_height);

			// Automatically adjust GUI size
			updateGuiSize();

			self.last_window_width = win_width;
			self.last_window_height = win_height;
			return self;
		}

		// Update GUI size based on screen resolution and scale
		static updateGuiSize = function() {
			var render_width = getScreenWidth();
			var render_height = getScreenHeight();

			var gui_width, gui_height;
			if (self.gui_width == -1 || self.gui_height == -1) {
				// Auto: follows screen resolution with scale
				gui_width = render_width / self.gui_scale;
				gui_height = render_height / self.gui_scale;
			} else {
				// User-specified GUI resolution
				gui_width = self.gui_width / self.gui_scale;
				gui_height = self.gui_height / self.gui_scale;
			}
			display_set_gui_size(gui_width, gui_height);
		}

		// Set screen resolution (-1 means auto)
		static setScreenResolution = function(width, height) {
			self.screen_width = width;
			self.screen_height = height;
			updateResolution();
			return self;
		}

		// Set GUI resolution (-1 means auto, follows screen resolution)
		static setGuiResolution = function(width, height) {
			self.gui_width = width;
			self.gui_height = height;
			updateGuiSize();
			return self;
		}

		// Set GUI scale factor (e.g., 2 means GUI is 2x zoomed in)
		static setGuiScale = function(scale) {
			self.gui_scale = max(0.1, scale); // Prevent scale from being too small
			updateGuiSize(); // Apply new scale immediately
			return self;
		}

		// Get current screen width
		static getScreenWidth = function() {
			if (window_get_fullscreen()) {
				if (self.screen_width == -1) {
					return display_get_width();
				} else {
					return self.screen_width;
				}
			} else {
				return window_get_width();
			}
		}

		// Get current screen height
		static getScreenHeight = function() {
			if (window_get_fullscreen()) {
				if (self.screen_height == -1) {
					return display_get_height();
				} else {
					return self.screen_height;
				}
			} else {
				return window_get_height();
			}
		}

		// Get current GUI width
		static getGuiWidth = function() {
			if (self.gui_width == -1) {
				return getScreenWidth() / self.gui_scale;
			} else {
				return self.gui_width / self.gui_scale;
			}
		}

		// Get current GUI height
		static getGuiHeight = function() {
			if (self.gui_height == -1) {
				return getScreenHeight() / self.gui_scale;
			} else {
				return self.gui_height / self.gui_scale;
			}
		}

		// Get current GUI scale
		static getGuiScale = function() {
			return self.gui_scale;
		}

		// Check and update resolution if window size or mode changed
		static update = function() {
			if (self.last_window_width != window_get_width() || self.last_window_height != window_get_height()) {
				updateResolution();
			}
		}
	}
	static inst = new LimeResolutionManager();
	return inst;
}