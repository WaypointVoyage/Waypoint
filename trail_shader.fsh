void main() {
    float dash = 30.0;
    float x = mod(v_path_distance, float(2.0 * dash));
    x = x > dash ? 0.0 : 1.0;
    gl_FragColor = vec4(1.0, 0.0, 0.0, x);
}
