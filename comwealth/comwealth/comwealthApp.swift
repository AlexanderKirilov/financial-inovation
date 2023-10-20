//
//  ComwealthApp.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

@main
struct ComwealthApp: App {
    private let hideKeyboard = TapGesture().onEnded { _ in
        UIApplication.shared.endEditing()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .gesture(hideKeyboard)
        }
    }
}
