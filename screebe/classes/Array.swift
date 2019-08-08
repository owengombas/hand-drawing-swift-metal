//
//  Array.swift
//  screebe
//
//  Created by Owen on 09.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation

extension Array {
    func appendAndMaintainLength(_ element: Iterator.Element, _ length: Int) {
        if count >= length {
            self.remove(at: 0)
        }
        self.append(element)
    }
}
