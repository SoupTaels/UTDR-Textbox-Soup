function __CollageHashData() {
	static _data = {
		surf: undefined,
		buff: buffer_create(1, buffer_fixed, 1),
	};
	
	return _data;
}