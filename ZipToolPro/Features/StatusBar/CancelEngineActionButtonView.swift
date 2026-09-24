//
//  CancelEngineActionButton.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Core
import SwiftUI

struct CancelEngineActionButtonView: View {
    @State var hovered: Bool = false
    
    let pressed: () -> Void
    
    var body: some View {
        Button {
            pressed()
        } label: {
            Image(systemName: "x.circle.fill")
                .foregroundStyle(hovered ? .primary : .secondary)
                .onHover { hovered in
                    self.hovered = hovered
                }
        }
        .buttonStyle(.plain)
        .padding(.leading, 8)
        .padding(.trailing, 4)
    }
}
