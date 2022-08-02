//
//  OriginalButtonStyle.swift
//  MintWeibo
//
//  Created by Mint on 2022/8/1.
//

import SwiftUI

//如果对文字不进行设置颜色，或者图片不渲染原始图片，在navigationlink下，文字会显示蓝色，图片可能不显示，因为navigationlink包了一层button在上面，需要返回button原来的样子
struct OriginalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
