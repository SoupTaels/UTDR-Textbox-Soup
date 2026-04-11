/// @ignore
/// feather ignore all
enum CollageBuildStates {
	NORMAL,
	BATCHING
}

enum CollageStatus {
	READY,
	WAITING_ON_FILES
}

enum CollageOrigin {
	LEFT = -2716284,
	CENTER,
	RIGHT,
	TOP,
	BOTTOM	
}

enum CollageRPStatus {
	EMPTY,
	BATCHING,
	BATCHED
}

#macro __COLLAGE_IS_DESKTOP ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux))
#macro __COLLAGE_IS_MOBILE ((os_type == os_android) || (os_type == os_ios))
#macro __COLLAGE_IS_CONSOLE ((os_type == os_switch) || (os_type == os_xboxseriesxs) || (os_type == os_ps4) || (os_type == os_ps5))

#macro __COLLAGE_CREDITS "@TabularElf - https://tabelf.link/"
#macro __COLLAGE_VERSION "v1.0.1-alpha"
show_debug_message("Collage " + __COLLAGE_VERSION + " Initalized! Created by " + __COLLAGE_CREDITS);

/// @ignore
function __CollageSystem() {
	static _inst = undefined;
		// Feather ignore once GM1011
		if (_inst = undefined) {
			_inst = {};
			with(_inst) {
				__CollageTexturePagesMap = {};
				__CollageTexturePagesList = [];
				__CollageImageMap = {};
				__CollageGMSpriteCount = 0;
				__CollageAsyncList = [];
				__CollageTPLoadedList = ds_list_create();
				__CollageSTPWeakRef = [];
				
				if (__COLLAGE_WEAKREF_TEXTUREGROUPS) {
					time_source_start(time_source_create(time_source_global, __COLLAGE_WEAKREF_TEXTUREGROUPS_NEXT_ITERATION, time_source_units_seconds, function() {
						static _list = __CollageSystem().__CollageSTPWeakRef;
						var _size = array_filter_ext(_list, function(_elm) {
							if (!texturegroup_exists(_elm.GetName())) {
								_elm.__Destroy();
								return false;
							}
							
							return true;
						});
						
						array_resize(_list, _size);
					}, [], -1));
				}
				
				var _i = 0;
				try {
					// Needed as newer versions of GameMaker now break with "unused assets" checked.
					var _sprites = asset_get_ids(asset_sprite);
					repeat(array_length(_sprites)) {
						// Skip sprites created/added on the fly
						if (string_pos("__newsprite", sprite_get_name(_sprites[_i])) > 0) {
							__CollageGMSpriteCount++;	
						}
						_i++;
					}
				} catch(_) {
					while(sprite_exists(_i)) {
						// Skip sprites created/added on the fly
						if (string_count("__newsprite", sprite_get_name(_i)) > 0) {
							break;
						}
						
						__CollageGMSpriteCount = _i++;
					}
				}
				_init = true;
				try {
					time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function() {
						__CollageTick();
					}, [], -1));
				} catch(_ex) {
					__CollageThrow("This is running on a version older than 2022.5!");	
				}
			}
		}
	
	return _inst;
}
__CollageSystem();
