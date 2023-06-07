//
//  ContentView.swift
//  CatClient
//
//  Created by Tomáš Kadaně on 30.05.2023.
//

import SwiftUI

//let Apikey = "live_FFaDOvUzr9lavna3sSZSOXXB0wChRbYhwHzOOdS7T2m80Qcs59XqCyEzRr7qN4bc"

struct CatBreed: Codable {
    let id: String
    let name: String
    let description: String
}


class CatBreedsViewModel: ObservableObject {
    @Published var catBreeds: [CatBreed] = []
    @Published var imageUrlByBreed = [String:String]()
    
    init() {
        fetchData()
        fetchImages()
    }
    
    private func fetchData() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds?api_key=live_FFaDOvUzr9lavna3sSZSOXXB0wChRbYhwHzOOdS7T2m80Qcs59XqCyEzRr7qN4bc") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            //decode json
            do {
                let breeds = try JSONDecoder().decode([CatBreed].self, from: data)
                DispatchQueue.main.async {
                    self?.catBreeds = breeds
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func fetchImages() {
        print("hi")
        catBreeds.forEach()
        
        
    }
}

struct ContentView: View {
    @StateObject private var viewModel = CatBreedsViewModel()
    
    var body: some View {
        Group {
            if viewModel.catBreeds.isEmpty {
                ProgressView("Loading...")
            } else {
                NavigationView {
                    List(viewModel.catBreeds, id: \.id) { breed in
                        NavigationLink(destination: BreedDetailView(breed: breed)) {
                            Text(breed.name)
                        }
                    }
                    .navigationTitle("Cat Breeds")
                }
            }
        }
    }
}

struct BreedDetailView: View {
    let breed: CatBreed
    
    var body: some View {
        VStack {
            Text(breed.description)
                .padding()
        
        }
        .navigationTitle(breed.name)
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
