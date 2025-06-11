//
//  FavoriteView.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2025/05/06.
//

import SwiftUI

// MARK: - Data Models
struct GitHubSearchResponse: Codable {
    let totalCount: Int
    let items: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}

// MARK: - API Service
class GitHubAPIService: ObservableObject {
    @Published var users: [GitHubUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func searchUsers(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            users = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.github.com/search/users?q=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "無効なURLです"
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "ネットワークエラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "データを取得できませんでした"
                    return
                }
                
                do {
                    let searchResponse = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
                    self?.users = searchResponse.items
                    
                    if searchResponse.items.isEmpty {
                        self?.errorMessage = "検索結果はありませんでした"
                    }
                } catch {
                    self?.errorMessage = "データの解析に失敗しました"
                }
            }
        }.resume()
    }
}

// MARK: - Views
struct GithubView: View {
    @StateObject private var apiService = GitHubAPIService()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // 検索テキストフィールド
                SearchTextField(text: $searchText, onSearchChanged: { query in
                    apiService.searchUsers(query: query)
                })
                .padding(.horizontal)
                
                // メインコンテンツ
                if apiService.isLoading {
                    LoadingView()
                } else if let errorMessage = apiService.errorMessage {
                    ErrorView(message: errorMessage)
                } else {
                    UserListView(users: apiService.users)
                }
                
                Spacer()
            }
            .navigationTitle("GitHub User Search")
        }
    }
}

struct SearchTextField: View {
    @Binding var text: String
    let onSearchChanged: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("ユーザー名を検索", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    onSearchChanged(text)
                }
                .onChange(of: text) { newValue in
                    // リアルタイム検索（オプション）
                    // onSearchChanged(newValue)
                }
            
            if !text.isEmpty {
                Button("検索") {
                    onSearchChanged(text)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct UserListView: View {
    let users: [GitHubUser]
    
    var body: some View {
        List(users) { user in
            UserRowView(user: user)
        }
        .listStyle(PlainListStyle())
    }
}

struct UserRowView: View {
    let user: GitHubUser
    
    var body: some View {
        HStack {
            // アバター画像
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // ユーザー情報
            VStack(alignment: .leading, spacing: 4) {
                Text(user.login)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("ID: \(user.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text("検索中...")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GithubView()
}
