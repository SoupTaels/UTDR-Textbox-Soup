function __CollageStaticGroupBuilderClass(_collageInstance, _prefetch, _removeSelf) constructor {
	__instance = _collageInstance;
	__prefetch = _prefetch;
	__removeSelf = _removeSelf;
	
	__texturePages = __instance.TexturePagesToArray();
	__texturePagesCount = array_length(__texturePages);
	__pos = 0;
	__paths = [];
	__destroyed = false;
	
	static GetName = function() {
		if (__destroyed) return;
		return __instance.GetName();
	}
	
	static NextPage = function() {
		if (__destroyed) return;
		if (__pos >= __texturePagesCount) return undefined;
		return __texturePages[@ __pos++];
	}
	
	static GetTextures = function() {
		return __texturePages;
	}
	
	static GetTextureCount = function() {
		return __texturePagesCount;
	}
	
	static AddPath = function(_value) {
		if (__destroyed) return;
		array_push(__paths, _value);
		return self;
	}
	
	static Cancel = function() {
		if (__destroyed) return;
		__destroyed = true;
		__paths = undefined;
		__texturePages = undefined;
		__instance = undefined;
	}
	
	static Finalize  = function() {
		var _element = new __CollageStaticGroupClass(__instance, __paths, __texturePagesCount, __prefetch, __removeSelf);
		// Funny that we call this here, but since this is worthless now, we can just nudge this over to the new constructor instance
		Cancel(); 
		return _element;
	}
}