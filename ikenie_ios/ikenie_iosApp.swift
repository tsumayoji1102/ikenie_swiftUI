//
//  ikenie_iosApp.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2024/07/01.
//

import SwiftUI

@main
struct ikenie_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
