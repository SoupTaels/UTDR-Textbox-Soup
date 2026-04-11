/// @ignore
/// feather ignore all
function __CollageImageClass(_spriteStruct, _name, _cropW, _cropH, _tiling, _ratio, _xOffset, _yOffset, _hashes) constructor {
	__width = _spriteStruct.spriteInfo.width;
	__height  = _spriteStruct.spriteInfo.height;
	__cropWidth = _cropW;
	__cropHeight = _cropH;
	__xoffset = _xOffset;
	__yoffset = _yOffset;
	__name = _name;
	__subImagesCount = _spriteStruct.spriteInfo.num_subimages;
	__subImagesArray = array_create(__subImagesCount, undefined);
	__ratio = _ratio;
    __scaled = 1/_ratio;
	__tiling = _tiling;
	__speed = _spriteStruct.spriteData.__speed;
	__speedType = _spriteStruct.spriteData.__speedType;
	__hashes = _hashes;
	
	static __InternalGetUvs = function(_imageIndex) {
		return __subImagesArray[_imageIndex % __subImagesCount];
	}
	
	static ExportData = function() {
		var _data = { 
			width: __width,
			height: __height,
			cropWidth: __cropWidth,
			cropHeight: __cropHeight,
			xoffset: __xoffset,
			yoffset: __yoffset,
			tiling: __tiling,
			name: __name,
			framesCount: __subImagesCount,
			ratio: __ratio,
			scaled: __scaled,
			speed: __speed,
			speedType: __speedType,
			uvs: array_create(__subImagesCount),
			hashes: __hashes,
		};
		
		for(var _i = 0; _i < __subImagesCount; ++_i) {
			_data.uvs[_i] = GetUVs(_i).ExportData();
		}
		return _data;
	}
    
    static SetXOffset = function(_value) {
        __xoffset = _value;
        var _i = 0;
        repeat(GetCount()) {
            var _uvs = GetUVs(_i);
                _uvs.xPos = __xoffset-_uvs.trimLeft;
            ++_i;
        }
        return self;
    }
    
    static SetYOffset = function(_value) {
        __yoffset = _value;
        var _i = 0;
        repeat(GetCount()) {
            var _uvs = GetUVs(_i);
                _uvs.yPos = __yoffset-_uvs.trimTop;
            ++_i;
        }
        return self;
    }
    
    static SetXYOffset = function(_x, _y) {
        SetXOffset(_x);
        SetYOffset(_y);
        return self;
    }
	
	static SetSpeed = function(_value) {
		__speed = _value;
		return self;
	}
	
	static SetSpeedType = function(_value) {
		__speedType = _value;
		return self;
	}
	
	static CalcImageIndex = function(_index = 0, _speed = 1, _fps = game_get_speed(gamespeed_fps)) {
		return (__speedType == spritespeed_framespergameframe ? 
		(_index + (1 * GetSpeed() * _speed)):
		(_index + (1 * (GetSpeed()/_fps) * _speed))) % GetCount();
	}
	
	static GetSpeed = function() {
		return __speed;	
	}
	
	static GetSpeedType = function() {
		return __speedType;	
	}
	
	static GetName = function() {
		return __name;	
	}
	
	static GetWidth = function() {
		return __width;	
	}
	
	static GetHeight = function() {
		return __height;	
	}
	
	static GetXOffset = function() {
		return __xoffset;	
	}
	
	static GetYOffset = function() {
		return __yoffset;	
	}
	
	static GetUVs = function(_imageIndex) {
		return __InternalGetUvs(_imageIndex);	
	}
	
	static GetSurface = function(_imageIndex) {
		var _texPage = __subImagesArray[_imageIndex % __subImagesCount].texturePageStruct;
		return _texPage.GetSurface();	
	}
	
	static GetTexture = function(_imageIndex) {
		var _texPage = __subImagesArray[_imageIndex % __subImagesCount].texturePageStruct;
		return _texPage.GetTexture();	
	}
	
	static GetTexturePage = function(_imageIndex) {
		return __subImagesArray[_imageIndex % __subImagesCount].texturePageStruct;
	}
	
	/// @deprecated
	static GetCount = function() {
		return __subImagesCount;	
	}
	
	static GetFrameCount = function() {
		return __subImagesCount;
	}
	
	static SaveToFile = function(_index, _filename = GetName() + "_" + string(_index) + ".png") {
		var _sprite = ToSprite();
		sprite_save(_sprite, _index, _filename);
		sprite_delete(_sprite);
	}
	
	static SaveStripToFile = function(_filename = GetName() + "_strip" + string(GetCount()) + ".png") {
		var _sprite = ToSprite();
		sprite_save_strip(_sprite, _filename);
		sprite_delete(_sprite);
	}
	
	static ToSprite = function() {
		var _uvs = GetUVs(0);
		var _sprite = sprite_create_from_surface(_uvs.texturePageStruct.GetSurface(), _uvs.left, _uvs.top, _uvs.right, _uvs.bottom, false, false, 0, 0);
		
		var _i = 1;
		repeat(GetCount()-1) {
			_uvs = GetUVs(_i);
			sprite_add_from_surface(_sprite, _uvs.texturePageStruct.GetSurface(), _uvs.left, _uvs.top, _uvs.right, _uvs.bottom, false, false);	
			++_i;
		}	
		return _sprite;
	}
}
