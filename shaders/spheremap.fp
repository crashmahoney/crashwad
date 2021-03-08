// Sphere Map

// https://www.clicktorelease.com/blog/creating-spherical-environment-mapping-shader/
	
	
vec4 Process(vec4 color) {

	vec2 dtexCoord = vTexCoord.xy;

// get reflection rgb
	vec3 eyedir = normalize( uCameraPos.xyz - pixelpos.xyz );
	vec3 normal = normalize( vWorldNormal.xyz );
	vec3 r = reflect( eyedir.xyz, normal.xyz );   
//	float m = 2.0 * sqrt( pow( r.x, 2.0 ) + pow( r.y, 2.0 ) + pow( r.z + 1.0, 2.0 ) );
	float m = 2.8284271247461903 * sqrt(r.z + 1.0); // similar to the above line
	vec2 rtexCoord = r.xy / m + 0.5;
	
	vec4 reflectcolor = texture(enviromap, rtexCoord.xy);
//	reflectcolor.rgb = clamp(( reflectcolor.rgb - 0.5 ) * 2.0, 0.0, 1.0);
	reflectcolor *= texture(enviromask, dtexCoord);
	reflectcolor.a = 1.0;

	return  mix(color * getTexel(dtexCoord.xy), reflectcolor, 0.3);
	
}