//
//  SearchBar.swift
//  CocoaTalk
//
//  Created by hs on 6/15/24.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    @Binding var shouldBecomeFirstResponder: Bool
    var onClickedSearchButton: (() -> Void)?
    var onClickedCancelButton: (() -> Void)?
    
    init(text: Binding<String>,
         shouldBecomeFirstResponder: Binding<Bool>,
         onClickedSearchButton: (() -> Void)?,
         onClickedCancelButton: (() -> Void)?) {
        self._text = text
        self._shouldBecomeFirstResponder = shouldBecomeFirstResponder
        self.onClickedSearchButton = onClickedSearchButton
        self.onClickedCancelButton = onClickedCancelButton
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, shouldBecomeFirstResponder: $shouldBecomeFirstResponder, onClickedSearchButton: onClickedSearchButton, onClickedCancelButton: onClickedCancelButton)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색"
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: Context) {
        updateSearchText(searchBar, context: context)
        updateBecomeFirstResponder(searchBar, context: context)
    }
    
    private func updateSearchText(_ searchBar: UISearchBar, context: Context) {
        context.coordinator.setSearchText(searchBar, text: text)
    }
    
    private func updateBecomeFirstResponder(_ searchBar: UISearchBar, context: Context) {
        /// 우선 SearchBar가 FirstReponder가 될 수 있는지 확인(FirstReponder=액션 메시지를 받는 첫번째 객체)
        guard searchBar.canBecomeFirstResponder else { return }
        
        DispatchQueue.main.async {
            if shouldBecomeFirstResponder {
                guard !searchBar.isFirstResponder else { return }
                searchBar.becomeFirstResponder()  /// SearchBar를 FirstResponder가 되도록 함(become)
            } else {
                guard searchBar.isFirstResponder else { return }
                searchBar.resignFirstResponder()  /// SearchBar가 FirstResponder가 안되도록 함(resign)
            }
        }
    }
}

extension SearchBar {
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var shouldBecomeFirstResponder: Bool
        var onClickedSearchButton: (() -> Void)?
        var onClickedCancelButton: (() -> Void)?
        
        init(text: Binding<String>,
             shouldBecomeFirstResponder: Binding<Bool>,
             onClickedSearchButton: (() -> Void)?,
             onClickedCancelButton: (() -> Void)?) {
            self._text = text
            self._shouldBecomeFirstResponder = shouldBecomeFirstResponder
            self.onClickedSearchButton = onClickedSearchButton
            self.onClickedCancelButton = onClickedCancelButton
        }
        
        /// updateSearchText에서 사용
        func setSearchText(_ searchBar: UISearchBar, text: String) {
            searchBar.text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
            if searchText.isEmpty {
                /// x버튼을 눌러 텍스트가 비워졌을 때 수행
                onClickedCancelButton?()
            }
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.shouldBecomeFirstResponder = true
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            self.shouldBecomeFirstResponder = false
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onClickedSearchButton?()
        }

    }
}
