/// feather ignore all
function CollageTextureFlush() {
	static __tpList = __CollageSystem().__CollageTPLoadedList;
	repeat(ds_list_size(__tpList)) {
		__tpList[| 0].__UnloadVRAM();
	}
}