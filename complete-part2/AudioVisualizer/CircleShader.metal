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


vertex VertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], const constant float *loudnessUniform [[buffer(1)]], const constant float *lineArray[[buffer(2)]], unsigned int vid [[vertex_id]]){
    //constants for all render passes
    float circleScaler = loudnessUniform[0];
    VertexOut output;
    
    if(vid<1081){ //circle
        vector_float2 currentVertex = vertexArray[vid]; //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
        output.pos = vector_float4(currentVertex.x*circleScaler, currentVertex.y*circleScaler, 0, 1); //populate the output position with the x and y values of our input vertex data
        output.color = vector_float4(1,1,1,1);//set the color
    } else { //frequency lines
        int circleId = vid-1081;
        vector_float2 circleVertex;

        if(circleId%3 == 0){
            //place line vertex off circle
            circleVertex = vertexArray[circleId];
            float lineScale = 1 + lineArray[(vid-1081)/3];
            output.pos = vector_float4(circleVertex.x*circleScaler*lineScale, circleVertex.y*circleScaler*lineScale, 0, 1);
            output.color = vector_float4(0,0,1,1);
        } else {
            //place line vertex on circle
            circleVertex = vertexArray[circleId-1];
            output.pos = vector_float4(circleVertex.x*circleScaler, circleVertex.y*circleScaler, 0, 1);
            output.color = vector_float4(1,0,0,1);
        }
    }
  
    return output;
}

fragment vector_float4 fragmentShader(VertexOut interpolated [[stage_in]]){
    return interpolated.color;
}

