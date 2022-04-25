//
//  Array+Moe.swift
//  MoeAlert_Example
//
//  Created by Zed on 2022/4/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

public extension Array where Element: Any {
    func objectAt(_ index: Int) -> Element? {
        if (index < 0 || index > self.count - 1) { return nil }
        return self[index]
    }
}
