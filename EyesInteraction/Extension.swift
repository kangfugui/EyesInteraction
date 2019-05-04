//
//  Extension.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/15.
//  Copyright © 2019 ky. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
}

extension Collection where Element == CGFloat, Index == Int {
    
    var average: CGFloat? {
        guard !isEmpty else {
            return nil
        }
        
        let sum = reduce(CGFloat(0)) { (current, next) -> CGFloat in
            return current + next
        }
        
        return sum / CGFloat(count)
    }
}

extension CGPoint {
    
    func diff(_ compare: CGPoint) -> CGFloat {
        return max(abs(x-compare.x), abs(y-compare.y))
    }
}
