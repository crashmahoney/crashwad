

vec4 Process(vec4 color) {
	const float pi = 3.14159265358979323846;
	const float xyAdjust = 0.001;
	const float zAdjust  = 0.00175;

	vec2 texCoord = gl_TexCoord[0].xy;
	vec2 distortion = vec2(0, 0);

	distortion.x = sin(pi * 2.0 * (texCoord.x + (uCameraPos.x * xyAdjust) + (uCameraPos.z * zAdjust) * 0.125)) * 0.05;
	distortion.y = sin(pi * 2.0 * (texCoord.y + (uCameraPos.y * xyAdjust) + (uCameraPos.z * zAdjust) * 0.125)) * 0.05;


	vec3 eyedir = normalize(uCameraPos.xyz-pixelpos.xyz);
//	vec3 eyedir = normalize(pixelpos.xyz-uCameraPos.xyz);
	vec3 reflected = reflect(eyedir.xyz,normalize(vWorldNormal.xyz));   
//	float m = 2.8284271247461903 * sqrt(reflected.z + 1.0);

//	texCoord = reflected.xy / m + 0.5;
	texCoord =+ reflected.xy + distortion;


	return 0.6 * getTexel(texCoord) * color;
}
