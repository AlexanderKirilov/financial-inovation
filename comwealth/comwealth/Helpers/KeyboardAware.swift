//
//  KeyboardAware.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

public class KeyboardInfo: ObservableObject {
    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), 
                                               name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        switch notification.name {
        case UIApplication.keyboardWillHideNotification:
            height = 0
        default:
            let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let keyboardHeight = keyboardRect?.height ?? 0
            height = keyboardHeight
        }
    }
}

struct KeyboardAware: ViewModifier {
    @ObservedObject private var keyboard = KeyboardInfo.shared

    func body(content: Content) -> some View {
        withAnimation(.easeOut(duration: 0.16)) {
            content
                .padding(.bottom, self.keyboard.height)
                .edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
        }
    }
}

extension View {
    public func keyboardAware() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware())
    }
}

