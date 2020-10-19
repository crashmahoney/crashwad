// Dual Paraboloid Environment Mapping

// http://cdn.imgtec.com/sdk-documentation/Dual+Paraboloid+Environment+Mapping.Whitepaper.pdf

	
vec4 Process(vec4 color) {

	vec2 dtexCoord = vTexCoord.xy;

// get reflection rgb
	vec3 eyedir = normalize( uCameraPos.xyz - pixelpos.xyz );
	vec3 normal = normalize( vWorldNormal.xyz );
	vec3 r = reflect( eyedir.xyz, normal.xyz );   
	
	r.xy /= abs(r.z) + 1.0;
	r.xy = r.xy * 0.5 + 0.5;
	r.x *= 0.5;
	r.x += sign(r.z) * 0.25 + 0.25;

	vec4 reflectcolor = clamp( texture(enviromap, r.xy), 0.0, 1.0 );
	reflectcolor *= texture(enviromask, dtexCoord);
	reflectcolor.a = 0.1;

	return  mix(color * getTexel(dtexCoord.xy), reflectcolor * 3.0, 0.3);
}
