//
//  BookService.swift
//  nyt-best-sellers
//
//  Created by fmustafa on 1/30/21.
//

import Foundation

class BookService {
    
    var viewModel =  BookViewModel()
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let bookResponse = try? decoder.decode(Response.self, from: json) {
            viewModel.books = bookResponse.results.books
        }
    }
}
