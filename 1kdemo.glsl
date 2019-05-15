void main()
{
  float time = gl_TexCoord[0].s * 0.001;
  gl_FragColor = vec4(0.5 + 0.5 * sin(time));
}
