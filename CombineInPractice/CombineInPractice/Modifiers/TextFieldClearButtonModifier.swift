//
//  TextFieldClearButtonModifier.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 12/10/23.
//

import SwiftUI

struct TextFieldClearButtonModifier: ViewModifier {

    @Environment(\.colorScheme) var scheme
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(scheme == .light ? .gray.opacity(0.7): .white.opacity(0.8))
                }
                .padding(.vertical, 10)
                .padding(.leading, 10)
                .padding(.trailing, 20)
            }
        }
    }
}
