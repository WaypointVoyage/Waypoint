void main() {
    float alpha = texture2D(u_texture, v_tex_coord).a;
    if (alpha <= 0.1) {
        discard;
    }
    
    vec4 theColor = v_tex_coord.x < stat_val ? vec4(1.0, 0.0, 0.0, 1.0) : vec4(0.0, 0.0, 0.0, 0.0);
    gl_FragColor = theColor;
}
