//
//  HomeViewModel.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2025/05/09.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var texts: Array<String> = ["Hello, World!"]
    
    init() {
        for i in 0..<100 {
            texts.append("Hello, World! \(i)")
        }
    }
}
