//
//  SignalProcessing.swift
//  AudioVisualizer
//
//  Created by Alex Barbulescu on 2019-09-02.
//  Copyright © 2019 alex. All rights reserved.
//

import Cocoa
import Accelerate

class SignalProcessing {
    
    static func rms(data: UnsafeMutablePointer<Float>, frameLength: UInt) -> Float {
        var val : Float = 0
        vDSP_measqv(data, 1, &val, frameLength)

        var db = 10*log10f(val)
        //inverse dB to +ve range where 0(silent) -> 160(loudest)
        db = 160 + db;
        //Only take into account range from 120->160, so FSR = 40
        db = db - 120

        let dividor = Float(40/0.3)
        var adjustedVal = 0.3 + db/dividor

        //cutoff
        if (adjustedVal < 0.3) {
            adjustedVal = 0.3
        } else if (adjustedVal > 0.6) {
            adjustedVal = 0.6
        }
        
        return adjustedVal
    }
    
    static func fft(data: UnsafeMutablePointer<Float>, setup: OpaquePointer) -> [Float]{
        //output setup
        var realIn = [Float](repeating: 0, count: 1024)
        var imagIn = [Float](repeating: 0, count: 1024)
        var realOut = [Float](repeating: 0, count: 1024)
        var imagOut = [Float](repeating: 0, count: 1024)
        
        //fill in real input part with audio samples
        for i in 0...1023 {
            realIn[i] = data[i]
        }
    
        
        vDSP_DFT_Execute(setup, &realIn, &imagIn, &realOut, &imagOut)

        //our results are now inside realOut and imagOut
        
        //package it inside a complex vector representation used in the vDSP framework
        var complex = DSPSplitComplex(realp: &realOut, imagp: &imagOut)
        
        //setup magnitude output
        var magnitudes = [Float](repeating: 0, count: 1024)
        
        //calculate magnitude results
        vDSP_zvabs(&complex, 1, &magnitudes, 1, 1024)
        
        //normalize
        var normalizedMagnitudes = [Float](repeating: 0.0, count: 1024)
        var scalingFactor = Float(200.0/1024)
        vDSP_vsmul(&magnitudes, 1, &scalingFactor, &normalizedMagnitudes, 1, 1024)
        
        return normalizedMagnitudes
    }
    
    static func interpolate(point1: Float, point2: Float, num: Int) -> [Float] {
        var output = [Float](repeating: 0, count: num)

        let middle = (point2 - point1).magnitude/2 + point1
        
        var sides : Int = (num - 1)/2
        self.interpolateHelperL(point1: point1, point2: middle, num: &sides, output: &output)
        
        sides = (num - 1)/2
        output[sides] = middle
        self.interpolateHelperR(point1: middle, point2: point2, num: &sides, output: &output)
        
        return output
    }
    
    private static func interpolateHelperL(point1: Float, point2: Float, num: inout Int, output: inout [Float]){
        if(num == 0){ return }
        
        let middle = (point2 - point1).magnitude/2 + point1
        output[num-1] = middle
        num = num - 1
        
        interpolateHelperL(point1: point1, point2: middle, num: &num, output: &output)
    }
    
    private static func interpolateHelperR(point1: Float, point2: Float, num: inout Int, output: inout [Float]){
        if(num == 0) { return }
        
        let middle = (point2 - point1).magnitude/2 + point1
        output[output.count - num] = middle
        num = num - 1
        
        interpolateHelperR(point1: middle, point2: point2, num: &num, output: &output)
    }
}
