//
//  HistoryView.swift
//  CocoaTalk
//
//  Created by hs on 6/15/24.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var objectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var results: FetchedResults<SearchResult>
    
    var onTapResult: ((String?) -> Void)
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ZStack(alignment: .top){
            background
            
            VStack {
                header
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(results) { result in
                            if let query = result.name {
                                HistoryContentView(query: query){
                                    objectContext.delete(result)
                                    do {
                                        try objectContext.save()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
    }
    
    var header: some View {
        HStack {
            Text("최근 검색")
                .bold()
            Spacer()
            Button(action: {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Search")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try objectContext.execute(batchDeleteRequest)
                    try objectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("전체삭제")
                    .font(.subheadline)
            })
        }
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
    }
    
    var background: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.black : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)
    }
}

struct HistoryContentView: View {
    let query: String
    var action: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Text(query)
                Button(action: {
                    action()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                })
            }
            .padding(12)
            .background(Capsule().fill(Color.secondary))
            .foregroundColor(.white)

        }
    }
}

#Preview {
    HistoryView{ _ in
        
    }
}
