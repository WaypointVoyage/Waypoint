void main() {
    vec3 theColor = vec3(0.0, 0.95, 0.92);
    
    float size = 20.0;
    int h = int(mod(v_tex_coord.x * 1080.0 / size, 2.0));
    int v = int(mod(v_tex_coord.y * 1080.0 / size, 2.0));
    if ((v ^ h) == 0) {
        theColor = vec3(0.0, 0.75, 0.90);
    }
    gl_FragColor = vec4(theColor, 1.0);
}
