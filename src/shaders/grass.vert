
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

layout(location = 0) in vec4 in_v0;
layout(location = 1) in vec4 in_v1;
layout(location = 2) in vec4 in_v2;
layout(location = 3) in vec4 in_up;

layout(location = 0) out vec4 out_v0;
layout(location = 1) out vec4 out_v1;
layout(location = 2) out vec4 out_v2;
layout(location = 3) out vec4 out_up;

// TODO: Declare vertex shader inputs and outputs

out gl_PerVertex {
    vec4 gl_Position;
};
void main() {
	// TODO: Write gl_Position and any other shader outputs
    float orientation = in_v0.w;
    float height = in_v1.w;
    float width = in_v2.w;
    float stiffness = in_up.w;

    out_v0 = model * vec4(in_v0.xyz, 1.0);
    out_v1 = model * vec4(in_v1.xyz, 1.0);
    out_v2 = model * vec4(in_v2.xyz, 1.0);

    vec4 transformed_up = model * vec4(in_up.xyz, 0.0);
    
    out_v0.w = orientation;
    out_v1.w = height;
    out_v2.w = width;
    out_up = vec4(transformed_up.xyz, stiffness);

    gl_Position = out_v0;
}
