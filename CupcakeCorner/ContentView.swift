//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Kitwana Akil on 7/16/23.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String

}

struct ContentView: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id:\.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        // Step 1 - create the url we want to read
        guard let url = URL(string: "https://itunes.apple.com/search?term=slick+rick&entity=song") else {
            print("Invalid url")
            return
        }
        
        // Step 2 - fetch data from the url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
        
        // Step 3 - Decode the result of that data into our response
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
