//
//  Constants.swift
//  SpaceGame
//
//  Created by Pete Smith on 20/02/2017.
//  Copyright © 2017 Pete Smith. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Layer {
        static let background: CGFloat = 0
        static let planet: CGFloat = 1
        static let spaceman: CGFloat = 2
    }
    
    struct PhysicsCategories {
        static let gravityCategory: UInt32 = 0x1 << 0
    }
}
