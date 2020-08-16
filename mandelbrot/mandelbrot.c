void main()
{
    vec2 c = (2.0 * gl_FragCoord.xy - vec2(1920, 1080)) / 1080, z = 0.0;
    float i = 0.0;
	for (; ++i <= 64.0 && dot(z, z) < 4. ;)
        z = mat2(z, -z.y, z.x) * z + c;
    gl_FragColor = vec4(vec3(i / 64.0), 1.0);
}
