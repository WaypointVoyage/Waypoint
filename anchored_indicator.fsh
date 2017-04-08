void main() {
    vec4 tex_color = texture2D(u_texture, v_tex_coord);
    if (tex_color.a < 0.1) {
        discard;
    }
    
    vec4 theColor = tex_color;
    if (theColor.r > 0.1) { // assumes the image is black/white, so if white
        if (is_anchored == 0.0) {
            discard;
        } else {
            theColor = vec4(0.3, 0.3, 0.3, 1.0);
        }
    }
    
    gl_FragColor = theColor;
}
