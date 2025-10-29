#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

layout(location = 0) in vec4 in_v0[];
layout(location = 1) in vec4 in_v1[];
layout(location = 2) in vec4 in_v2[];
layout(location = 3) in vec4 in_up[];

layout(location = 0) out vec3 out_normal;
layout(location = 1) out float out_v;
layout(location = 2) out vec3 out_worldPos;

vec3 bezier(vec3 p0, vec3 p1, vec3 p2, float t) {
    vec3 a = mix(p0, p1, t);
    vec3 b = mix(p1, p2, t);
    return mix(a, b, t);
}


void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

    vec3 p0 = in_v0[0].xyz;
    vec3 p1 = in_v1[0].xyz;
    vec3 p2 = in_v2[0].xyz;

    float orientation = in_v0[0].w;
    float height = in_v1[0].w;
    float width = in_v2[0].w;

    vec3 spine_pos = bezier(p0, p1, p2, v);


    vec3 t1 = normalize(vec3(-cos(orientation), 0.0, sin(orientation)));
    
    vec3 t0 = normalize(mix(p1 - p0, p2 - p1, v));
    
    vec3 n = normalize(cross(t0, t1));

    vec3 c0 = spine_pos - width * 0.5 * t1;
    vec3 c1 = spine_pos + width * 0.5 * t1;

    float t = u + 0.5 * v - u * v;


    vec3 pos = mix(c0, c1, t);

    gl_Position = camera.proj * camera.view * vec4(pos, 1.0);

    out_normal = n;
    out_v = v;
    out_worldPos = pos;
}