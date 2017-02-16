void main() {
    vec3 theColor = vec3(0.0, 0.95, 0.92);
    
    int size = 20;
    int h = int(v_tex_coord.x * 1080) / size % 2;
    int v = int(v_tex_coord.y * 1080) / size % 2;
    if (v ^ h == 0) {
        theColor = vec3(0.0, 0.75, 0.90);
    }
    gl_FragColor = vec4(theColor, 1.0);
}
