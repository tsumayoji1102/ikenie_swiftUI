//
//  HomeView.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2025/05/06.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hello, World!")
                .fontWeight(.bold)
            
            TextField("Enter your name", text: .constant(""))
                .padding(.leading, 5)
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.texts, id: \.self) { text in
                        Text(text)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.all, 20)
    }
}

#Preview {
    HomeView()
}
