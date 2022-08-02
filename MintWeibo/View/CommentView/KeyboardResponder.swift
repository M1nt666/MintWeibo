//
//  KeyboardResponder.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/24.
//

import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    var keyboardShow: Bool {
        keyboardHeight > 0
    }
    init() {
        //在默认的通知中心添加一个通知的观察者，监听键盘即将出现的通知，当键盘即将出现系统会发送通知，通知的监听者（此处为keyboardresponder）会收到收到这个通知，然后执行selector中的函数，object表示是谁发出的通知（可指定发出的通知）
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = frame.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
    }
}
