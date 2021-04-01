// Created by Ina Statkic in 2021.

import SwiftUI
import Combine

struct ContentView: View {
    @State var searchTerm: String = "Max Richter"
    var searchTermPublisher: AnyPublisher<String, Never>
    var willChange = PassthroughSubject<String, Never>()
    @ObservedObject var resource = Resource(endpoint: YouTubeManager.shared.search(for: "Max Richter"))
    
    init() {
        searchTermPublisher = willChange
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchTerm)
                    .onChange(of: searchTerm) {
                        willChange.send($0)
                    }
                    .onReceive(searchTermPublisher, perform: {
                        resource.set(endpoint: YouTubeManager.shared.search(for: $0))
                    })
                .overlay(Image(systemName: "magnifyingglass"), alignment: .trailing)
                .padding(.horizontal, 20).padding(.vertical, 10)
                if resource.value == nil {
                    ProgressView()
                } else {
                    List {
                        ForEach(resource.value!.items.map { Video(from: $0) }) { video in
                            NavigationLink(destination: VideoDetails(video: video)) {
                                VideoCell(video: video, text: $searchTerm)
                            }
                        }
                    }
                    .navigationTitle("Videos")
                    .listStyle(PlainListStyle())
                    .environment(\.defaultMinListRowHeight, 100)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
