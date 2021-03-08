// Dual Paraboloid Environment Mapping

// http://cdn.imgtec.com/sdk-documentation/Dual+Paraboloid+Environment+Mapping.Whitepaper.pdf

vec4 SimSun();

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

	vec4 reflectcolor = texture(enviromap, r.xy);
	reflectcolor *= texture(enviromask, dtexCoord); 						// reduce reflection amount with mask texture

	vec4 sun = clamp( SimSun() + texture(sunmask, dtexCoord), 0.0, 1.0 );	// call simsun to darken shadows, but use mask to brighten back up where needed
	
	vec4 diffuse = sun * color * getTexel(dtexCoord);
	
	diffuse.rgb = clamp( diffuse.rgb + reflectcolor.rgb, 0.0, 1.0 );
	
	return diffuse;
}










//SimSun Shader by Cherno

const float pi = 3.14159265359;
vec4 SimSun()
{
	vec3 lightDir = vec3(0.75,-1.0,-0.5);
	//Doom map axis: x,z,y
	//with 1.0-1.0,-1.0, the light comes from the north-west-west diagonally downwards, if north is towards the top of the (auto or editor)map

	vec2 texCoord = gl_TexCoord[0].st;
	vec3 l = lightDir;
	vec3 n = normalize(vWorldNormal.xyz);
	float angle = acos
	(
		(l.x*n.x + l.y*n.y + l.z * n.z) 
		/ 
		(
			(	
				sqrt
				(
					(l.x*l.x)+(l.y*l.y)+(l.z*l.z)
				) 
				* 
				sqrt
				(
					(n.x*n.x) + (n.y*n.y) + (n.z*n.z)
				)
			)
		)
	);
	float lightLevel = angle;
	lightLevel /= pi;
	//from here on out, you have a lightLevel between 0.0 and 1.0, depending on the angle of the surface relative to lightDir.
	//a lightLevel of 0.5 results in the pixel at it would appear with no shading from SimSun at all.
	//you can add calculations to the lightvalue if you wish to increase, decrease, or shoft the effect.
	lightLevel += 0.25;//shifts the lightLevel so it gets slightly lighter, so there are less extremely dark areas
	return vec4(lightLevel,lightLevel,lightLevel,1.0);
}


