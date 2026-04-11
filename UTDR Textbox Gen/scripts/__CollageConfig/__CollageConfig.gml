/// @ignore
// Whether Collage should respect Power of Two sizes. (Will readjust the texture page if it's not power of two)
#macro __COLLAGE_ENSURE_POWER_TWO true

// Whether Collage should clamp to the min/max texture page size.
#macro __COLLAGE_CLAMP_TEXTURE_SIZE true

// The absolute minimum size that Collage will allow a texture page to be. Surfaces can work as low as 1. 
// (I wouldn't recommend setting it to anything lower than 256.)
#macro __COLLAGE_MIN_TEXTURE_SIZE 256

// The absolute maximum size that Collage will allow a texture page to be. On Windows, the absolute max is 16384.
// Other platforms/devices may vary.
#macro __COLLAGE_MAX_TEXTURE_SIZE 8192 

// The default texture page size
#macro __COLLAGE_DEFAULT_TEXTURE_SIZE 2048

// Whether Collage should scale images that are bigger than the texture page itself.
#macro __COLLAGE_SCALE_TO_TEXTURES_ON_PAGE true

// Whether Collage should bake coloured boxes around all of the images or not.
// This is mostly used to determine that images are correctly fitting on the texture page, and otherwise serve no real purpose.
#macro __COLLAGE_RENDER_DEBUG_LINES false

// Whether Collage should autocrop any texture pages that weren't given a crop value.
/*
    0: No cropping
    1: Crop all sides
    2: Crop horizontally
	3: Crop vertically
*/
#macro __COLLAGE_DEFAULT_CROP 1

// Levels of optimization in which Collage will pack texture pages more efficiently (during batch mode)
/*
	0: No extra optimization.
	1: Finding the next image that fits (big or small)
	2: Rotating images (not in yet)
*/
#macro __COLLAGE_DEFAULT_OPTIMIZE 1

// Separation value that Collage will respect across the board if no sep value was passed.
#macro __COLLAGE_DEFAULT_SEPARATION 0

// How Collage should handle image name collisions
/*
    0: Reject all duplicate image names.
    1: Allow replacing of existing images if they meet certain criteria (non-crop: width & height. crop : width & height & general minimal box area) or otherwise add as new image.
    2: Add as new image.
*/
#macro __COLLAGE_IMAGE_NAME_COLLISION_HANDLE 0

// Whether Collage should make all images added available through the global image database or not.
// The upside to this is that you can use string-based values in certain functions that allow it to fetch from a global database.
// The downside is that you can't have the same names across multiple Collages.
// Setting this to false will allow all image names to be used privately, but not accessible via the global image database.
#macro __COLLAGE_IMAGES_ARE_PUBLIC true

// Whether Collage should respect the origin of the image or not when drawing it stretched.
// By default this is false to match GameMaker's behaviour.
#macro __COLLAGE_STRETCHED_RESPECT_ORIGIN false

// Whether Collage should respect the origin of the image or not when drawing part.
// By default this is false to match GameMaker's behaviour.
#macro __COLLAGE_PART_RESPECT_ORIGIN false

// Whether Collage should clear the VRAM before making another texture page (as in The texture page gets full, surface is freed but contents is saved)
// This is mostly to keep the VRAM usage low during building while having multiple sprites packed into VRAM at once.
#macro __COLLAGE_BUILDER_VRAM_CLEAR false

// Enables verbose console output to aid with debugging.
#macro __COLLAGE_VERBOSE false

// Whether Collage should utilize hashing in order to determine if two images are the same.
#macro __COLLAGE_USE_HASHES false

// The default state of a Collage instance with hashing, if hashes are on
#macro __COLAGE_DEFAULT_HASH_STATE true

// Whether Collage should track instances of __CollageStaticGroupClass to ensure that their data is cleared up properly.
// Beneficial for when you don't need the struct, but would like Collage to still handle cleanup.
#macro __COLLAGE_WEAKREF_TEXTUREGROUPS true

// How long between seconds before Collage should loop through texture groups again
#macro __COLLAGE_WEAKREF_TEXTUREGROUPS_NEXT_ITERATION 5