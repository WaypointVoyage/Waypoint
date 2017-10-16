
void main() {
    vec2 actor_dir = vec2(u_actor_dir_x, u_actor_dir_y);
    vec2 tex_pos = 2.0 * (v_tex_coord - 0.5);
    vec2 offset_from_actor = actor_dir - tex_pos;
    float dist_from_actor = sqrt(offset_from_actor.x * offset_from_actor.x + offset_from_actor.y * offset_from_actor.y);
    
    float a = clamp(1.0 - dist_from_actor / sqrt(2.0), 0.0, 1.0);
    float r = 0.3;
    float g = 0.8;
    float b = 1.0;
    
    gl_FragColor = vec4(a * r, a * g, a * b, a);
}
