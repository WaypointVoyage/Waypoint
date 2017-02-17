void main() {
    float alpha = texture2D(u_texture, v_tex_coord).a;
    if (alpha <= 0.1) {
        discard;
    }
    vec3 theColor = v_tex_coord.x < stat_val ? vec3(1.0, 1.0, 1.0) : vec3(0.0, 0.0, 0.0);
    gl_FragColor = vec4(theColor, alpha);
}
