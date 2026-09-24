//
//  PasswordView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import SwiftUI
import Core

struct PasswordView: View {
    let request: ArchivePasswordRequest?
    @State private var password: String = ""
    
    var onSubmit: ((String) -> Void)?
    var onCancel: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("输入压缩包密码")
                    .font(.headline)
                
                if let request {
                    Text(verbatim: request.url.lastPathComponent)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(1)
                    
                    Text(verbatim: request.url.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                if let message {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            
            HStack(spacing: 8) {
                Text("密码")
                    .frame(width: 44, alignment: .leading)
                PasswordFieldView(password: $password)
            }
            
            HStack {
                Spacer()
                
                Button {
                    onCancel?()
                } label: {
                    Text(verbatim: "Cancel")
                }
                
                Button {
                    onSubmit?(password)
                } label: {
                    Text(verbatim: "OK")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    private var message: String? {
        if let requestMessage = request?.message {
            return requestMessage
        }
        
        guard let attempt = request?.attempt, attempt > 1 else {
            return nil
        }
        
        return "密码不正确，请重新输入。"
    }
}
