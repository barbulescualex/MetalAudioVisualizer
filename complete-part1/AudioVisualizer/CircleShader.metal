//
//  CircleShader.metal
//  AudioVisualizer
//
//  Created by Alex Barbulescu on 2019-04-10.
//  Copyright © 2019 alex. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;


struct VertexOut {
    vector_float4 pos [[position]];
    vector_float4 color;
};


vertex VertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]]){
    vector_float2 currentVertex = vertexArray[vid]; //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
    VertexOut output;
    
    output.pos = vector_float4(currentVertex.x, currentVertex.y, 0, 1); //populate the output position with the x and y values of our input vertex data
    output.color = vector_float4(1,1,1,1);//set the color
    
    return output;
}

fragment vector_float4 fragmentShader(VertexOut interpolated [[stage_in]]){
    return interpolated.color;
}

