//
//  AnimationHelper.swift
//  ARSolarSystem
//
//  Created by Riccardo De Santi on 18/08/2018.
//  Copyright © 2018 Riccardo De Santi. All rights reserved.
//

import Foundation
import UIKit

class AnimationHelper {
    static func delay(delay: Double, closure: @escaping () -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    
}
