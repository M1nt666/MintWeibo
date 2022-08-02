//
//  PostVIPBadge.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/19.
//

import SwiftUI

struct PostVIPBadge: View {
    let vip: Bool
    
    var body: some View {
        if vip {
            Text("V")
                .bold()
                .font(.system(size: 11))
                .frame(width: 15, height: 15)
                .foregroundColor(.yellow)
                .background(.red)
                .clipShape(Circle())
                .overlay(
                    RoundedRectangle(cornerRadius: 7.5)
                        .stroke(.white, lineWidth: 1)
            )
        }
    }
}

struct PostVIPBadge_Previews: PreviewProvider {
    static var previews: some View {
        PostVIPBadge(vip: true)
    }
}
