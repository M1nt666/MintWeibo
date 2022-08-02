//
//  PostCellToolbarButton.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/20.
//

import SwiftUI

struct PostCellToolbarButton: View {
    let image: String
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            Button(action: action) {
                HStack(spacing: 5) {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text(text)
                        .font(.system(size: 15))
                }
            }
            .foregroundColor(color)
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct PostCellToolbarButton_Previews: PreviewProvider {
    static var previews: some View {
        PostCellToolbarButton(image: "heart", text: "点赞", color: .red) {
            print("Click")
        }
    }
}
