// When drawing CleanConvex() with sharp, unrounded corners you may find that you get small
// visual artefacts in the corners. This can be eliminated by adding very slight rounding via the
// `.Rounding()` method. If this is unsuitable for your game, you can set this macro to `true`
// to use a slower legacy antialiasing method that solves the problem.
#macro CLEAN_LEGACY_ANTIALIAS  false

#macro CLEAN_DEFAULT_ANTIALIAS                       false

#macro CLEAN_DEFAULT_LINE_COLOUR                     draw_get_colour()
#macro CLEAN_DEFAULT_LINE_ALPHA                      draw_get_alpha()
#macro CLEAN_DEFAULT_LINE_START_CAP                  "round"
#macro CLEAN_DEFAULT_LINE_END_CAP                    "round"
#macro CLEAN_DEFAULT_LINE_THICKNESS                  2

#macro CLEAN_DEFAULT_RECTANGLE_COLOUR                draw_get_colour()
#macro CLEAN_DEFAULT_RECTANGLE_ALPHA                 draw_get_alpha()
#macro CLEAN_DEFAULT_RECTANGLE_BORDER_THICKNESS      0
#macro CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR         c_white
#macro CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA          draw_get_alpha()
#macro CLEAN_DEFAULT_RECTANGLE_ROUNDING              0

#macro CLEAN_DEFAULT_CIRCLE_INNER_COLOUR             draw_get_colour()
#macro CLEAN_DEFAULT_CIRCLE_INNER_ALPHA              draw_get_alpha()
#macro CLEAN_DEFAULT_CIRCLE_OUTER_COLOUR             draw_get_colour()
#macro CLEAN_DEFAULT_CIRCLE_OUTER_ALPHA              draw_get_alpha()
#macro CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS         0
#macro CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR            c_white
#macro CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA             draw_get_alpha()

#macro CLEAN_DEFAULT_TRIANGLE_COLOUR                 draw_get_colour()
#macro CLEAN_DEFAULT_TRIANGLE_ALPHA                  draw_get_alpha()
#macro CLEAN_DEFAULT_TRIANGLE_BORDER_THICKNESS       0
#macro CLEAN_DEFAULT_TRIANGLE_BORDER_COLOUR          c_white
#macro CLEAN_DEFAULT_TRIANGLE_BORDER_ALPHA           draw_get_alpha()
#macro CLEAN_DEFAULT_TRIANGLE_ROUNDING               0
#macro CLEAN_TRIANGLE_FIX_COUNTERCLOCKWISE_POINTS    false
#macro CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS  true

#macro CLEAN_DEFAULT_POLYLINE_COLOUR                 draw_get_colour()
#macro CLEAN_DEFAULT_POLYLINE_ALPHA                  draw_get_alpha()
#macro CLEAN_DEFAULT_POLYLINE_JOIN                   "round"
#macro CLEAN_DEFAULT_POLYLINE_START_CAP              "round"
#macro CLEAN_DEFAULT_POLYLINE_END_CAP                "round"
#macro CLEAN_DEFAULT_POLYLINE_THICKNESS              2

#macro CLEAN_DEFAULT_SPLINE_COLOUR                   draw_get_colour()
#macro CLEAN_DEFAULT_SPLINE_ALPHA                    draw_get_alpha()
#macro CLEAN_DEFAULT_SPLINE_JOIN                     "round"
#macro CLEAN_DEFAULT_SPLINE_START_CAP                "round"
#macro CLEAN_DEFAULT_SPLINE_END_CAP                  "round"
#macro CLEAN_DEFAULT_SPLINE_THICKNESS                2

#macro CLEAN_DEFAULT_CONVEX_COLOUR                   draw_get_colour()
#macro CLEAN_DEFAULT_CONVEX_ALPHA                    draw_get_alpha()
#macro CLEAN_DEFAULT_CONVEX_BORDER_THICKNESS         0
#macro CLEAN_DEFAULT_CONVEX_BORDER_COLOUR            c_white
#macro CLEAN_DEFAULT_CONVEX_BORDER_ALPHA             draw_get_alpha()
#macro CLEAN_DEFAULT_CONVEX_ROUNDING                 0
#macro CLEAN_CONVEX_FIX_COUNTERCLOCKWISE_POINTS      false
#macro CLEAN_CONVEX_ERROR_COUNTERCLOCKWISE_POINTS    true

#macro CLEAN_DEFAULT_NGON_COLOUR                     draw_get_colour()
#macro CLEAN_DEFAULT_NGON_ALPHA                      draw_get_alpha()
#macro CLEAN_DEFAULT_NGON_BORDER_THICKNESS           0
#macro CLEAN_DEFAULT_NGON_BORDER_COLOUR              c_white
#macro CLEAN_DEFAULT_NGON_BORDER_ALPHA               draw_get_alpha()
#macro CLEAN_DEFAULT_NGON_ROUNDING                   0
#macro CLEAN_DEFAULT_NGON_STAR_FACTOR                0