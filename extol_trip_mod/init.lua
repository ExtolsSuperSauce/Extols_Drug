
dofile("mods/extol_trip_mod/lib/shader_utilities.lua")

postfx.append([[
uniform vec4 extol_monochrome;
uniform vec4 extol_edrug_color;
uniform vec4 extol_extras;
uniform vec4 extol_edrug_rand;
uniform vec4 extol_edrug_rand_black;
uniform vec4 extol_edrug_rand2;
]],
"uniform sampler2D tex_fog;",
"data/shaders/post_final.frag"
)

postfx.append([[
if (extol_monochrome[3] > 0.5) {
	// Some crazy RGB to HSV conversion, of which I have zero idea how it works.
	// Credit goes here: https://stackoverflow.com/a/17897228 
	// (Extol: Thx Ryyst!)
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(color.bg, K.wz), vec4(color.gb, K.xy), step(color.b, color.g));
	vec4 q = mix(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);

	// Code changed to filter out other colors. Said to work best on reds, but idk
	bool low_red = hsv.x < extol_monochrome[0]/360.0;
	bool high_red = hsv.x > extol_monochrome[1]/360.0;
	bool is_red =  low_red || high_red;

	if (!is_red) {
		const vec3 weight = vec3(0.8,  0.8, 0.8);
		float greyscale = dot(color.rgb, weight);
		color = vec3(greyscale, greyscale, greyscale);
	}
}
if (tex_coord.x > 1.){
	color = mix( color, vec3(0.1), 0.75 );
}
if (tex_coord.x < 0.){
	color = mix( color, vec3(0.1), 0.75 );
}
if (tex_coord.y > 1.){
	color = mix( color, vec3(0.1), 0.75 );
}
if (tex_coord.y < 0.){
	color = mix( color, vec3(0.1), 0.75 );
}
if (extol_extras[0] > 0.5) {
	color = mix( -color, vec3(1.), extol_extras[2] );
}
if (extol_monochrome[2] > 0.5) {
	color = mix( -color, extol_edrug_color.rgb, extol_edrug_color.a );
}
]],
	"// various debug visualizations================================================================================",
	"data/shaders/post_final.frag"
)

postfx.append(
[[
vec3 drawRect(
	in vec2 uv,
	in vec3 inColor,
	in vec2 center,
	in float width,
	in float height,
	in float thickness,
	in vec3 fillColor, 
	in vec3 strokeColor)
	{
		vec3 color = inColor;
		float halfWidth = width * .5;
		float halfHeight = height * .5;
		float halfThickness = thickness * .5;
		
		vec2 bottomLeft = vec2(center.x - halfWidth, center.y - halfHeight);
		vec2 topRight = vec2(center.x + halfWidth, center.y + halfHeight);

            //STROKE
		vec2 stroke = vec2(0.0);
		stroke += step(bottomLeft-halfThickness, uv) * (1.0 - step(bottomLeft+halfThickness, uv));
		stroke += step(topRight-halfThickness, uv) * (1.0 - step(topRight+halfThickness, uv));
		vec2 strokeLimit = step(bottomLeft-halfThickness, uv) * (1.0 - step(topRight+halfThickness, uv));
		stroke *= strokeLimit.x * strokeLimit.y;

		color = mix (color, strokeColor, min(stroke.x + stroke.y, extol_edrug_color[3]));

            //FILL
		vec2 fill = vec2(0.0);
		fill += step(bottomLeft+halfThickness, uv) * (1.0 - step(topRight-halfThickness, uv));
		vec2 fillLimit = step(bottomLeft+halfThickness, uv) * (1.0 - step(topRight-halfThickness, uv));
		fill *=  fillLimit.x * fillLimit.y;

		color = mix (color, fillColor, min(fill.x + fill.y, extol_edrug_color[3]));

        return color;
	}
	
vec2 fishEye(vec2 coord, float power){
		vec2 extol_coord = coord;
			float aspectRatio = window_size.x / window_size.y;
			float strength = power;
			vec2 intensity = vec2(strength * aspectRatio, strength * aspectRatio);
			vec2 coords = coord;
			coords = (coords - 0.5) * 2.0;        
			vec2 realCoordOffs;
			realCoordOffs.x = (1.0 - coords.y * coords.y) * intensity.y * (coords.x); 
			realCoordOffs.y = (1.0 - coords.x * coords.x) * intensity.x * (coords.y);
		if (extol_extras[1] > 0.5) {
			extol_coord = coord  - realCoordOffs;
		}
		else if (extol_monochrome[2] > 0.5) {
			extol_coord = coord  - realCoordOffs;
		}
		return extol_coord;
	}

    ]],
    "// utilities",
    "data/shaders/post_final.frag"
)


postfx.append(
	[[
		tex_coord = fishEye(tex_coord, extol_edrug_rand2[3]);
		tex_coord_y_inverted = fishEye(tex_coord_y_inverted, extol_edrug_rand2[3]);
		tex_coord_glow = fishEye(tex_coord_glow, extol_edrug_rand2[3]);
	]],
	"	vec2 tex_coord_glow = tex_coord_glow_;",
	"data/shaders/post_final.frag"
)

postfx.replace(
	"tex_skylight, tex_coord_skylight",
	"tex_skylight, fishEye(tex_coord_skylight, extol_edrug_rand2[3])",
	"data/shaders/post_final.frag"
)

postfx.replace(
	"tex_fog, tex_coord_fogofwar",
	"tex_fog, fishEye(tex_coord_fogofwar, extol_edrug_rand2[3])",
	"data/shaders/post_final.frag"
)

postfx.append(
[[
if (extol_monochrome[2] > 0.5) {

	vec2 uv = gl_FragCoord.xy / window_size.xy;
	if (extol_edrug_rand[0] > 0.5) {
		if (extol_edrug_rand_black[0] > 0.5) {
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.05, extol_edrug_rand[3] ), extol_edrug_rand2[1], extol_edrug_rand2[2], 0.01, vec3(0.1), vec3(0.1));
		}
		else{
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.05, extol_edrug_rand[1] ), extol_edrug_rand2[0], extol_edrug_rand2[1], 0.01, vec3(extol_edrug_color.rgb), vec3(extol_edrug_color.rgb));
		}
	}
	if (extol_edrug_rand[1] > 0.5) {
		if (extol_edrug_rand_black[1] > 0.5) {
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.95, extol_edrug_rand[2] ), extol_edrug_rand2[1], extol_edrug_rand2[0], 0.01, vec3(0.1), vec3(0.1));
		}
		else{
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.95, extol_edrug_rand[1] ), extol_edrug_rand2[2], extol_edrug_rand2[1], 0.01, vec3(extol_edrug_color.rgb), vec3(extol_edrug_color.rgb));
		}
	}
	if (extol_edrug_rand[2] > 0.5) {
		if (extol_edrug_rand_black[2] > 0.5) {
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.05, extol_edrug_rand[0] ), extol_edrug_rand2[1], extol_edrug_rand2[0], 0.01, vec3(0.1), vec3(0.1));
		}
		else{
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.05, extol_edrug_rand[2] ), extol_edrug_rand2[0], extol_edrug_rand2[2], 0.01, vec3(extol_edrug_color.rgb), vec3(extol_edrug_color.rgb));
		}
	}
	if (extol_edrug_rand[3] > 0.5) {
		if (extol_edrug_rand_black[3] > 0.5) {
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.95, extol_edrug_rand[1] ), extol_edrug_rand2[2], extol_edrug_rand2[0], 0.01, vec3(0.1), vec3(0.1));
		}
		else{
			gl_FragColor.rgb = drawRect(uv, gl_FragColor.rgb, vec2( 0.95, extol_edrug_rand[0] ), extol_edrug_rand2[0], extol_edrug_rand2[1], 0.01, vec3(extol_edrug_color.rgb), vec3(extol_edrug_color.rgb));
		}
	}
}
]],
"gl_FragColor.a = 1.0;",
"data/shaders/post_final.frag"
)

function OnPlayerSpawned( pid )
	if EntityGetWithName( "extol_edrug" ) == 0 then
		local pos_x, pos_y = EntityGetTransform( pid )
		local ent_id = EntityLoad( "mods/extol_trip_mod/files/effect_trip_forever.xml", pos_x, pos_y )
		EntityAddChild( pid, ent_id )
	end
end
