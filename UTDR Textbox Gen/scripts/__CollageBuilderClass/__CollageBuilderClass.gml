// To be added
//var _gpuBlendMode = gpu_get_blendmode_ext_sepalpha();
//gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_inv_src_alpha);

/// @ignore
/// feather ignore all
function __CollageBuilderClass() constructor {
	/// feather ignore all
	static __system = __CollageSystem();
	owner = other;
	bboxPoints = [];
	init = false;
	freeSpacePoints = [];
	
	static __drawImage = function(_spriteData, _spriteID, _sub, _drawXValue, _drawYValue, _drawWValue, _drawHValue, _currentPoint = undefined, _ratio = 1, _wScale = 1, _hScale = 1) {
		// Check Premultiply properties
		if (_spriteData.__premultiplyAlpha) {
			var _gpuBlendEnable = gpu_get_blendenable();	
			var _gpuBlendMode = gpu_get_blendmode_ext();
			gpu_set_blendenable(true);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(__ShdCollagePremultiply);
		}
		
		static __defaultCP = {
			left: 0,
			top: 0
		}
        
		
		var _point = _currentPoint ?? __defaultCP;
		
		var _tiling = __CollageExtractTiling(_spriteData.__tiling);
		
		var _drawX = (_tiling[0]) ? _drawXValue+2 : _drawXValue;
		var _drawW = (_tiling[0]) ? _drawWValue-2 : _drawWValue;
		var _drawY = (_tiling[1]) ? _drawYValue+2 : _drawYValue;
		var _drawH = (_tiling[1]) ? _drawHValue-2 : _drawHValue;
		var _width = sprite_get_width(_spriteID);
		var _height = sprite_get_height(_spriteID);
		var _col = _spriteData.__colour;
		var _alpha = _spriteData.__alpha;
		
		draw_sprite_part_ext(
			_spriteID, 
			_sub, 
			_drawXValue, 
			_drawYValue, 
			_drawWValue, 
			_drawHValue, 
			_point.left + ((_tiling[0]) ? 2 : 0), 
			_point.top + ((_tiling[1]) ? 2 : 0), 
			_ratio, 
			_ratio, 
			_col, 
			_alpha
		);
		
		#region Tiling
		// Horizontal Tiling
		if (_tiling[0]) {
			// Left
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawW, 
				_drawYValue, 
				2, 
				_drawHValue, 
				_point.left, 
				_point.top + ((_tiling[1]) ? 2 : 0), 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
			// Right
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawX-2, 
				_drawYValue, 
				2, 
				_drawHValue, 
				_point.left + _width + 2, 
				_point.top + ((_tiling[1]) ? 2 : 0), 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
		}
		
		// Vertical Tiling
		if (_tiling[1]) {
			// Top
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawXValue, 
				_drawH, 
				_drawWValue, 
				2, 
				_point.left + ((_tiling[0]) ? 2 : 0), 
				_point.top, 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
			// Bottom
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawXValue, 
				_drawYValue, 
				_drawWValue, 
				2, 
				_point.left + ((_tiling[0]) ? 2 : 0), 
				_point.top + _height + 2, 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
		}
		
		// Horizontal + Vertical Tiling
		if (_tiling[0] && _tiling[1]) {
			// Left Top Corner
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawW,
				_drawH,
				2,
				2,
				_point.left, 
				_point.top, 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
			
			// Right Top Corner
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawXValue,
				_drawH,
				2,
				2,
				_point.left + _width + 2, 
				_point.top, 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
			
			// Left Bottom Corner
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawW,
				_drawYValue,
				2,
				2,
				_point.left, 
				_point.top + _height + 2, 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
			
			// Right Bottom Corner
			draw_sprite_part_ext(
				_spriteID, 
				_sub, 
				_drawXValue,
				_drawYValue,
				2,
				2,
				_point.left + _width + 2, 
				_point.top + _height + 2, 
				_ratio, 
				_ratio, 
				_col, 
				_alpha
			);
		}
		#endregion
		
		if (_spriteData.__premultiplyAlpha) {
			gpu_set_blendenable(_gpuBlendEnable);	
			gpu_set_blendmode_ext(_gpuBlendMode);
			shader_reset();
		}
		
		if (__COLLAGE_RENDER_DEBUG_LINES) {
			draw_set_colour(make_color_hsv((current_time * 5) mod 256, 255, 255));
			draw_rectangle(_point.left+1,_point.top+1,_point.left+_wScale-2,_point.top+_hScale-2, true);
			draw_set_colour(c_white);	
		}	
	}
	
	static __checkImage = function(_str) {
		/* Feather ignore once GM2047 */
		if (__COLLAGE_IMAGES_ARE_PUBLIC) {
			return variable_struct_exists(__system.__CollageImageMap, _str);	
		} else {
			return variable_struct_exists(owner.__imageMap, _str);	
		}
	}
	
	static __getImage = function(_str) {
		if (__COLLAGE_IMAGES_ARE_PUBLIC) {
			return __system.__CollageImageMap[$ _str];	
		} else {
			return owner.__imageMap[$ _str];	
		}
	}
	
	static __setImage = function(_str, _data) {
		if (__COLLAGE_IMAGES_ARE_PUBLIC) {
			__system.__CollageImageMap[$ _str] = _data;	
		} else {
			owner.__imageMap[$ _str] = _data;	
		}
	}
	
	static __bboxSort = function(_elm1, _elm2) {	
		if (_elm1.spriteData.__priority >= 0) || (_elm2.spriteData.__priority >= 0) {
			return _elm2.spriteData.__priority - _elm1.spriteData.__priority;
		}
		
		var _sizeA, _sizeB;
		_sizeA = ((_elm2.bbWidth + (_elm2.tiling[0] ? 2 : 0)) + (_elm2.bbHeight + (_elm2.tiling[1] ? 2 : 0))) * .5; 
		_sizeB = ((_elm1.bbWidth + (_elm1.tiling[0] ? 2 : 0)) + (_elm1.bbHeight + (_elm1.tiling[1] ? 2 : 0))) * .5;
		return  _sizeA - _sizeB;
	}
	
	// Unused currently. See __CollageHashGenerator()
	static __HashCompare = function(_hashA, _hashB) {
		//var _hashA = __CollageHashGenerator(_spriteData.__spriteID);
		//var _img = __getImage(_spriteData.__name);
		//if (is_undefined(_img)) {
		//	return false;	
		//}
		//
		//return (_hashA == _img.__hash); 
		var _hashLengthB = array_length(_hashB);
		
		if (array_length(_hashA) != _hashLengthB) return false;
		var _i = 0;
		var _count = 0;
		repeat(array_length(_hashA)) {
			if (_i >= _hashLengthB) return false;
			if (_hashA[_i] == _hashB[_i]) {
				//++_count;
				return true;
			}
			++_i;
		}
		return false;
		
	}
	
	static __build = function() {	
		static __hashData = (__COLLAGE_USE_HASHES && owner.GetHashing()) ? __CollageHashData() : undefined;
		// Store building time for verbose later
		var _startTime = get_timer();
		array_resize(owner.__recent, 0);
		
		// Separate entries
		var _len = array_length(owner.__batchImageList);
		var _collageName = owner.__getName();
		if (_len == 0) {
			__CollageTrace(_collageName +"Building was commenced but there was no images to pack!");
			exit;
		}
		
		
		__CollageTrace(_collageName +"Building commenced! Attempting to pack " + string(array_length(owner.__batchImageList)) + " images!");
		// Begin gather texture data
		var _crop = owner.__crop;
		var _texWidth = owner.__width;
		var _texHeight = owner.__height;
		var _spriteList = array_create(array_length(owner.__batchImageList));
		array_copy(_spriteList, 0, owner.__batchImageList, 0, array_length(owner.__batchImageList));
		array_resize(owner.__batchImageList, 0);
		var _batchMode = (owner.__state == CollageBuildStates.BATCHING);
		var _normalSprites = array_create(array_length(_spriteList));
		var _3DSprites = array_create(array_length(_spriteList));
		var _texPage = array_length(owner.__texPageArray) == 0 ? new __CollageTexturePageClass(_texWidth, _texHeight) : owner.__texPageArray[array_length(owner.__texPageArray)-1];
		var _sep = owner.__separation;
		var _3DArraySize = 0;
		var _normalArraySize = 0;
		var _optimize = owner.__optimize;
		var _rejectedImages = 0;
		
		#region Image parsing
		var _sterlized = CollageIsGPUStateSterlized();
	
		// Force sterlizing and restoring, in case something was altered)
		if (_sterlized) {
			CollageRestoreGPUState();	
		}

		CollageSterlizeGPUState();
		
		// Early check out of boundaries + data.
		// This check is here to ensure that sprites are both ordered, and that we only get sprites that are valid.
		var _i = 0;
		var _isRejected = false;
		var _hashList = [];
		repeat(_len) {
				_isRejected = false;
				var _spriteData = _spriteList[_i];
				var _spriteID = _spriteData.__spriteID;
				var _spriteInfo = sprite_get_info(_spriteID);
				var _sprWidth = _spriteInfo.width;
				var _sprHeight = _spriteInfo.height;
				var _drawX, _drawY, _drawW, _drawH;
				var _xScale = 1;
				var _yScale = 1;
				var _forceScaled = false;
				var _tiling = __CollageExtractTiling(_spriteData.__tiling);
				_drawX = ((_crop >= 1) ? ((_crop == 1 || _crop == 2) ? sprite_get_bbox_left(_spriteID) : 0) : 0);
				_drawY = ((_crop >= 1) ? ((_crop == 1 || _crop == 3) ? sprite_get_bbox_top(_spriteID) : 0) : 0);
				_drawW = ((_crop >= 1) ? ((_crop == 1 || _crop == 2) ? sprite_get_bbox_right(_spriteID)-_drawX+1 : _sprWidth) : _sprWidth);
				_drawH = ((_crop >= 1) ? ((_crop == 1 || _crop == 3) ? sprite_get_bbox_bottom(_spriteID)-_drawY+1 : _sprHeight) : _sprHeight);
				
				var _bbWidth = _drawW;
				var _bbHeight = _drawH;
				var _ratio = 1;
				
				// Exit early code
				if (_drawW + (_tiling[0] ? 4 : 0) > _texWidth || _drawH + (_tiling[1] ? 4 : 0) > _texHeight) {
					if (!__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) {
						__CollageTrace("Image " + "\"" + _spriteData.__name +  "\"" + " is too big! Skipping...");
						if (_spriteData.__isCopy) {
							sprite_delete(_spriteID);
						}
						array_delete(_spriteList, _i, 1);
						--_i;
						++_rejectedImages;
						_isRejected = true;
					} else {
						_xScale = _texWidth/_drawW;
						_yScale = _texHeight/_drawH;
						_ratio = min(_xScale, _yScale);
						_bbWidth = _ratio * _drawW;
						_bbHeight = _ratio * _drawH;
						__CollageTrace("Image " + "\"" + _spriteData.__name +  "\"" +  + " has been rescaled from width: " +  string(_drawW) + ", height: " + string(_drawH) + ", " + " to width: " + string(_bbWidth) + ", height: " + string(_bbHeight));
					}
				}
				
				if (_spriteData.__alpha <= 0.001) {
					__CollageTrace("Image " + "\"" + _spriteData.__name +  "\"" + " alpha is invalid! Value is at " + string(_spriteData.__alpha) + ". Skipping...");
					if (_spriteData.__isCopy) {
						sprite_delete(_spriteID);
					}
					array_delete(_spriteList, _i, 1);
					--_i;
					++_rejectedImages;	
					_isRejected = true;
				}
				
				
				if (!_isRejected) {
					var _newSpriteData = {
						spriteData: _spriteData,
						spriteID: _spriteID,
						spriteInfo: _spriteInfo,
						spriteWidth: _sprWidth,
						spriteHeight: _sprHeight,
						xScale: _xScale,
						yScale: _yScale,
						ratio: _ratio,
						bbWidth: _bbWidth + (_tiling[0] ? 2 : 0),
						bbHeight: _bbHeight + (_tiling[1] ? 2 : 0),
						drawX: _drawX,
						drawY: _drawY,
						drawW: _drawW,
						drawH: _drawH,
						wScale: _drawW * _ratio,
						hScale: _drawH * _ratio,
						originalWidth: _sprWidth,
						originalHeight: _sprHeight,
						tiling: _tiling,
						hashes: (__COLLAGE_USE_HASHES && owner.GetHashing() ? __CollageHashGenerator(_spriteID) : undefined),
					}
					_spriteList[_i] = _newSpriteData;
				}
				++_i;
		}
		_len = array_length(_spriteList);
		
		var _smallestImageWidth = infinity;
		var _smallestImageHeight = infinity;
		_i = 0;
		
		// Find earliest point to exit
		if ((_batchMode) && (_optimize)) {
			repeat(_len) {
				if (_spriteList[_i].bbWidth < _smallestImageWidth) || (_spriteList[_i].bbHeight < _smallestImageHeight) {
					_smallestImageWidth = _spriteList[_i].bbWidth;
					_smallestImageHeight = _spriteList[_i].bbHeight;
				}
				++_i;
			}
		}
		
		// Sort out by bbox
		if (_len > 1) {
			array_sort(_spriteList, __bboxSort);
		}
		
		_i = 0;
		
		// Separate sprites into two groups
		repeat(_len) {
			if (_spriteList[_i].spriteData.__is3D) {
				_3DSprites[_3DArraySize++] = _spriteList[_i];	
			} else {
				_normalSprites[_normalArraySize++] = _spriteList[_i];	
			}	
		
			++_i;
		}
		
					
		// Resize back down
		array_resize(_normalSprites, _normalArraySize);	
		
		array_resize(_3DSprites, _3DArraySize);	
		
		// Clear List
		array_delete(_spriteList, 0, _len);
		#endregion
		
		#region First time initialization
		if (init == false) {
			array_push(bboxPoints, new __CollageBBoxClass(_sep, _sep, _texWidth - _sep, _texHeight - _sep));
			init = true;
		}
		#endregion
		
		#region Normal texture pages first
		if (array_length(_normalSprites) > 0) {
			// Begin texture mapping
			_texPage.Start();	
		}
		
		
		var _spriteArrayLen = array_length(_normalSprites);
		for(var _ii = 0; _ii < _spriteArrayLen; ++_ii) {
			var _spriteStruct = _normalSprites[_ii];
			var _spriteData = _spriteStruct.spriteData;
				var _spriteID = _spriteStruct.spriteID;
				var _spriteInfo = _spriteStruct.spriteInfo;
				var _sprWidth = _spriteStruct.spriteWidth;
				var _sprHeight = _spriteStruct.spriteHeight;
				var _drawX = _spriteStruct.drawX, _drawY = _spriteStruct.drawY, _drawW = _spriteStruct.drawW, _drawH = _spriteStruct.drawH;
				var _xScale = _spriteStruct.xScale;
				var _yScale = _spriteStruct.yScale;
				var _wScale = _spriteStruct.wScale;
				var _hScale = _spriteStruct.hScale;
				var _ogW = _spriteStruct.originalWidth;
				var _ogH = _spriteStruct.originalHeight;
				var _xOffset = _spriteData.__xOrigin;
				var _yOffset = _spriteData.__yOrigin;
				var _subImages = _spriteInfo.num_subimages;
				var _hashes = _spriteStruct.hashes;
				
				var _ratio = _spriteStruct.ratio;
				var _tiling = _spriteStruct.tiling;
				var _bbWidth = _spriteStruct.bbWidth;
				var _bbHeight = _spriteStruct.bbHeight;
				
				var _subStart = 0;
				if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name +  + "\"" + " is currently being processed... 0/" + string(_spriteInfo.num_subimages));
				
				var _imageRegistered = false;
				if (__checkImage(_spriteData.__name)) {
					switch(__COLLAGE_IMAGE_NAME_COLLISION_HANDLE) {
						case 0:
							__CollageTrace(_collageName + _spriteData.__name + " already exists! Skipping...");
							--_normalArraySize;
							++_rejectedImages;
							continue;
							break;
						case 1:
							if (!(((_spriteInfo.width == __getImage(_spriteData.__name).width) && (_spriteInfo.height == __getImage(_spriteData.__name).height))
							&& (_spriteInfo.bbox_right-_spriteInfo.bbox_left+1 == __getImage(_spriteData.__name).cropWidth) && (_spriteInfo.bbox_bottom-_spriteInfo.bbox_top+1 == __getImage(_spriteData.__name).cropHeight))) {
								var _spriteName = _spriteData.__name;
								var _num = 1;
								var _name = _spriteName + string(_num);
								while(__checkImage(_name)) {
										var _name = _spriteName + string(++_num);
								}
								__CollageTrace(_collageName + _spriteData.__name + " already exists! Reidentified as " + _name);
								_spriteData.name = _name;
								
								var _imageInfo = new __CollageImageClass(_spriteStruct, _spriteData.__name, _drawW, _drawH, _spriteData.__tiling, _ratio, _xOffset, _yOffset, _hashes);
								// Lets add it to database
								__setImage(_spriteData.__name, _imageInfo);
								_imageRegistered = true;
							} else {
								// Same width/height
								// Loop
								var _subImageLen = _spriteInfo.num_subimages;
								var _imageInfo = CollageImageGetInfo(_spriteData.__name);
								var _uvsArray = _imageInfo.__subImagesArray;
								var _uvsArrayLength = array_length(_uvsArray);
								var _uvi = 0;         
								var _currentTexPage = _texPage;
								var _newTexPage = _texPage;
								var _changedTexPage = false;
								gpu_set_blendenable(true);
								repeat(_subImageLen) {
									if (_uvi >= _uvsArrayLength) break;
									var _uvs = _uvsArray[_uvi++];
									 _newTexPage = _uvs.texturePageStruct;
									if (_texPage != _newTexPage) {
										_changedTexPage = true;
										_texPage.Finish();  
										_texPage = _newTexPage;
										_texPage.Start();   
									}                    
									gpu_set_blendmode(bm_subtract);
									draw_rectangle_color(_uvs.left, _uvs.top, _uvs.left+_uvs.right,_uvs.top+ _uvs.bottom, c_black, c_black, c_black, c_black, false);
									gpu_set_blendmode(bm_normal);
									gpu_set_blendenable(false);
									__drawImage(_spriteData, _spriteID, _uvi-1, _drawX, _drawY, _drawW, _drawH, _uvs, _ratio, _wScale, _hScale);
								}                     
								                      
								if (_changedTexPage) {
									_texPage.Finish();   
									_texPage = _currentTexPage;
									_texPage.Start();    
								}                     
								                      
								                      
								var _subImages = _subImageLen;
								var _subStart = (_subImageLen > _uvsArrayLength) ? (_subImageLen - _uvsArrayLength) : _subImageLen;
								_imageInfo.subImagesCount = _subImageLen;
								__CollageTrace(_collageName + _spriteData.__name + " overwritten! (" + string(_subImageLen) + "/" + string(_uvsArrayLength) + ") Left over: " + string(max(_subImageLen - _uvsArrayLength, 0)));
								_imageRegistered = true;
							}                      
						break;
						
						case 2:
							var _spriteName = _spriteData.__name;
							var _num = 1;
							var _name = _spriteName + string(_num);
							while(__checkImage(_name)) {
									var _name = _spriteName + string(++_num);
							}
							__CollageTrace(_collageName + _spriteData.__name + " already exists! Reidentified as " + _name);
							_spriteData.__name = _name;
							
							var _imageInfo = new __CollageImageClass(_spriteStruct, _spriteData.__name, _drawW, _drawH, _spriteData.__tiling, _ratio, _xOffset, _yOffset, _hashes);
							// Lets add it to database
							__setImage(_spriteData.__name, _imageInfo);
							owner.__imageCount++;
							array_push(owner.__imageList, _imageInfo);
							array_push(owner.__recent, _imageInfo);
							_imageRegistered = true;
						break;
					}
				} 
				
				// Validation for KeepTogether
				var __forceNewTexturePage = false;
				if (_spriteData.__keepTogether) && (_subImages > 1) {
						var _tempBboxPoints = array_create(array_length(bboxPoints));
						array_copy(_tempBboxPoints, 0, bboxPoints, 0, array_length(bboxPoints));
						var _skipSprite = false;
						for(var _sub = 0; _sub < _subImages; ++_sub) {
							var _ktEmptySpaceSize = 0xFFFFFF;
							var _ktEmptySpaceID = -1;
							for(var _ktn = 0; _ktn < array_length(_tempBboxPoints); ++_ktn) {
								if( _bbWidth <= _tempBboxPoints[_ktn].right && _bbHeight <= _tempBboxPoints[_ktn].bottom) {
									var _resolve = (_tempBboxPoints[_ktn].right + _tempBboxPoints[_ktn].bottom ) / 2;
									if (_resolve < _ktEmptySpaceSize) {
										_ktEmptySpaceSize = _resolve;
										_ktEmptySpaceID = _ktn;
								    } 
								}
							}
							
							// We weren't able to find that all of them fit together
							if (_ktEmptySpaceID == -1) {
								
								var _totalImageSubImg = ((_texWidth * _texHeight) div (_bbWidth * _bbHeight));
								// We can't use this sprite PERIOD. Throw it out or scale it down!
								if (_subImages > (_totalImageSubImg)) {
									if (!__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) {
										__CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " can't clump together on new or current texture page! Skipping...");
										--_normalArraySize;
										_skipSprite = true;
										++_rejectedImages;
									} else {
										_xScale = _drawW/_texWidth;
										_yScale = _drawH/_texHeight;
										_ratio = min(_xScale, _yScale);
										_wScale = _drawW * _ratio;
										_hScale = _drawH * _ratio;
										_bbWidth = _ratio * _drawW;
										_bbHeight = _ratio * _drawH;
										__CollageTrace("Image " + "\"" + _spriteData.__name +  "\"" +  + " has been rescaled from width: " +  string(_drawW) + ", height: " + string(_drawH) + ", " + " to width: " + string(_bbWidth) + ", height: " + string(_bbHeight));
									}
									break;
								} else {
								// A sprite can fit!
								if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " can fit on new texture page! Pushing image down the queue...");
								__forceNewTexturePage = true;
								break;	
							}
						} else {
							var _currentPoint = _tempBboxPoints[_ktn-1];
							// Store next available space in our simulation
							if( _bbHeight < _currentPoint.bottom) { 
							    var _struct = new __CollageBBoxClass(_currentPoint.left, _currentPoint.top + _drawH + _sep + ((_tiling[1]) ? 4 : 0), _currentPoint.right , _currentPoint.bottom - _drawH - _sep + ((_tiling[1]) ? 4 : 0));
								array_push(_tempBboxPoints, _struct);
							}
							
							if( _bbWidth < _currentPoint.right) {
								var _struct = new __CollageBBoxClass(_currentPoint.left + _drawW + _sep + ((_tiling[0]) ? 4 : 0), _currentPoint.top, _currentPoint.right - _drawW - _sep  - ((_tiling[0]) ? 4 : 0), _drawH + ((_tiling[0]) ? 4 : 0));
								array_push(_tempBboxPoints, _struct);
							} 
							
							array_delete(_tempBboxPoints, _ktEmptySpaceID, 1);	
						}
						
						if (_skipSprite) break;
					}
					
					if (_skipSprite) {
						continue;	
					}
				}
				
				if (!_imageRegistered) {
					var _imageInfo = new __CollageImageClass(_spriteStruct, _spriteData.__name, _drawW, _drawH, _spriteData.__tiling, _ratio, _xOffset, _yOffset, _hashes);
					// Lets add it to database
					__setImage(_spriteData.__name, _imageInfo);
					
					owner.__imageCount++;
					array_push(owner.__imageList, _imageInfo);
					array_push(owner.__recent, _imageInfo);
					if (__COLLAGE_IMAGES_ARE_PUBLIC) owner.__imageMap[$ _spriteData.__name] = _imageInfo;	
				}
				
				// Find all conflicts
				if (__COLLAGE_USE_HASHES && owner.GetHashing()) {
					var _conflictCount = 0;
					var _j = 0;
					repeat(owner.__imageCount) {
						if (_spriteData.__name != owner.__imageList[_j].__name) && (__HashCompare(_hashes, owner.__imageList[_j].__hashes)) {
							// Find all conflicts
							var _hashesLength = array_length(_hashes);
							for(var _ci = 0; _ci < _hashesLength; ++_ci) {
								if (_hashes[_ci] == owner.__imageList[_j].__hashes[_ci]) {
									_imageInfo.__subImagesArray[_ci] = variable_clone(owner.__imageList[_j].GetUVs(_ci), 0);
									++_conflictCount;
								}
							}
							break;
						}
						++_j;
					}
					
					if (__COLLAGE_VERBOSE) && (_conflictCount > 0) {
						__CollageTrace($"{_collageName}Found {_conflictCount} image frame conflicts from \"{_spriteData.__name}\"! Given copy from \"{owner.__imageList[_j].__name}\"!");
					}
				}
				
				for(var _sub = _subStart; _sub < _subImages; ++_sub) {
					var _emptySpaceSize = 0xFFFFFF;
					var _emptySpaceID = -1;
					// Skip over since UVs already exist!
					if (_imageInfo.__subImagesArray[_sub] != undefined) continue;
					
					if (!__forceNewTexturePage) {
						var _len = array_length(bboxPoints);
						for(var _n = 0; _n < _len; ++_n) {
						     if( _bbWidth <= bboxPoints[_n].right && _bbHeight <= bboxPoints[_n].bottom) {
						         var _resolve = (bboxPoints[_n].right + bboxPoints[_n].bottom ) / 2;
								 if (_resolve < _emptySpaceSize) {
						             _emptySpaceSize = _resolve;
						             _emptySpaceID = _n;
						        } 
						    }
						}
					}
					
					// Refresh empty areas
					if(_emptySpaceID != -1) {
						var _currentPoint = bboxPoints[_emptySpaceID];
						__drawImage(_spriteData, _spriteID, _sub, _drawX, _drawY, _drawW, _drawH, _currentPoint, _ratio, _wScale, _hScale);
						
						var _uvX = _currentPoint.left + ((_tiling[0]) ? 2 : 0); 
						var _uvY = _currentPoint.top + ((_tiling[1]) ? 2 : 0);
						var _uvW = _wScale;
						var _uvH = _hScale;
						var _uvs = new __CollageImageUVsClass(_texPage, owner.__texPageCount, _uvX, _uvY, _uvW, _uvH, _drawX, _drawY, _ogW, _ogH, _xOffset, _yOffset);
						_imageInfo.__subImagesArray[_sub] = _uvs;
						// Store next available space
						if( _bbHeight < _currentPoint.bottom){ 
						    var _struct = new __CollageBBoxClass(_currentPoint.left, _currentPoint.top + _bbHeight + _sep + ((_tiling[1]) ? 2 : 0), _currentPoint.right , _currentPoint.bottom - _bbHeight - _sep - ((_tiling[1]) ? 2 : 0));
							array_push(bboxPoints,_struct);
						}
						
						if( _bbWidth < _currentPoint.right) {
							var _struct = new __CollageBBoxClass(_currentPoint.left + _bbWidth + _sep + ((_tiling[0]) ? 2 : 0), _currentPoint.top, _currentPoint.right - _bbWidth - _sep - ((_tiling[0]) ? 2 : 0), _bbHeight + ((_tiling[1]) ? 2 : 0));
							array_push(bboxPoints,_struct);
						} 
						
						// Remove non-empty area
						if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " is currently being processed... " + string(_sub+1) + "/" + string(_subImages));
						if (_sub == _subImages-1) {
							if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " has been processed...");	
						}
						array_delete(bboxPoints, _emptySpaceID, 1);
						
						if (_batchMode) && (_optimize) && (_sub == _subImages-1) {
							// Loop over sub entries
							var _bestEntryWidth = -1;
							var _bestEntryHeight = -1;
							var _bestEntry = undefined;
							var _bestEntryPos = 0;
							var _lenNormSprites = array_length(_normalSprites);
							for(var _iii = _ii+1; _iii < _lenNormSprites; _iii++;) {
								var _n = 0;
								var _tempBBWidth = _normalSprites[_iii].bbWidth;
								var _tempBBHeight = _normalSprites[_iii].bbHeight;
								if (_smallestImageWidth != _tempBBWidth) && (_smallestImageHeight != _tempBBHeight) {
									repeat(array_length(bboxPoints)) {
									     if(_tempBBWidth < bboxPoints[_n].right && _tempBBHeight < bboxPoints[_n].bottom) && 
										 (_tempBBWidth > _bestEntryWidth && _tempBBHeight > _bestEntryHeight) {
									         var _resolve = (bboxPoints[_n].right + bboxPoints[_n].bottom ) / 2;
											 if (_resolve < 0xFFFFFF) {
												 _bestEntryWidth = _tempBBWidth;
												 _bestEntryHeight = _tempBBHeight;
												 _bestEntry = _normalSprites[_iii];
												 _bestEntryPos = _iii;
												 break;
									        } 
									    }
										++_n;
									}
								} else {
									break;	
								}
								
								if (_bestEntry != undefined) break;
							}
								
								if (!is_undefined(_bestEntry)) {
									var _entryA = _normalSprites[_ii+1];
									var _entryB = _bestEntry;
									_normalSprites[_ii+1] = _entryB;
									_normalSprites[_bestEntryPos] = _entryA;
								} else {
									// We can't find anymore that are a smaller size, force optimization flag off for this batch!
									_optimize = false;
									if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "can't optimize images any further this batch!");
								}
							}
					} else {
						// Reset to false in case
						__forceNewTexturePage = false;
						if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "Texture page full! Creating new texture page...");
						// We declare this finished
						_texPage.Finish();
						
						// Unload VRAM
						if (__COLLAGE_BUILDER_VRAM_CLEAR) {
							_texPage.__UnloadVRAM();	
						}
						
						// Save texture page
						if (owner.__texPageCount == 0) || (owner.__texPageArray[owner.__texPageCount-1] != _texPage) {
							owner.__texPageArray[owner.__texPageCount++] = _texPage;
						}
						_texPage = new __CollageTexturePageClass(_texWidth, _texHeight);
						_texPage.Start();
						
						
						// Clear spaces and add new one
						array_delete(bboxPoints,0,array_length(bboxPoints));
						array_push(bboxPoints, new __CollageBBoxClass(_sep, _sep, _texWidth - _sep, _texHeight - _sep));
						--_sub;
					}
				}
					
		}
		
		// Finished
		if (array_length(_normalSprites) > 0) {
			_texPage.Finish();
		}
		
		// Give texture page + safety check
		if (array_length(_normalSprites) > 0) {
			if (owner.__texPageCount != 0) {
				if (owner.__texPageArray[owner.__texPageCount-1] != _texPage) {
					owner.__texPageArray[owner.__texPageCount++] = _texPage;
				}
			} else if (array_length(owner.__texPageArray) > 0) && (owner.__texPageArray[owner.__texPageCount] == _texPage) {
				// Do nothing
			} else {
				owner.__texPageArray[owner.__texPageCount++] = _texPage;	
			}
		}
		#endregion
		
		#region 3D texture pages
		var _spriteArrayLen = array_length(_3DSprites);
		for(var _ii = 0; _ii < _spriteArrayLen; ++_ii) {
			var _spriteStruct = _3DSprites[_ii];
			var _spriteData = _spriteStruct.spriteData;
			var _spriteID = _spriteStruct.spriteID;
			var _spriteInfo = _spriteStruct.spriteInfo;
			var _sprWidth = _spriteStruct.spriteWidth;
			var _sprHeight = _spriteStruct.spriteHeight;
			var _drawX = _spriteStruct.drawX, _drawY = _spriteStruct.drawY, _drawW = _spriteStruct.drawW, _drawH = _spriteStruct.drawH;
			var _xScale = _spriteStruct.xScale;
			var _yScale = _spriteStruct.yScale;
			var _wScale = _spriteStruct.wScale;
			var _hScale = _spriteStruct.hScale;
			var _xOffset = _spriteData.__xOrigin;
			var _yOffset = _spriteData.__yOrigin;
			var _ogW = _spriteStruct.originalWidth;
			var _ogH = _spriteStruct.originalHeight;
			
			
			var _bbWidth = _spriteStruct.bbWidth;
			var _bbHeight = _spriteStruct.bbHeight;
			var _ratio = _spriteStruct.ratio;
			
			var _subStart = 0;
			if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " is currently being processed... 0/" + string(_spriteInfo.num_subimages));
			if (__checkImage(_spriteData.__name)) {
				switch(__COLLAGE_IMAGE_NAME_COLLISION_HANDLE) {
					case 0:
						__CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " already exists! Skipping...");
						--_3DArraySize;
						continue;
					break;
					
					case 1:
						if !(((_spriteInfo.width == __checkImage(_spriteData.__name).width) && (_spriteInfo.height == __checkImage(_spriteData.name).height))
						&& (_spriteInfo.bbox_right-_spriteInfo.bbox_left+1 == __checkImage(_spriteData.__name).cropWidth) && (_spriteInfo.bbox_bottom-_spriteInfo.bbox_top+1 == __checkImage(_spriteData.__name).cropHeight)) {
							var _spriteName = _spriteData.__name;
							var _num = 1;
							var _name = _spriteName + string(_num);
							while(__checkImage(_spriteData.__name)) {
									var _name = _spriteName + string(++_num);
							}
							__CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " already exists! Reidentified as " + _name);
							_spriteData.__name = _name;
							
							var _imageInfo = new __CollageImageClass(_spriteStruct, _spriteData.__name, _drawW, _drawH, _spriteData.__tiling, _ratio, _xOffset, _yOffset, _hashes);
							// Lets add it to database
							__setImage(_spriteData.__name, _imageInfo);
							
							var _subImages = _spriteInfo.num_subimages;
						} else {
							// Same width/height
							// Loop
							var _subImageLen = _spriteInfo.num_subimages;
							var _imageInfo = CollageImageGetInfo(_spriteData.__name);
							var _uvsArray = _imageInfo.__subImagesArray;
							var _uvsArrayLength = array_length(_uvsArray);
							var _uvi = 0;
							var _newTexPage = _texPage;
							_texPage.Start();
							repeat(_subImageLen) {
								if (_uvi >= _uvsArrayLength) break;
								var _uvs = _uvsArray[_uvi++];
								_newTexPage = _uvs.texturePageStruct;
								
								if (_texPage != _newTexPage) {
									_texPage.Finish();
									_texPage = _newTexPage;
									_texPage.Start();	
								}
								gpu_set_blendenable(true);
								gpu_set_blendmode(bm_subtract);
								draw_rectangle_color(_uvs.left, _uvs.top, _uvs.left+_uvs.right,_uvs.top+ _uvs.bottom, c_black, c_black, c_black, c_black, false);
								gpu_set_blendmode(bm_normal);
								gpu_set_blendenable(false);
								__drawImage(_spriteData, _spriteID, _uvi-1, _drawX, _drawY, _drawW, _drawH, _uvs, _ratio, _wScale, _hScale);
							}
							_texPage.Finish();
							gpu_set_blendenable(false);
							var _subImages = _subImageLen;
							var _subStart = (_subImageLen > _uvsArrayLength) ? (_subImageLen - _uvsArrayLength) : _subImageLen;
							_imageInfo.subImagesCount = _subImageLen;
							__CollageTrace(_spriteData.__name + " overwritten! (" + string(_subImageLen) + "/" + string(_uvsArrayLength) + ") Left over: " + string(max(_subImageLen - _uvsArrayLength, 0)));
						}
					break;
					
					case 2:
						var _spriteName = _spriteData.__name;
						var _num = 1;
						var _name = _spriteName + string(_num);
						while(__checkImage(_name)) {
							_name = _spriteName + string(++_num);
						}
						__CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " already exists! Reidentified as " + _name);
						_spriteData.name = _name;
						
						var _imageInfo = new __CollageImageClass(_spriteStruct, _spriteData.__name, _drawW, _drawH, _spriteData.__tiling, _ratio, _xOffset, _yOffset, _hashes);
						// Lets add it to database
						__setImage(_spriteData.__name, _imageInfo);
						var _subImages = _spriteInfo.num_subimages;
					break;
				}
			} else {
				var _imageInfo = new __CollageImageClass(_spriteStruct, _spriteData.__name, _drawW, _drawH, _spriteData.__tiling, _ratio, _xOffset, _yOffset, _hashes);
				// Lets add it to database
				__setImage(_spriteData.__name, _imageInfo);
				
				var _subImages = _spriteInfo.num_subimages;
				owner.__imageCount++;
				array_push(owner.__imageList, _imageInfo);
				array_push(owner.__recent, _imageInfo);
				if (__COLLAGE_IMAGES_ARE_PUBLIC) owner.__imageMap[$ _spriteData.__name] = _imageInfo;
			}
			
			// Find all conflicts
				if (__COLLAGE_USE_HASHES && owner.GetHashing()) {
					var _conflictCount = 0;
					var _j = 0;
					repeat(owner.__imageCount) {
						if (_spriteData.__name != owner.__imageList[_j].__name) && (__HashCompare(_hashes, owner.__imageList[_j].__hashes)) {
							// Find all conflicts
							var _hashesLength = array_length(_hashes);
							for(var _ci = 0; _ci < _hashesLength; ++_ci) {
								if (_hashes[_ci] == owner.__imageList[_j].__hashes[_ci]) {
									_imageInfo.__subImagesArray[_ci] = variable_clone(owner.__imageList[_j].GetUVs(_ci), 0);
									++_conflictCount;
								}
							}
							break;
						}
						++_j;
					}
					
					if (__COLLAGE_VERBOSE) && (_conflictCount > 0) {
						__CollageTrace($"{_collageName}Found {_conflictCount} image frame conflicts from \"{_spriteData.__name}\"! Given copy from \"{owner.__imageList[_j].__name}\"!");
					}
				}
			
			for(var _sub = _subStart; _sub < _subImages; ++_sub) {
				// Skip over since UVs already exist!
				if (_imageInfo.__subImagesArray[_sub] != undefined) continue;
				
				_texPage = new __CollageTexturePageClass(_drawW, _drawH);
				_texPage.Start();
				__drawImage(_spriteData, _spriteID, _sub, _drawX, _drawY, _drawW, _drawH, undefined, _ratio, _wScale, _hScale);
				
				var _tiling = __CollageExtractTiling(_spriteData.__tiling);
				var _uvX = ((_tiling[0]) ? 2 : 0); 
				var _uvY = ((_tiling[1]) ? 2 : 0);
				var _uvW = _wScale;
				var _uvH = _hScale;
				var _uvs = new __CollageImageUVsClass(_texPage, owner.__texPageCount, _uvX, _uvY, _uvW, _uvH, _drawX, _drawY, _ogW, _ogH,/*_sprWidth - _drawW - 2, _sprHeight - _drawH - 2,*/ _xOffset, _yOffset);
				_imageInfo.__subImagesArray[_sub] = _uvs;
				// We declare this finished
				_texPage.Finish();
				
				// Unload VRAM
				if (__COLLAGE_BUILDER_VRAM_CLEAR) {
					_texPage.__UnloadVRAM();	
				}
				
				// Save texture page
				if (owner.__texPageCount == 0) || (owner.__texPageArray[owner.__texPageCount-1] != _texPage) {
					owner.__texPageArray[owner.__texPageCount++] = _texPage;
				}
				
				if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " is currently being processed... " + string(_sub+1) + "/" + string(_subImages));
				if (_sub == _subImages-1) {
					if (__COLLAGE_VERBOSE) __CollageTrace(_collageName + "\"" + _spriteData.__name + "\"" + " has been processed...");	
				}
			} 
		}	
		#endregion
        
		
		#region Final prep
		// Give texture page + safety check
		if (array_length(_3DSprites) > 0) {
			if (owner.__texPageCount != 0) {
				if (owner.__texPageArray[owner.__texPageCount-1] != _texPage) {
					owner.__texPageArray[owner.__texPageCount++] = _texPage;
				}
			} else if (!(array_length(owner.__texPageArray) > 0) && (owner.__texPageArray[owner.__texPageCount] == _texPage)) {
				owner.__texPageArray[owner.__texPageCount++] = _texPage;	
			}
		}
		
		
		// Remove Sprites
		var _len = array_length(_normalSprites);
		var _i = 0;
		repeat(_len) {
			if (_normalSprites[_i].spriteData.__isCopy) {
				sprite_delete(_normalSprites[_i].spriteID);
			}
			++_i;
		}
		
		var _len = array_length(_3DSprites);
		var _i = 0;
		repeat(_len) {
			if (_3DSprites[_i].spriteData.__isCopy) {
				sprite_delete(_3DSprites[_i].spriteID);
			}
			++_i;
		}
		array_resize(owner.__batchImageList, 0);
		CollageRestoreGPUState();
		
		// Hashing cleanup
		if (__COLLAGE_USE_HASHES && owner.GetHashing()) {
			surface_free(__hashData.surf);
			buffer_resize(__hashData.buff, 1);
		}
		#endregion
		
		var _rejectedImgStr = (_rejectedImages > 0) ? (" Rejected " +string(_rejectedImages) + "!") : "";
		__CollageTrace(_collageName + "Building finished! Packed " + string(_normalArraySize) + " images and " + string(_3DArraySize) + " images with separate texture pages." + _rejectedImgStr);
		var _finalTime = (get_timer()-_startTime)/1000;
		__CollageTrace(_collageName + "Total time: " + string(_finalTime) + "ms!");
	}
}