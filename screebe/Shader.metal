//
//  Shader.metal
//  screebe
//
//  Created by Owen on 31.07.19.
//  Copyright © 2019 daven. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    vector_float4 position [[ position ]];
    float4 color;
    float pointSize [[ point_size ]];
};

struct VertexInfos {
    float width;
    float height;
};

struct FragmentInfos {
    float brightness;
};

vertex Vertex main_vertex(
  device VertexInfos &infos [[ buffer(0) ]],
  device Vertex *vertices [[ buffer(1) ]],
  uint vertexId [[ vertex_id ]]
) {
    Vertex out = vertices[vertexId];
    out.position.x = 2 * (out.position.x / infos.width - 0.5);
    out.position.y = -2 * (out.position.y / infos.height - 0.5);
    out.position = vector_float4(out.position.x, out.position.y, 0, 1);
    return out;
}

fragment half4 main_fragment(
  Vertex interpolatedVertex [[ stage_in ]],
  float2 pointCoord [[ point_coord ]],
  constant FragmentInfos &uniforms [[ buffer(0) ]]
) {
    // float dist = length(pointCoord - float2(0.5));
    float4 out_color = interpolatedVertex.color;
    // out_color.a = 1.0 - smoothstep(0.45, 0.5, dist);
    return half4(out_color);
}
