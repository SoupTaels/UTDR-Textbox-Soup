function __CollageStaticGroupClass(_collageInstance, _paths, _texturePagesCount, _prefetch = false, _removeSelf = false) constructor {
	static _global = __CollageSystem();
	if (__COLLAGE_WEAKREF_TEXTUREGROUPS) {
		array_push(_global.__CollageSTPWeakRef, self);
	}
	
	#region Processing
	var _images = _collageInstance.ImagesToArray();
	var _name = _collageInstance.GetName();
	
	// Generate sprite metadata
	var _spriteData = {};
	var _length = array_length(_images);
	for(var _i = 0; _i < _length; ++_i) {
		var _imageData = _images[_i];
		var _data = {
			width: _imageData.GetWidth(),
			height: _imageData.GetHeight(),
			frame_speed: _imageData.GetSpeed(),
			frame_type: _imageData.GetSpeedType(),
			frames: array_create(_imageData.GetFrameCount()),
			xoffset: _imageData.GetXOffset(),
			yoffset: _imageData.GetYOffset(),
		};
		
		var _framesCount = _imageData.GetFrameCount();
		for(var _j = 0; _j < _framesCount; ++_j) {
			var _uvs = _imageData.GetUVs(_j);
			_data.frames[_j] = {
				tp: _uvs.texturePageNum,
				x: _uvs.left,
				y: _uvs.top,
				w: _uvs.right,
				h: _uvs.bottom,
				original_width: _uvs.originalWidth,
				original_height: _uvs.originalHeight,
				crop_width: _imageData.__cropWidth,
				crop_height: _imageData.__cropHeight
			};
		}
		_spriteData[$ _imageData.GetName()] = _data;
	}
	
	var _finalData = {
		sprites: _spriteData,
	};
	#endregion
	
	__width = _collageInstance.GetWidth();
	__height = _collageInstance.GetHeight();
	__paths = _paths;
	
	if (_removeSelf) {
		_collageInstance.Destroy();
	}

	texturegroup_add(_name, _paths, _finalData);
	__name = _name;
	__destroyed = false;
	__texturesCount = _texturePagesCount;
	
	if (_prefetch) {
		Load(true);
	}
	
	static GetWidth = function() {
		if (__destroyed) return;
		return __width;
	}
	
	static GetHeight = function() {
		if (__destroyed) return;
		return __height;
	}
	
	static GetTextureCount = function() {
		return __texturesCount;
	}
	
	static GetName = function() {
		if (__destroyed) return;
		return __name;
	}
	
	static Load = function(_prefetch = true) {
		if (__destroyed) return;
		texturegroup_load(GetName(), _prefetch);
		return self;
	}
	
	static Unload = function() {
		if (__destroyed) return;
		texturegroup_unload(GetName());
		return self;
	}
	
	static Flush = function() {
		if (__destroyed) return;
		texture_flush(GetName());
		return self;
	}
	
	static GetTextures = function() {
		if (__destroyed) return;
		return texturegroup_get_textures(GetName());
	}
	
	static GetPaths = function() {
		return variable_clone(__paths);
	}
	
	static ClearFiles = function() {
		array_foreach(__paths, file_delete);
		array_resize(__paths, 0);
	}
	
	static GetStatus = function() {
		if (__destroyed) return;
		return texturegroup_get_status(GetName());
	}
	
	static Destroy = function() {
		if (__destroyed) return;
		texturegroup_delete(GetName());
		__group = undefined;
		__name = undefined;
		__destroyed = true;
		__Destroy();
		if (__COLLAGE_WEAKREF_TEXTUREGROUPS) {
			var _pos = array_get_index(_global.__CollageSTPWeakRef, self);
			if (_pos >= 0) {
				array_delete(_global.__CollageSTPWeakRef, _pos, 1);
			}
		}
	}
	
	static __Destroy = function() {
		array_foreach(__paths, function(_elm) {
			if (!is_string(_elm)) {
				if (buffer_exists(_elm)) {
					buffer_delete(_elm);
				}
			}
		});	
	}
	
	static GetSprites = function() {
		if (__destroyed) return;
		return texturegroup_get_sprites(GetName());
	}
}