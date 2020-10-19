	
vec4 Process(vec4 color) {

	vec2 dtexCoord = vTexCoord.xy;

// get reflection rgb
	vec3 eyedir = normalize( uCameraPos.xyz - pixelpos.xyz );
	vec3 normal = normalize( vWorldNormal.xyz );
	vec3 r = reflect( eyedir.xyz, normal.xyz );   
	float m = 2.0 * sqrt( pow( r.x, 2.0 ) + pow( r.y, 2.0 ) + pow( r.z + 1.0, 2.0 ) );
//	float m = 2.8284271247461903 * sqrt(r.z + 1.0);
	vec2 rtexCoord = r.xy / m + 0.5;
	
	vec4 reflectcolor = clamp( texture(enviromap, rtexCoord.xy) - 0.5, 0.0, 1.0 );
	//reflectcolor *= texture(enviromask, dtexCoord);
	reflectcolor.a = 0.1;


	return  mix(color * getTexel(dtexCoord.xy), reflectcolor * 3.0, 0.3);
}
