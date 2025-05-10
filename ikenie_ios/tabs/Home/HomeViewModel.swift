//
//  HomeViewModel.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2025/05/09.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allTexts: Array<String> = []
    @Published var showingTexts: Array<String> = []
    @Published var searchText: String = ""
    
    init() {
        for i in 0..<100 {
            allTexts.append("Hello, World! \(i)")
            showingTexts = allTexts
        }
    }
    
    func search(_ text: String) {
        if(text.isEmpty){
            showingTexts = allTexts
            return
        }
        showingTexts = allTexts.filter { $0.contains(text) }
    }
}
