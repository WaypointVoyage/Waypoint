
void main() {
    float path_point = v_path_distance / u_path_length;
    
    // piecewise linear
    float a = 0.0;
    if (path_point <= 0.5) {
        a = 2.0 * path_point;
    } else {
        a = -2.0 * (path_point - 1.0);
    }
    
    // Parabola
//    float a = -4.0 * (path_point * path_point - path_point);
    
    // piecewise parabola
//    if (path_point > 0.5) {
//        path_point = path_point - 1;
//    }
//    float a = 4.0 * path_point * path_point;
    
    // https://stackoverflow.com/questions/33620255/how-does-the-default-blending-in-spritekit-work
    float r = 1.0;
    float g = 1.0;
    float b = 1.0;
    gl_FragColor = vec4(a * r, a * g, a * b, a);
}
