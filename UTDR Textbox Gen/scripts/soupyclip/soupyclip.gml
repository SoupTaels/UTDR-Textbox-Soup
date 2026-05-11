///@desc Initializes a clip masking shader
function soupyclipm_init()
{
clip_mask = -1;
clip_shader = shd_clip_mask;
}

///@desc Cleans up clip mask surface
function soupyclipm_cleanup()
{
if ( surface_exists(clip_mask) ) { surface_free(clip_mask); }
}

///@desc Begins drawing the clip mask surface. Can use a sprite or background to act as a mask region. Can have multiple regions
function soupyclipm_begin_clip()
{
///Draw Clip Mask
if ( !surface_exists(clip_mask) ) { clip_mask = surface_create(640, 480); }
surface_set_target(clip_mask);
draw_clear_alpha(c_black, 0);
}

///@desc Ends drawing the clip mask surface.
function soupyclipm_end_clip()
{
surface_reset_target();

shader_set(clip_shader);
}

//@desc Begins setting the clip mask shader. Anything called after this will have their sprite not shown when outside of this mask region.
function soupyclipm_draw()
{
var u_mask = shader_get_sampler_index(clip_shader, "u_mask");
texture_set_stage(u_mask, surface_get_texture(clip_mask));
var u_rect = shader_get_uniform(clip_shader, "u_rect");
shader_set_uniform_f(u_rect, 0, 0, room_width, room_height);
}