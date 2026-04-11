//// feather ignore all
/// @func CollageRenderPipeline()
function CollageRenderPipeline(_vertexFormat = undefined, _funcStart = undefined, _funcEnd = undefined) constructor {
	__vbArray = [];
	__status = CollageRPStatus.EMPTY;
	__vFormat = undefined;
	__funcStart = _funcStart;
	__funcEnd = _funcEnd;
	__vertexFunc = _vertexFormat;
	__vertexFuncEntrySize = undefined;
	
	/// Calculate the size in bytes of a single entry in the buffer using the given vertex buffer function.
	/// @param {Function} vertexFunc
	/// @returns {Real}
	static __calcVFuncEntrySize = function(_vertexFunc) {
		
		static dummy_xy = array_create(4, array_create(2, 0));
		static dummy_colour = array_create(4, 0);
		static dummy_tex = { __textureID: undefined };
		
		var _vb = new __CollageVBufferClass(dummy_tex);
			
		_vb.Begin(__vFormat);
		_vertexFunc(_vb.__vbuffer, dummy_xy, 0, 0, 0, 0, 0, dummy_colour, 0);
		_vb.End();
		
		var _b = buffer_create_from_vertex_buffer(_vb.__vbuffer, buffer_fixed, 1);
		_vb.Destroy();
		
		var _size = buffer_get_size(_b);
		buffer_delete(_b);
		
		return _size;
		
	}
	
	static __freezeVB = function(_i) {
		__vbArray[_i].__frozen = true;
		vertex_freeze(__vbArray[_i].__vbuffer);
	}
	
	static __findVB = function(_texID) {
		/// feather ignore all
		var _i = 0;
		repeat(array_length(__vbArray)) {
			if (__vbArray[_i].__textureID == _texID) && (!__vbArray[_i].__frozen) && (!__vbArray[_i].__locked) {
				return _i;
			}
			++_i;
		}
		return -1;
	}
	
	static SetVFormat = function(_vFormat) {
		if (__vFormat == _vFormat) return self;
		__vFormat = _vFormat;	
		Clear();
		return self;
	}
	
	static SetDrawFuncs = function(_funcStart, _funcEnd) {
		__funcStart = _funcStart;
		__funcEnd = _funcEnd;
		return self;
	}
	
	static SetVFormatFunc = function(_func) {
		__vertexFunc = _func;	
		__vertexFuncEntrySize = __calcVFuncEntrySize(__vertexFunc ?? __CollageVertexAdd);
		return self;
	}
	
	static GetStatus = function() {
		return __status;	
	}
	
	static Start = function() {
		Clear(true);
		var _i = 0;
		__status = CollageRPStatus.BATCHING;
		repeat(array_length(__vbArray)) {
			if (!__vbArray[_i].__locked) __vbArray[_i].Begin(__vFormat);
			++_i;
		}	
		return self;
	}
	
	static StartAppend = function() {
		var _i = 0;
		__status = CollageRPStatus.BATCHING;
		repeat(array_length(__vbArray)) {
			if (!__vbArray[_i].__frozen) && (!__vbArray[_i].__locked) __vbArray[_i].Begin(__vFormat);
			++_i;
		}
		return self;
	}
	
	/// Remove a Collage image from the buffers given its index.
	/// @param {Real} bufferIndex Index of the buffer to remove from.
	/// @param {Real} entryIndex Index of the entry within the buffer to remove from.
	static RemoveImageByIndex = function(_bufferIndex, _entryIndex) {
		
		if (__status == CollageRPStatus.BATCHING) {
			__CollageThrow("Cannot remove an image while batching!");
		}
		
		if (_bufferIndex < 0 || _bufferIndex >= array_length(__vbArray)) {
			__CollageThrow(string("Tried to remove image from buffer index out of bounds {0} (valid bounds are 0 to {1})", _bufferIndex, array_length(__vbArray)));
		}
		
		var vb = __vbArray[_bufferIndex];
		var offset = __vertexFuncEntrySize * _entryIndex;
		
		if (vb.__frozen) {
			__CollageThrow(string("Tried to remove image from frozen buffer at buffer index {0}", _bufferIndex));
		}
		
		if (vertex_get_number(vb.__vbuffer) == 0) {
			__CollageThrow(string("Tried to remove image from empty buffer {0}", _bufferIndex));
		}
		
		var b;
		
		try {
			
			b = buffer_create(__vertexFuncEntrySize, buffer_fixed, 1);
			buffer_fill(b, 0, buffer_u8, 0, __vertexFuncEntrySize);
			
			vertex_update_buffer_from_buffer(vb.__vbuffer, offset, b, 0, __vertexFuncEntrySize);
			
			buffer_delete(b);
			
			return self;
			
		} catch (err) {
			
			// Compatibility for before https://github.com/YoYoGames/GameMaker-Bugs/issues/3163
			
			buffer_delete(b);
			
			b = buffer_create_from_vertex_buffer(vb.__vbuffer, buffer_fixed, 1);
			buffer_fill(b, offset, buffer_u8, 0, __vertexFuncEntrySize);
			
			vertex_delete_buffer(vb.__vbuffer);
			vb.__vbuffer = vertex_create_buffer_from_buffer(b, __vFormat ?? __CollageVFormat());
			
			buffer_delete(b);
			
			return self;
			
		}
		
	}
	
	/// Adds a Collage image to the batch, with the specified propreties.
	static AddImage = function(_imageData, _subImage, _x, _y, _z = 0, _width = 1, _height = 1, _angle = 0, _col = draw_get_color(), _alpha = draw_get_alpha(), _respectOrigin = true) {
		var _tex = _imageData.GetTexturePage(_subImage);
		var _index = __findVB(_tex.__textureID);
		if (_index == -1) {
			var _vb = new __CollageVBufferClass(_tex);
			array_push(__vbArray, _vb);
			_index = array_length(__vbArray)-1;
			_vb.Begin(__vFormat);
		}
		__CollageBuildImage(__vbArray[_index].__vbuffer, _imageData, _subImage, _x, _y, _z, _width, _height, _angle, _col, _alpha, _respectOrigin, __vertexFunc);
		return self;
	}
	
	static Finish = function() {
		var _i = 0;
		if (__status != CollageRPStatus.BATCHING) __CollageThrow(".Start() was not called for this CollageRenderPipeline Instance!");
		repeat(array_length(__vbArray)) {
			if (!__vbArray[_i].__frozen) && (!__vbArray[_i].__locked) __vbArray[_i].End();
			++_i;
		}		
		__status = CollageRPStatus.BATCHED;
		return self;
	}
	
	static Draw = function() {
		var _len = array_length(__vbArray);
		if (_len == 0) exit;
		
		var _i = 0;
		if (__funcStart != undefined) __funcStart();
		repeat(_len) {
			if (!__vbArray[_i].__texturePage.__isLoaded) __vbArray[_i].__texturePage.CheckSurface();
			vertex_submit(__vbArray[_i].__vbuffer, pr_trianglelist, __vbArray[_i].__texturePage.GetTexture());
			++_i;
		}	
		if (__funcEnd != undefined) __funcEnd();
	}
	
	static Lock = function() {
		var _i = 0;
		repeat(array_length(__vbArray)) {
			__vbArray[_i].Lock();	
			++_i;
		}
		return self;
	}
	
	static Unlock = function() {
		var _i = 0;
		repeat(array_length(__vbArray)) {
			__vbArray[_i].Unlock();	
			++_i;
		}
		return self;
	}
	
	static Freeze = function() {
		var _i = 0;
		repeat(array_length(__vbArray)) { 
			if (!__vbArray[_i].__frozen) {
				__freezeVB(_i);
			}
			++_i;
		}	
		return self;
	}
	
	static Clear = function(_frozenOnly = false) {
		var _i = 0;
		if (_frozenOnly) {
			repeat(array_length(__vbArray)) {
				if (__vbArray[_i].__frozen) {
					__vbArray[_i].Destroy();
					__vbArray[_i].__vbuffer = -1;
					array_delete(__vbArray, _i, 1);
					--_i;
				}
				++_i;
			}
		} else {
			repeat(array_length(__vbArray)) {
				__vbArray[_i].Destroy();
				++_i;
			}
			array_resize(__vbArray, 0);
			__status = CollageRPStatus.EMPTY;
		 }
		 return self;
	}
	
	static GetBatchCount = function() {
		return array_length(__vbArray);	
	}
	
	__vertexFuncEntrySize = __calcVFuncEntrySize(__CollageVertexAdd);
}