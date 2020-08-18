void main() {
    float time = gl_TexCoord[0].s * 0.001;
    vec3 c;
    vec2 p = gl_FragCoord.xy / vec2(1280, 720);

    for (int i = 0; i < 3; ++i) {
        vec2 st = p;
        p -= 0.5;
        p.x *= 1.777;
        time += 0.07;
        st += normalize(p) * sin(time);
        c[i] = 0.02 / length(abs(frac(st) - 0.5));
    }

    gl_FragColor = vec4(c, 1.0);
}
