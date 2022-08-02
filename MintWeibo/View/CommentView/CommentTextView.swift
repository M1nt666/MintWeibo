//
//  CommentTextView.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/24.
//

import SwiftUI

struct CommentTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    let beginEdittingOnAppear: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.backgroundColor = .systemGray6
        view.font = .systemFont(ofSize: 18)
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = context.coordinator
        view.text = text
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        //更新view的时候，显示编辑状态，view被显示出来，对应的window一定不为空。uitextview进入编辑状态时，它必须为第一响应者
        //第一次进入编辑状态后，就不会再执行
        if beginEdittingOnAppear, !context.coordinator.didBecomeFirstReaponder, uiView.window != nil, !uiView.isFirstResponder {
            //让uiview成为第一响应者
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstReaponder = true
        }
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CommentTextView
        //确定是否为第一响应，如果为第一响应，则updateuiview就不需要重复更新
        var didBecomeFirstReaponder: Bool = false
        
        init(_ view: CommentTextView) { parent = view }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

struct CommentTextView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextView(text: .constant("dfds"),beginEdittingOnAppear: true)
    }
}
