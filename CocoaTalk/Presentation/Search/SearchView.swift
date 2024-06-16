//
//  SearchView.swift
//  CocoaTalk
//
//  Created by hs on 6/15/24.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    enum Action {
        case setSearchText(String?)
        case requestQuery(String)
        case clearSearchResult
        case clearSearchText
        case pop
    }
    
    @Published var searchText: String = ""
    @Published var shouldBecomeFirstResponder: Bool = false
    @Published var searchResults: [User] = []
    
    private var container: DIContainer
    private var userId: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
        
        bind()
    }
    
    func bind() {
        $searchText
            .debounce(for: .seconds(0.4), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.send(action: .clearSearchResult)
                } else {
                    self?.send(action: .requestQuery(text))
                }
            }.store(in: &subscriptions)
    }
    
    
    func send(action: Action) {
        switch action {
        case let .setSearchText(text):
            searchText = text ?? ""
        case let .requestQuery(query):
            Task {
                let _searchResults = try? await container.services.userService.filterUsers(with: query, userId: userId)
                await MainActor.run {
                    searchResults = _searchResults ?? []
                }
            }
        case .clearSearchResult:
            searchResults = []
        case .clearSearchText:
            searchText = ""
            shouldBecomeFirstResponder = false
            searchResults = []
        case .pop:
            container.navigationRouter.pop()
        }
    }
}

struct SearchView: View {
    @StateObject var vm: SearchViewModel
    @EnvironmentObject var container: DIContainer
    @Environment(\.managedObjectContext) var objectContext
    
    var body: some View {
        ZStack{
            Color.secondary.opacity(0.3)
                .ignoresSafeArea()
            VStack{
                header
                    .padding(.horizontal, 10)
                
                if vm.searchResults.isEmpty {
                    HistoryView{ text in
                        vm.send(action: .setSearchText(text))
                    }
                } else {
                    List {
                        ForEach(vm.searchResults) { result in
                            Button(action: {
                                vm.send(action: .setSearchText(result.name))
                            }, label: {
                                HStack(spacing: 8) {
                                    URLImageView(urlString: result.profileURL, backgroundColor: .mint, size: 20)
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    Text(result.name)
                                }
                                .padding(.bottom, 5)
                                .listRowInsets(.init())
                                .listRowSeparator(.hidden)
                                .padding(.horizontal, 30)
                            })
                        }
                    }
                    // MARK: - List listStyle
                    .listStyle(.plain)
                    .background(Color.secondary.opacity(0.3))
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    var header: some View {
        HStack{
            SearchBar(text: $vm.searchText, 
                      shouldBecomeFirstResponder: $vm.shouldBecomeFirstResponder,
                      onClickedSearchButton: setSearchResultWithContext,
                      onClickedCancelButton: {
                vm.send(action: .clearSearchResult)
            })
            Button(action: {
                vm.send(action: .pop)
            }, label: {
                Text("취소")
                    .foregroundColor(.secondary)
            })
        }
    }
    
    func setSearchResultWithContext() {
        /// SearchResult Entity로 검색기록을 저장

        let result = SearchResult(context: objectContext)
        result.id = UUID().uuidString
        result.name = vm.searchText
        result.date = Date()
        
        do {
            try objectContext.save()
        } catch {
            print(error)
        }
    }
}

#Preview {
    NavigationStack{
        SearchView(vm: .init(container: .stub, userId: "userId"))
    }
    .environmentObject(DIContainer.stub)
}
