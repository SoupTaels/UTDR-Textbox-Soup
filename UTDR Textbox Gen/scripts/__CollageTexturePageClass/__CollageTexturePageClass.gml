/// @ignore
/// feather ignore all
function __CollageTexturePageClass(_width, _height) constructor {
		static __idCount = 0;
		static __system = __CollageSystem();
		static __tp_list = __system.__CollageTPLoadedList;
		__width = _width;
		__height = _height;
		__surface = -1;
		__buffer = -1;
		__texture = -1;
		__cacheBuffer = -1;
		__isLoaded = false;
		__textureID = __idCount;
		__isAlive = true;
		__idCount++;
		
		static Start = function() {
			if !(surface_exists(__surface)) {
				if !(buffer_exists(__buffer)) {
					__SurfaceCreate();
					surface_set_target(__surface);
					draw_clear_alpha(0, 0);
					surface_reset_target();
				} else {
					CheckSurface();
				}
			}
			
			surface_set_target(__surface);
		}
		
		static Finish = function() {
			surface_reset_target();
			if !(buffer_exists(__buffer)) {
				__Init();
			}
			
			buffer_get_surface(__buffer, __surface, 0);
			__HandleLoad(true);
		}
		
		static GetWidth = function() {
			return __width;	
		}
		
		static GetHeight = function() {
			return __height;	
		}
		
		static __Init = function() {
			if !(buffer_exists(__buffer)) {
				if (buffer_exists(__cacheBuffer)) {
					// Lets decompress it
					__RestoreFromCache();
				} else {
					__buffer = buffer_create(__width * __height * 4, buffer_fixed, 4);	
				}
			}
		}
		
		static Free = function() {
			if (buffer_exists(__buffer)) {
				buffer_delete(__buffer);
				/* Feather ignore once GM1043 */
				__buffer = -1;
			}
			
			if (buffer_exists(__cacheBuffer)) {
				buffer_delete(__cacheBuffer);	
				/* Feather ignore once GM1043 */
				__cacheBuffer = -1;
			}
			
			if (surface_exists(__surface)) {
				surface_free(__surface);	
				/* Feather ignore once GM1043 */
				__surface = -1;
			}
			
			__HandleLoad(false);
			__isAlive = false;
		}
		
		static CheckSurface = function() {
			__Init();
			if (buffer_exists(__buffer)) {
				if !(surface_exists(__surface)) {
					__SurfaceCreate();
					buffer_set_surface(__buffer,__surface,0);
					__HandleLoad(true);
				}
			}
		}
			
		static __SurfaceCreate = function() {
			if !(surface_exists(__surface)) {
				var _depthSetting = surface_get_depth_disable();
				surface_depth_disable(true);
				__surface = surface_create(__width, __height);
				__texture = surface_get_texture(__surface);
				surface_depth_disable(_depthSetting);
			}
		}
		
		static __HandleLoad = function(_doLoad) {
			if (_doLoad) {
				if (ds_list_find_index(__tp_list, self) == -1) {
					ds_list_add(__tp_list, self);	
				}
				__isLoaded = true;
			} else {
				var _pos = ds_list_find_index(__tp_list, self);
				if (_pos != -1) {
					ds_list_delete(__tp_list, _pos);	
				}	
				__isLoaded = false;
			}
		}
			
		static __CacheTexture = function() {
			if (!buffer_exists(__cacheBuffer)) {
				if (buffer_exists(__buffer)) {
					var _size = __width*__height*4;
					__cacheBuffer = buffer_compress(__buffer, 0, _size);
					
					// Remove main buffer
					buffer_delete(__buffer);
					/* Feather ignore once GM1043 */
					__buffer = -1;
					
					// Remove surface
					if (surface_exists(__surface)) {
						surface_free(__surface);	
						/* Feather ignore once GM1043 */
						__surface = -1;
					}
				}
				__HandleLoad(false);
			}
		}
			
		static __RestoreFromCache = function() {
			if (!buffer_exists(__buffer)) && (buffer_exists(__cacheBuffer)) {
				var _dbuff = buffer_decompress(__cacheBuffer);
				/* Feather ignore once GM1009 */
				if !(_dbuff < 0) {
					__buffer = _dbuff;
					buffer_delete(__cacheBuffer);
					/* Feather ignore once GM1043 */
					__cacheBuffer = -1;
					// Restore surface
					CheckSurface();
					
					// It has loaded successfully!
					__HandleLoad(true);
				} else {
					__CollageThrow("Something terrible has gone wrong with unloading cache data!");	
				}
			}
		}
		
		static __UnloadVRAM = function() {
			if (surface_exists(__surface)) {
				surface_free(__surface);	
				__surface = -1;
				__HandleLoad(false);
			}
		}
		
		static ToQOIF = function() {
			__Init();
			var _buff = buffer_create(buffer_get_size(__buffer)+16, buffer_fixed, 1);
			
			buffer_write(_buff, buffer_u32, 0x20574152);
			buffer_write(_buff, buffer_s32, __width);
			buffer_write(_buff, buffer_s32, __height);
			buffer_write(_buff, buffer_s32, 0);
			buffer_copy(__buffer, 0, buffer_get_size(__buffer), _buff, buffer_tell(_buff));
			buffer_seek(__buffer, buffer_seek_start, 0);
			
			return _buff;
		}
		
		static GetTexture = function() {
			return __texture;
		}
		
		static GetSurface = function() {
			return __surface;
		}
}