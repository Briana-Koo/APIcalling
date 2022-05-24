//
//  ContentView.swift
//  APIcalling
//
//  Created by Student on 5/16/22.
//

import SwiftUI

struct ContentView: View {
    @State private var books = [Book]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(
                    destination: Text(book.title)
                        .padding(),
                    label: {
                        Text(book.author)
                    })
            }
            .navigationTitle("Books")
        }
        .onAppear(perform: {
            getBooks()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func getBooks() {
        let query = "https://training.xcelvations.com/data/books.json"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let author = item["author"].stringValue
                    let title = item["title"].stringValue
                    let book = Book(author: author, title: title)
                    books.append(book)
                }
                return
            } }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Book: Identifiable {
    let id = UUID()
    var author: String
    var title: String
}
