//
//  convertSigmoid.swift
//  BasicCoreML
//
//  Created by Nik Pocuca on 2017-09-05.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation



func convertSigmoid(sigInput: Double) -> String? {

    
    print("sigInput", sigInput)
    
    if(sigInput <= 0.50 ){
       let clockLabel = "Normal"
        return clockLabel
    }
    
    if(sigInput > 0.50){
       let clockLabel = "Abnormal"
        return clockLabel
    }
    
    return "Error, not a Sigmoid Output"
}

