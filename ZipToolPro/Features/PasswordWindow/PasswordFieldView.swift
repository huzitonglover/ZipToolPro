//
//  PasswordField.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import SwiftUI

struct PasswordFieldView: View {
    @Binding var password: String
    @State private var isRevealed = false

    var body: some View {
        HStack {
            Group {
                if isRevealed {
                    TextField("Password:", text: $password)
                } else {
                    SecureField("Password:", text: $password)
                }
            }
            .textFieldStyle(.roundedBorder)

            Button {
                isRevealed.toggle()
            } label: {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
            }
            .buttonStyle(.plain)
        }
    }
}
