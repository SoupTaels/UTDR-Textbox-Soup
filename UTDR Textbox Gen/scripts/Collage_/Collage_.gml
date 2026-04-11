/// @func Collage([identifier], [width], [height], [crop], [optimize])
/// @param {String} [identifier]
/// @param {Real} [width]
/// @param {Real} [height]
/// @param {Real} [crop]
/// @param {Real} [separation]
/// @param {Bool} [optimize]
/// feather ignore all
function Collage(_identifier = undefined, _width = __COLLAGE_DEFAULT_TEXTURE_SIZE, _height = __COLLAGE_DEFAULT_TEXTURE_SIZE, _crop = __COLLAGE_DEFAULT_CROP, _separation = __COLLAGE_DEFAULT_SEPARATION, _optimize = __COLLAGE_DEFAULT_OPTIMIZE) constructor {
	// Members
	static __system = __CollageSystem();
	__state = CollageBuildStates.NORMAL;
	__texPageArray = [];
	__texPageCount = 0;
	__imageCount = 0;
	__batchImageList = [];
	__imageMap = {};
	__imageList = [];
	__asyncList = [];
	__isWaitingOnAsync = false;
	__status = CollageStatus.READY;
	__builder = new __CollageBuilderClass();
	__separation = _separation;
	__width = _width;
	__height = _height;
	__crop = _crop;
	__optimize = _optimize;
	__name = is_undefined(_identifier) ? _identifier : string(_identifier);
	__id = (date_current_datetime() ^ get_timer());
	__recent = [];
	__useHash = __COLLAGE_USE_HASHES ? __COLAGE_DEFAULT_HASH_STATE : false;
	
	__destroyed = false;
	
	array_push(__system.__CollageTexturePagesList, self);
	if (is_string(_identifier)) {
		if (variable_struct_exists(__system.__CollageTexturePagesMap, _identifier)) {
			__CollageThrow(_identifier + " already exists as a Collage name!");	
		}
		
		__system.__CollageTexturePagesMap[$ _identifier] = self;
	}
	
	// Init texture settings
	if (__COLLAGE_ENSURE_POWER_TWO) && !(CollageIsPowerTwo(__width) || CollageIsPowerTwo(__height)) {
		__width = CollageConvertPowerTwo(_width);
		__height = CollageConvertPowerTwo(_height);
	} 
	
	if (__COLLAGE_CLAMP_TEXTURE_SIZE) {
		__width = clamp(__width, __COLLAGE_MIN_TEXTURE_SIZE, __COLLAGE_MAX_TEXTURE_SIZE);
		__height = clamp(__height, __COLLAGE_MIN_TEXTURE_SIZE, __COLLAGE_MAX_TEXTURE_SIZE);
	}
	
	#region Methods
	
	static __getName = function() {
		return (is_undefined(__name)) ? "" : __name + " - ";	
	}
	
	static SetHashing = function(_value) {
		if (!__COLLAGE_USE_HASHES) return __CollageThrow("Hashing is not enabled! Please ensure that \"__COLLAGE_USE_HASHES\" is checked in \"__CollageConfig\"!");
		__useHash = _value;
		return self;
	}
	
	static GetHashing = function() {
		return __useHash;
	}
	
	static GetWidth = function() {
		return __width;
	}
	
	static GetHeight = function() {
		return __height;
	}
	
	#region Batching
	static StartBatch = function() {
		if (__state == CollageBuildStates.BATCHING) {
			__CollageTrace(__getName() + "Currently in batching mode!");
			return self;
		}
		
		__state = CollageBuildStates.BATCHING;
		return self;
	}
	
	static ClearBatch = function() {
		if (__state == CollageBuildStates.BATCHING) {
			var _len = array_length(__batchImageList);
			var _i = 0;
			repeat(_len) {
				if (__batchImageList[_i].__isCopy) {
					sprite_delete(__batchImageList[_i].__spriteID);	
				}
				++_i;
			} 	
			
			// Clear the list
			array_resize(__batchImageList, 0);
			return self;
			
		} else {
			__CollageTrace(__getName() + "Is not in batching mode!");	
			return self;
		}
	}
	
	static FinishBatch = function(_crop = true) {
		if (__state != CollageBuildStates.BATCHING) {
			__CollageTrace(__getName() + "Is not in batching mode!");
			return self;
		} 
		
		if (!__isWaitingOnAsync) __builder.__build();
		__state = CollageBuildStates.NORMAL;
		return self;
	}
	#endregion
	
	#region Image Adding
	static AddFile = function(_fileName, _identifierString = undefined, _subImage = 1, _removeBack = false, _smooth = false, _xOrigin = 0, _yOrigin = 0, _is3D = false) {
		if (!__CollageFileFromWeb(_fileName)) && (!file_exists(_fileName)) {
			// It doesn't exist, obviously!
			__CollageTrace(__getName() + "File " + string(_fileName) + " doesn't exist!");
			exit;
		}
		
		var _identifier = _identifierString ?? __CollageGetName(_fileName);
		
		var _spriteID = sprite_add(_fileName, _subImage, _removeBack, _smooth, _xOrigin, _yOrigin);
		if (_spriteID == -1) {
			__CollageTrace(__getName() + "File " + string(_fileName) + " has an invalid formatting!");
			exit;
		}
		
		var _spriteData = new __CollageSpriteFileDataClass(_identifier, _spriteID, _subImage).SetOrigin(_xOrigin, _yOrigin).SetSeparateTexture(_is3D);
		
		if (__CollageFileFromWeb(_fileName)) {
			if (__COLLAGE_VERBOSE) __CollageTrace("Adding " + string(_fileName) + " to asynchronous listing...");
			__isWaitingOnAsync = true;
			__status = CollageStatus.WAITING_ON_FILES;
			var _i = 0;
			repeat(array_length(__system.__CollageAsyncList)) {
				if (__system.__CollageAsyncList[_i] == self) {
					break;	
				}
				++_i;
			}
			
			if (_i == array_length(__system.__CollageAsyncList)) {
				array_push(__system.__CollageAsyncList, self);
			}
			
			array_push(__asyncList, [_spriteData, undefined]);
		} else {
			array_push(__batchImageList, _spriteData);
		}
		
		if (__state == CollageBuildStates.NORMAL) {
			if (!__isWaitingOnAsync) __builder.__build();
		}
		
		if (__state == CollageBuildStates.BATCHING) {
			return _spriteData;
		}
	}
	
	static AddSprite = function(_spriteIdentifier, _identifierString = undefined, _isCopy = undefined, _xOrigin = sprite_get_xoffset(_spriteIdentifier), _yOrigin = sprite_get_yoffset(_spriteIdentifier), _is3D = false) {
		var _spriteID = _spriteIdentifier;
		var _isCopyValue = _isCopy;
		
		var _identifier = _identifierString ?? sprite_get_name(_spriteID);
		
		if (real(_spriteID) <= __system.__CollageGMSpriteCount) {
			_spriteID = sprite_duplicate(_spriteIdentifier);
			if (__COLLAGE_VERBOSE) __CollageTrace(__getName() + _identifier + " is a GMSprite resource added via the IDE, making a copy...");
			_isCopyValue = true;
		}
		
		// Add sprite data
		var _spriteData = new __CollageSpriteFileDataClass(_identifier, _spriteID, sprite_get_number(_spriteID), _isCopyValue)
			.SetOrigin(_xOrigin, _yOrigin)
			.SetSeparateTexture(_is3D)
			.SetSpeed(sprite_get_speed(_spriteIdentifier))
			.SetSpeedType(sprite_get_speed_type(_spriteIdentifier));
		
		array_push(__batchImageList, _spriteData);
		
		if (__state == CollageBuildStates.NORMAL) && (__status == CollageStatus.READY) {
			__builder.__build();
		}
		
		if (__state == CollageBuildStates.BATCHING) {
			return _spriteData;	
		}
	}
	
	static AddFileStrip = function(_fileName, _identifierString = undefined, _removeBack = false, _smooth = false, _xOrigin = 0, _yOrigin = 0, _is3D = false) {
		if (!__CollageFileFromWeb(_fileName)) && (!file_exists(_fileName)) {
			// It doesn't exist, obviously!
			__CollageTrace(__getName() + "File " + string(_fileName) + " doesn't exist!");
			return -1;
		}
		
		var _identifier = _identifierString ?? __CollageGetName(_fileName);	
		
		var _spriteSheet = sprite_add(_fileName, 1, _removeBack, _smooth, _xOrigin, _yOrigin);
		if (_spriteSheet == -1) {
			__CollageTrace(__getName() + "File " + string(_fileName) + " has an invalid formatting!");
			exit;
		}
		
		var _spriteData = new __CollageSpriteFileDataClass(_identifier, _spriteSheet).SetSeparateTexture(_is3D);
		
		if (__CollageFileFromWeb(_fileName)) {
			if (__COLLAGE_VERBOSE) __CollageTrace("Adding " + string(_fileName) + " to asynchronous listing...");
			__isWaitingOnAsync = true;
			__status = CollageStatus.WAITING_ON_FILES;
			var _i = 0;
			repeat(array_length(__system.__CollageAsyncList)) {
				if (__system.__CollageAsyncList[_i] == self) {
					break;	
				}
				++_i;
			}
			
			if (_i == array_length(__system.__CollageAsyncList)) {
				array_push(__system.__CollageAsyncList, self);
			}
			
			array_push(__asyncList, [_spriteData, method_get_index(__InternalAddFileStrip), [_spriteData, _removeBack, _smooth, _xOrigin, _yOrigin, _is3D]]);
		} else {
			__InternalAddFileStrip(_spriteData, _removeBack, _smooth, _xOrigin, _yOrigin, _is3D);
		}
		
		if (__state == CollageBuildStates.NORMAL) && (__status == CollageStatus.READY) {
			__builder.__build();
		}
		
		if (__state == CollageBuildStates.BATCHING) {
			return _spriteData;	
		}
	}
	
	static __InternalAddFileStrip = function(_spriteData, _removeBack, _smooth, _xOrigin, _yOrigin) {	
		var _spriteSheet = _spriteData.__spriteID;
		var _width = sprite_get_width(_spriteSheet);
		var _height = sprite_get_height(_spriteSheet);
		var _surf = -1;
		var _subImages = 1;
		var _offset = _width > _height ? round(_width / _height) : round(_height / _width);
		
		if (_offset > 1) {
			if (_width > _height) {
				_width = _height;
			
				_subImages = _offset;
				var _i = 0;
				_surf = surface_create(_width, _height);
				var _sprite = -1;
				
				CollageSterlizeGPUState();
				repeat(_offset) {
					surface_set_target(_surf);
					draw_clear_alpha(0, 0);
					draw_sprite_part(_spriteSheet, 0, _i*_width, 0, _width, _height, 0, 0);
					surface_reset_target();
					++_i;
					if (!sprite_exists(_sprite)) {
						_sprite = sprite_create_from_surface(_surf, 0, 0, _width, _height, _removeBack, _smooth, _xOrigin, _yOrigin);	
					} else {
						sprite_add_from_surface(_sprite, _surf, 0, 0, _width, _height, _removeBack, _smooth);
					}
				}
				CollageRestoreGPUState();	
			} else {
				_height = _width;
			
				_subImages = _offset;
				var _i = 0;
				_surf = surface_create(_width, _height);
				var _sprite = -1;
				
				CollageSterlizeGPUState();
				repeat(_offset) {
					surface_set_target(_surf);
					draw_clear_alpha(0, 0);
					draw_sprite_part(_spriteSheet, _height, 0, _i*_height, _width, _height, 0, 0);
					surface_reset_target();
					++_i;
					if (!sprite_exists(_sprite)) {
						_sprite = sprite_create_from_surface(_surf, 0, 0, _width, _height, _removeBack, _smooth, _xOrigin, _yOrigin);	
					} else {
						sprite_add_from_surface(_sprite, _surf, 0, 0, _width, _height, _removeBack, _smooth);
					}
				}
				CollageRestoreGPUState();
			}
		} else {
			_sprite = sprite_duplicate(_spriteSheet);	
		}
		_spriteData.__spriteID = _sprite;
		_spriteData.__subImages = _subImages;
		sprite_delete(_spriteSheet);
		
		array_push(__batchImageList, _spriteData);
		if (_surf != -1) surface_free(_surf);
		_spriteData.SetOrigin(_xOrigin, _yOrigin);
		return _spriteData;
	}	
	
	static AddSurface = function(_surface, _identifierString = undefined, _x = 0, _y = 0, _w = surface_get_width(_surface), _h = surface_get_height(_surface), _removeBack = false, _smooth = false, _xOrigin = 0, _yOrigin = 0, _is3D = false) {
		
		var _spriteID = sprite_create_from_surface(_surface, _x, _y, _w, _h, _removeBack, _smooth, _xOrigin, _yOrigin);
		
		var _identifier = _identifierString ?? "surface" + string(_surface);	
		// Add sprite data
		
		var _spriteData = new __CollageSpriteFileDataClass(_identifier, _spriteID, 1).SetOrigin(_xOrigin, _yOrigin).SetSeparateTexture(_is3D);
		
		array_push(__batchImageList, _spriteData);
		
		if (__state == CollageBuildStates.NORMAL) && (__status == CollageStatus.READY) {
			__builder.__build();
		}
		
		if (__state == CollageBuildStates.BATCHING) {
			return _spriteData;	
		}
	}
	
	static AddSpriteSheetSingle = function(_spriteID, _frames, _name = undefined, _x, _y, _width, _height, _horizontal = true, _removeBack = false, _smooth = false, _xOrigin = 0, _yOrigin = 0, _is3D = false) {
		if (_frames <= 0) {
			__CollageThrow("Frames are negative! Got " + string(_frames) + ", expected 1 or more!");
		}
		
		var _spriteWidth = sprite_get_width(_spriteID);
		var _spriteHeight = sprite_get_height(_spriteID);
		
		var _maxFrames = (_spriteWidth div _width) * (_spriteHeight div _height);
		if (_frames > _maxFrames) {
			__CollageThrow("Frames exceed possible maximumm " + string(_frames) + ", expected 1 or more!");
			return;
		}

		var _i = 0;
		var _surf = surface_create(_width, _height);
		var _newSprite = -1;
		
		CollageSterlizeGPUState();
		var _i = 0;
		var _offset = _width > _height ? _width : _height;
		repeat(_frames) {
			surface_set_target(_surf);
			draw_clear_alpha(0, 0);
			if (_horizontal) {
				var _xPos = ((_x + _i)  mod _spriteWidth);
				var _yPos = ((_y + _i) div _spriteHeight)*_height;
			} else {
				var _xPos = ((_x + _i)  div _spriteWidth)*_width;
				var _yPos = ((_y + _i) mod _spriteHeight);	
			}
			draw_sprite_part(_spriteID, 0, _xPos, _yPos, _width, _height, 0, 0);
			surface_reset_target();
			if (!sprite_exists(_newSprite)) {
				_newSprite = sprite_create_from_surface(_surf, 0, 0, _width, _height, _removeBack, _smooth, 0, 0);	
			} else {
				sprite_add_from_surface(_newSprite, _surf, 0, 0, _width, _height, _removeBack, _smooth);
			}
			_i += _offset;
		}
		
		var _spriteData = new __CollageSpriteFileDataClass(_name, _newSprite, _frames).SetOrigin(_xOrigin, _yOrigin).SetSeparateTexture(_is3D);
		array_push(__batchImageList, _spriteData);
		CollageRestoreGPUState();
		
		if (__state == CollageBuildStates.NORMAL) {
			__builder.__build();
		}
		surface_free(_surf);
		
		if (__state == CollageBuildStates.BATCHING) {
			return _spriteData;	
		}
	}
	
	static AddSpriteSheet = function(_spriteID, _spriteArray, _identifierString, _width, _height, _removeBack = false, _smooth = false, _xOrigin = 0, _yOrigin = 0, _is3D = false) {
		if (is_undefined(_spriteArray)) {
			__CollageThrow("spriteArray String in .AddSpriteSheet() is undefined!");	
		}
		
		if (is_undefined(_identifierString)) {
			__CollageThrow("Identifier String in .AddSpriteSheet() is undefined!");	
		}
		
		var _i = 0;
		var _surf = surface_create(_width, _height);
		var _newSprite = -1;
		var _imageArray = [];
		
		CollageSterlizeGPUState();
		repeat(array_length(_spriteArray)) {
			var _imageStruct = _spriteArray[_i];
			var _xSize = _imageStruct[3];
			var _ySize = _imageStruct[4];
			var _subImages = max((_xSize >= _ySize ? (_xSize div _ySize) : (_ySize div _xSize)) - 1, 1);
			var _j = 1;
			repeat(_subImages) {
				surface_set_target(_surf);
				draw_clear_alpha(0, 0);
				var _xPos = _subImages > 1 ? (_xSize >= _ySize ? (_j*_width) : (_imageStruct[1])) : _imageStruct[1];
				var _yPos = _subImages > 1 ? (_xSize >= _ySize ? (_imageStruct[2]) : (_j*_height))  : _imageStruct[2];
				draw_sprite_part(_spriteID, 0, _xPos, _yPos, _width, _height, 0, 0);
				surface_reset_target();
				if (!sprite_exists(_newSprite)) {
					_newSprite = sprite_create_from_surface(_surf, 0, 0, _width, _height, _removeBack, _smooth, 0, 0);	
				} else {
					sprite_add_from_surface(_newSprite, _surf, 0, 0, _width, _height, _removeBack, _smooth);
				}
				++_j;
			}
			var _name = (string_count("{{name}}", _imageStruct[0]) > 0) ? string_replace_all(_imageStruct[0], "{{name}}", _identifierString) : _identifierString + _imageStruct[0];
			var _spriteData = new __CollageSpriteFileDataClass(_name, _newSprite, _subImages).SetOrigin(_xOrigin, _yOrigin).SetSeparateTexture(_is3D);
			array_push(__batchImageList, _spriteData);
			array_push(_imageArray, _spriteData);
			_newSprite = -1;
			++_i;
		}
		CollageRestoreGPUState();
		
		if (__state == CollageBuildStates.NORMAL) {
			__builder.__build();
		}
		surface_free(_surf);
		
		if (__state == CollageBuildStates.BATCHING) {
			return _imageArray;	
		}
	}
	#endregion
	
	static Clear = function() {
		if (__destroyed) return;
		var _i = 0;
		repeat(array_length(__texPageArray)) {
			__texPageArray[_i++].Free();	
		}
		
		__texPageCount = 0;
		var _i = 0;
		if (__COLLAGE_IMAGES_ARE_PUBLIC) {
			repeat(__imageCount) {
				variable_struct_remove(__system.__CollageImageMap, __imageList[_i++].__name);
			}	
		}
		
		__builder.init = false;
		array_resize(__builder.bboxPoints, 0);
		__imageCount = 0;
		__imageList = [];
		__imageMap = {};
		__texPageArray = [];
	}
	
	static GetTexturePage = function(_index) {
		if (_index < __texPageCount) && (_index >= 0) {
			return __texPageArray[_index];
		}
		
		return undefined;
	}
	
	static GetTexture = function(_index) {
		if (_index < __texPageCount) && (_index >= 0) {
			return __texPageArray[_index].GetTexture();
		}
		
		return undefined;
	}
	
	/// @Deprecated
	static GetCount = function() {
		return GetTextureCount();
	}
	
	static GetTextureCount = function() {
		return __texPageCount;
	}
	
	static GetImageCount = function() {
		return array_length(__imageList);
	}
		
	static FlushPages = function() {
		var _len = __texPageCount;
		var _i = 0;
		repeat(_len) {
			__texPageArray[_i++].__UnloadVRAM();
		}
	}
	
	static FlushPage = function(_index) {
		if (_index >= 0 && _index < __texPageCount) {
			__texPageArray[_index].__UnloadVRAM();
		}
	}
	
	static PrefetchPages = function() {
		var _len = __texPageCount;
		var _i = 0;
		repeat(_len) {
			__texPageArray[_i++].CheckSurface();
		}
	}
	
	static PrefetchPage = function(_index) {
		if (_index >= 0 && _index < __texPageCount) {
			__texPageArray[_index].CheckSurface();
		}	
	}
	
	static Destroy = function() {
		if (__destroyed) return;
		Clear();
		var _i = 0;
		repeat(array_length(__system.__CollageTexturePagesList)) {
			if (__system.__CollageTexturePagesList[_i] == self) {
				array_delete(__system.__CollageTexturePagesList, _i, 1);
				break;
			}
			_i++;
		}
		if (is_string(__name)) {
			variable_struct_remove(__system.__CollageTexturePagesMap, __name);
		}
		
		// Demolish states
		__builder = undefined;
		__imageList = undefined;
		__imageMap = undefined;
		__texPageArray = undefined;
		__destroyed = true;
	}
	
	/// @return {Struct.__CollageImageClass} collage_image
	static GetImageInfo = function(_identifier) {
		return __imageMap[$ _identifier];	
	}
	
	static ImagesToArray = function(_sorted = false) {
		var _array = array_create(array_length(__imageList));
		var _i = 0;
		repeat(array_length(_array)) {
			_array[_i] = __imageList[_i];
			++_i;
		}
		if (_sorted) {
			array_sort(_array, true);	
		}
		return _array;
	}
	
	static TexturePagesToArray = function(_sorted = false) {
		var _array = array_create(GetTextureCount());
		var _i = 0;
		repeat(array_length(_array)) {
			_array[_i] = GetTexturePage(_i);
			++_i;
		}
		if (_sorted) {
			array_sort(_array, true);	
		}
		return _array;
	}
	
	static ImagesNamesToArray = function() {
		var _array = variable_struct_get_names(__imageMap);
		return _array;
	}
	
	static GetStatus = function() {
		return __status;
	}
	
	static Exists = function(_identifier) {
		return variable_struct_exists(__imageMap, _identifier);
	}
	
	static Cache = function() {
		var _len = __texPageCount;
		var _i = 0;
		repeat(_len) {
			__texPageArray[_i++].__CacheTexture();
		}
	}
	
	static __GetId = function() {
		return __id;
	}
	
	static GetName = function() {
		return __name;
	}
	
	static ToStaticBuilder = function(_prefetch = false, _removeSelf = false) {
		return new __CollageStaticGroupBuilderClass(self, _prefetch, _removeSelf);
	}
	
	static ToStatic = function(_prefetch = false, _removeSelf = false) {
		// This function is mainly used for 
		var _texturePages = TexturePagesToArray();
		var _texturePagesCount = GetTextureCount();
		var _name = GetName();
		
		var _paths = array_create(_texturePagesCount);
		// Save Pages
		for(var _i = 0; _i < _texturePagesCount; ++_i) {
			//var _filepath = $"{__COLLAGE_DEFAULT_SAVE_FILEPATH}{_name}_{_i}.png";
			_paths[_i] = _texturePages[_i].ToQOIF();
			//_texturePages[_i].CheckSurface();
			//var _surf = _texturePages[_i].GetSurface();
			//surface_save(_surf, _filepath);
		}
	
		var _element = new __CollageStaticGroupClass(self, _paths, _texturePagesCount, _prefetch, _removeSelf);
		return _element;
	}
	
	static ExportData = function() {
		var _data = {
			separation: __separation,
			crop: __crop,
			width: __width,
			height: __height,
			optimize: __optimize,
			texturePages: array_create(__texPageCount, undefined),
			images: array_create(__imageCount, undefined),
			name: __name,
			id: __id,
		};
		
		for(var _i = 0; _i < __imageCount; ++_i) {
			_data.images[_i] = __imageList[_i].ExportData();
		}
		
		for(var _i = 0; _i < __texPageCount; ++_i) {
			var _texPage = GetTexturePage(_i);
			_data.texturePages[_i] = {
				width: _texPage.GetWidth(),
				height: _texPage.GetHeight(),
			};
		}
		
		return _data;
	}
	
	static GetRecent = function() {
		return __recent;
	}
	
	static ToJSON = function(_pretty = false) {
		return json_stringify(ExportData(), _pretty);
	}
	
	static SaveAsPNGs = function(_filepath, _pretty = false) {
		var _json = ExportData();
		var _len = array_length(_json.texturePages);
		for(var _i = 0; _i < _len; ++_i) {
			_json.texturePages[_i].filename = $"{__name}_{_i}.png";
		}
		
		_json = json_stringify(_json, _pretty);
		
		for(var _i = 0; _i < __texPageCount; ++_i) {
			var _texPage = GetTexturePage(_i);
			_texPage.CheckSurface();
			surface_save(_texPage.GetSurface(), $"{_filepath}/{__name}_{_i}.png");
		}
		
		var _buff = buffer_create(string_byte_length(_json), buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _json);
		buffer_save(_buff, $"{_filepath}/{__name}.json");
		buffer_delete(_buff);
	}
	#endregion 	
	
	
	#region UNUSED
	/// TODO: Add saving/loading properly.
	//static savePageToBuffer = function() {
	//	var ___texPageCount = __texPageCount;
	//	var ___imageCount =	__imageCount;
	//	var _bboxPointsCount = array_length(__builder.bboxPoints);
	//	var _stringByte = 0;
	//	var _subImagesCount = 0;
	//	
	//	// Get image names
	//	var _i = 0;
	//	repeat(___imageCount) {
	//		_stringByte += string_byte_length(__imageList[_i].name) + 1;
	//		_subImagesCount += __imageList[_i]. subImagesCount;
	//		++_i;
	//	}
	//	
	//	/*#macro __TGM_HEADER_FORMAT 13
	//	#macro __TGM_SPRITE_FORMAT 12
	//	#macro __TGM_UV_FORMAT 20 + 8 // 8 for 4byte float
	//	#macro __TGM_SPACEPOINTS_FORMAT 8
	//	var _headerSize = __TGM_HEADER_FORMAT + _stringByte + (__TGM_SPRITE_FORMAT * ___imageCount) + (__TGM_UV_FORMAT * _subImagesCount) + __TGM_SPACEPOINTS_FORMAT;*/
	//	
	//	// Create buffer
	//	var _groupBuffer = buffer_create(1, buffer_grow, 1);
	//	
	//	// Write Header
	//	buffer_write(_groupBuffer, buffer_u16, width); // 2 Bytes
	//	buffer_write(_groupBuffer, buffer_u16, height); // 2 Bytes
	//	buffer_write(_groupBuffer, buffer_u8, _bboxPointsCount); // 1 Bytes
	//	buffer_write(_groupBuffer, buffer_u32, __imageCount); // 4 Bytes
	//	buffer_write(_groupBuffer, buffer_u32, __texPageCount); // 4 Bytes
	//	
	//	// Write Image Format
	//	var _i = 0;
	//	repeat(___imageCount) {
	//		buffer_write(_groupBuffer, buffer_string, imageList[_i].name); // String byte length + null
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].width); // 2 byte
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].height);  // 2 byte
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].cropWidth); // 2 byte
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].cropHeight);  // 2 byte
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].xoffset); // 2 byte
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].yoffset); // 2 byte
	//		buffer_write(_groupBuffer, buffer_u16, imageList[_i].subImagesCount); // 2 byte
	//		buffer_write(_groupBuffer, buffer_f32, imageList[_i].ratio); // 4 byte
	//		
	//		// Write UV format
	//		var _imageSub__imageCount = imageList[_i].subImagesCount;
	//		var _j = 0;
	//		var _subImages = imageList[_i].subImagesArray;
	//		repeat(_imageSub__imageCount) {
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].texturePageNum); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].left); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].right); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].top); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].bottom); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].trimLeft); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].trimTop); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].xPos); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_u16, _subImages[_j].yPos); // 2 Byte
	//			buffer_write(_groupBuffer, buffer_f32, _subImages[_j].normTop); // 4 Byte
	//			buffer_write(_groupBuffer, buffer_f32, _subImages[_j].normLeft); // 4 Byte
	//			buffer_write(_groupBuffer, buffer_f32, _subImages[_j].normRight); // 4 Byte
	//			buffer_write(_groupBuffer, buffer_f32, _subImages[_j].normBottom); // 4 Byte
	//			++_j;
	//		}
	//		++_i;
	//	}
	//	
	//	// Save texture page data	
	//_i = 0;
	//repeat(__texPageCount) {
	//	var _size = width*height*4;
	//	var _texBuffer = buffer_create(_size, buffer_fixed, 4);
	//	buffer_get_surface(_texBuffer, _surf, 0);
	//	//var _comTexBuffer = buffer_compress(_texBuffer, 0, _size);
	//	buffer_resize(_groupBuffer, buffer_get_size(_groupBuffer) + _size);
	//	buffer_copy(_texBuffer, 0, _size, _groupBuffer, buffer_get_size(_groupBuffer));
	//	buffer_delete(_texBuffer);
	//}
	//	return _groupBuffer;
	//}
	#endregion
}
