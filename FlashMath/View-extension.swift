//
//  View-extension.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 31/05/2022.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 20)
    }
}
