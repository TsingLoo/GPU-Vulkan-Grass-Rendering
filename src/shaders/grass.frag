#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs

layout(location = 0) in vec3 in_normal;
layout(location = 1) in float in_v;
layout(location = 2) in vec3 in_worldPos;

layout(location = 0) out vec4 outColor;


void main() {
    vec3 N = normalize(in_normal);

    vec3 lightDir = normalize(vec3(0.3, 0.8, 0.5));
    
    float diff = max(dot(N, lightDir), 0.0);

    vec3 baseColor = vec3(49, 125, 54) / 255.0;
    vec3 tipColor  = vec3(162, 214, 124) / 255.0;
    vec3 grassColor = mix(baseColor, tipColor, in_v);

    vec3 camPos = inverse(camera.view)[3].xyz;
    vec3 viewDir = normalize(camPos - in_worldPos);
    vec3 halfVector = normalize(lightDir + viewDir);
    float specularStrength = pow(max(dot(N, halfVector), 0.0), 32.0);

    vec3 specularColor = vec3(0.8, 0.9, 0.7);
    vec3 ambient = vec3(0.1, 0.15, 0.1);

    vec3 finalColor = ambient + grassColor * (0.7 + 0.3 * diff);
    finalColor += specularColor * specularStrength;

    outColor = vec4(finalColor, 1.0);
}
