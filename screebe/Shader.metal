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
    vector_float4 position [[position]];
};

struct VertexInfos {
    float width;
    float height;
};

struct FragmentInfos {
};

vertex Vertex main_vertex(
  device VertexInfos &infos [[buffer(0)]],
  device Vertex *vertices [[buffer(1)]],
  uint vertexId [[vertex_id]],
  uint instanceId [[instance_id]]
) {
    Vertex out = vertices[vertexId];

    out.position.x = 2 * (out.position.x / infos.width - 0.5);
    out.position.y = -2 * (out.position.y / infos.height - 0.5);
    out.position = vector_float4(out.position.x, out.position.y, 0, 1);

    return out;
}

fragment float4 main_fragment(
  Vertex interpolatedVertex [[stage_in]],
  constant FragmentInfos &uniforms [[buffer(0)]]
  // float2 pointCoord [[point_coord]]
) {
    // Make a circle:
    // float dist = length(pointCoord - float2(0.5));
    // float4 out_color = interpolatedVertex.color;
    // out_color.a = 1.0 - smoothstep(0.45, 0.5, dist);
    // return half4(out_color);
    
    // TODO: Set the color for each flows
    return float4(0, 0, 0, 1);
}
