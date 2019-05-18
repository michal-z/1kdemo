vec4 qmul(vec4 a, vec4 b)
{
    vec4 r;
    r.w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
    r.x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y;
    r.y = a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x;
    r.z = a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w;
    return r;
}

#define E 0.001
vec3 computeNormal(vec3 p, vec4 q0)
{
    vec4 qp = vec4(p.y, p.z, 0.0, p.x);

    vec4 gx0 = qp + vec4(0, 0, 0, -E);
    vec4 gx1 = qp + vec4(0, 0, 0, E);
    vec4 gy0 = qp + vec4(-E, 0, 0, 0);
    vec4 gy1 = qp + vec4(E, 0, 0, 0);
    vec4 gz0 = qp + vec4(0, -E, 0, 0);
    vec4 gz1 = qp + vec4(0, E, 0, 0);

    for (int i = 0; i < 10; ++i) {
        gx0 = qmul(gx0, gx0) + q0;
        gx1 = qmul(gx1, gx1) + q0;
        gy0 = qmul(gy0, gy0) + q0;
        gy1 = qmul(gy1, gy1) + q0;
        gz0 = qmul(gz0, gz0) + q0;
        gz1 = qmul(gz1, gz1) + q0;
    }

    vec3 n;
    n.x = length(gx1) - length(gx0);
    n.y = length(gy1) - length(gy0);
    n.z = length(gz1) - length(gz0);
    return normalize(n);
}

float computeDistance(vec3 p, vec4 q0)
{
    vec4 q = vec4(p.y, p.z, 0, p.x);
    vec4 qp = vec4(0, 0, 0, 1.0);
    float m2;

    for (int i = 0; i < 10; ++i) {
        qp = 2.0 * qmul(q, qp);
        q = qmul(q, q) + q0;
        m2 = dot(q, q);
        if (m2 > 10.0) break;
    }

    float m = sqrt(m2);
    return 0.5 * m * log(m) / length(qp);
}

void main()
{
    float t = gl_TexCoord[0].x * 0.001;
    vec2 st = -1.0 + 2.0 * (gl_FragCoord.xy / vec2(1920, 1080));
    st.x *= 1.777;
    vec3 ro = vec3(0, 0, 2.1);
    vec3 rd = normalize(vec3(st.x, st.y, -1.5));
    vec4 q0 = vec4(0.75 * sin(t * 0.1), 0.5 * sin(t * 0.2), 0.2, -0.2);

    vec3 p;
    float totdist = 1.0;
    vec3 color = vec3(0);

    for (int i = 0; i < 100; ++i) {
        p = ro + rd * totdist;
        float d = computeDistance(p, q0);
        if (d <= 0.0001) break;
        totdist += d;
        if (totdist >= 10.0) break;
    }

    if (totdist < 10.0) {
        vec3 n = computeNormal(p, q0);
        vec3 l = normalize(vec3(10.0) - p);
        float nDotL = max(dot(n, l), 0);
        color = nDotL * vec3(0.25, 0.45, 1.0) + 0.3 * n;
    }
    gl_FragColor = vec4(color, 1.0);
}
