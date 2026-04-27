// Feel free to edit these
#macro QUILL_VB_ENABLE				1	// Whether Quill uses vbuffers or not
#macro QUILL_VB_FREEZE_FRAMES		2	// How many frames Quill waits to freeze a vbuffer to avoid churn
#macro QUILL_VB_DEBUG				1	// Debugging setting for Quill (turn this to 0 for public release)

// Internal only \/

enum eQuillLabelPlacement {
	Above,
	Leading
}

enum eQuillLabelAlign {
	Start,
	Center
}

enum eQuillLabelOverflow {
	Wrap,
	Ellipsis
}

enum eQuillTextAlign {
	Left,
	Center,
	Right
}

// Text input modes (Quill text inputs / areas).
#macro QUILL_TEXTMODE_TEXT			0
#macro QUILL_TEXTMODE_INT			1
#macro QUILL_TEXTMODE_FLOAT			2
#macro QUILL_TEXTMODE_IDENTIFIER	3
#macro QUILL_TEXTMODE_PATH			4
#macro QUILL_TEXTMODE_CODE			5
#macro QUILL_TEXTMODE_PASSWORD		6

#macro QUILL_SINGLE	0
#macro QUILL_MULTI	1

#macro QUILL global.__QUILL_CORE
