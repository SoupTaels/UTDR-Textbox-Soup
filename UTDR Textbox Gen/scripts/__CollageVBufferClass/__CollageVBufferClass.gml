/// @ignore
/// feather ignore all
function __CollageVBufferClass(_tex, _vb = undefined) constructor{
	static __vFormat = __CollageVFormat();
	__texturePage = _tex;
	__textureID = _tex.__textureID;
	__vbuffer = _vb ?? vertex_create_buffer();
	__frozen = false;
	__locked = false;
	__isBatching = false;
	
	static Begin = function(_vFormat) {
		if (__isBatching) __CollageThrow(".Begin() was already called!");
		__isBatching = true;
		vertex_begin(__vbuffer, _vFormat ?? __vFormat);
	}
	
	static End = function() {
		if (!__isBatching) __CollageThrow(".Begin() wasn't called!");
		__isBatching = false;
		vertex_end(__vbuffer);
	}
	
	static Lock = function() {
		__locked = true;	
	}
	
	static Unlock = function() {
		__locked = false;	
	}
	
	static Destroy = function() {
		vertex_delete_buffer(__vbuffer);	
		__vbuffer = -1;
		__frozen = false;
		__locked = false;
		__isBatching = false;
	}
}