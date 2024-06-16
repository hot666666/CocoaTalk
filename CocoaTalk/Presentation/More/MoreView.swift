//
//  MoreView.swift
//  CocoaTalk
//
//  Created by hs on 6/16/24.
//

import SwiftUI
import Foundation

struct SectionItem: Identifiable {
    let id = UUID()
    let label: String
    let settings: [SettingItem]
}

enum AppearanceType: Int, CaseIterable, SettingItemable {
    case automatic
    case light
    case dark
    
    var label: String {
        switch self {
        case .automatic:
            return "시스템모드"
        case .light:
            return "라이트모드"
        case .dark:
            return "다크모드"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class MoreViewModel: ObservableObject {
    @Published var sectionItems: [SectionItem] = []

    init() {
        self.sectionItems = [
            .init(label: "모드설정", settings: AppearanceType.allCases.map { .init(item: $0) })
        ]
    }
}

struct MoreView: View {
    @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    @StateObject var vm: MoreViewModel = .init()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.sectionItems) { section in
                    Section {
                        ForEach(section.settings) { setting in
                            Button {
                                if let scheme = setting.item as? AppearanceType {
                                    container.appearanceController.changeAppearance(scheme)
                                    appearance = scheme.rawValue
                                }
                            } label: {
                                Text(setting.item.label)
                            }
                        }
                        .foregroundColor(.primary)
                    } header: {
                        Text(section.label)
                    }
                }
                
                Section("계정", content: {
                    Button(action: {
                        Task {
                            await authViewModel.send(action: .logout)
                        }
                    }) {
                        Text("로그아웃")
                    }
                    .foregroundColor(.primary)
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Text("더보기")
                        .bold()
                        .font(.title)
                })
            }
        }
    }
}

#Preview {
    MoreView()
        .environmentObject(DIContainer.stub)
        .environmentObject(AuthenticationViewModel(container: .stub))
}
