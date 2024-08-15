//
//  MessageView.swift
//  Week Routine
//
//  Created by ibrahim uysal on 15.08.2024.
//

import Foundation
import SwiftUI

enum MessageType {
    case success
    case warning
    case error
}

struct MessageView: View {
    
    let title: String
    let message: String
    let messageType: MessageType
    
    private var backgroundColor: Color {
        switch messageType {
            case .success:  return Color.green
            case .warning:  return Color.yellow
            case .error:    return Color.red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(message)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.white)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .padding()
        .background(backgroundColor)
    }
}
