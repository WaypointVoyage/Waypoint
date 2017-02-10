void main() {
    if (texture2D(u_texture, v_tex_coord).a == 0.0) {
        discard;
    }
    vec3 theColor = v_tex_coord.x < stat_val ? vec3(1.0, 1.0, 1.0) : vec3(0.0, 0.0, 0.0);
    gl_FragColor = vec4(theColor, 1.0);
}
