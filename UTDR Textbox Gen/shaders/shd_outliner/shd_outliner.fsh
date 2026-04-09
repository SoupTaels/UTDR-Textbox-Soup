//
// Simple passthrough fragment shader
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 outtext; //Outline Pixel Texture
uniform float outthick; //Outline Thickness
uniform vec4 outcol; //Outline Color
uniform bool outthicker; //Outline Thiccness (whether the outline should spread out to include 8 directions or 4)

void main() {
	vec2 thickness = outtext * outthick;
	vec4 end_pixel =  v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );

	if ( texture2D( gm_BaseTexture, v_vTexcoord ).a <= 0.0 ) { 
		float alpha = 0.0;
		alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x - thickness.x , v_vTexcoord.y)).a ); //Left
		alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x + thickness.x , v_vTexcoord.y)).a ); //Right
		alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y + thickness.y)).a ); //Down
		alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y - thickness.y)).a ); //Up
		
		if ( outthicker ) {
			alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x - thickness.x , v_vTexcoord.y - thickness.y )).a ); //Up-Left
			alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x + thickness.x , v_vTexcoord.y - thickness.y )).a ); //Up-Right
			alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x - thickness.x , v_vTexcoord.y + thickness.y )).a ); //Down-Left
			alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x + thickness.x , v_vTexcoord.y + thickness.y )).a ); //Down-Right
		}

		if ( alpha != 0.0 ) { end_pixel = vec4(outcol); }
	}

	gl_FragColor = end_pixel;
}