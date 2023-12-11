//
//  View+.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 12/10/23.
//

import SwiftUI

extension View {
    
    func clearButtonOn(text: Binding<String>) -> some View {
        modifier(TextFieldClearButtonModifier(text: text))
    }
}
