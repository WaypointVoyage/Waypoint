void main() {
    vec4 image = texture2D(u_texture, v_tex_coord);
    float alpha = image.a;
    if (alpha <= 0.1) {
        discard;
    }
    if (image.r <= 0.1 && image.g <= 0.1 && image.b <= 0.1) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        vec4 theColor = v_tex_coord.x < stat_val ? vec4(1.0, 0.0, 0.0, 1.0) : vec4(0.0, 0.0, 0.0, 0.0);
        gl_FragColor = theColor;
    }
}
