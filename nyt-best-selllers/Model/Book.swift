//
//  Book.swift
//  nyt-best-selllers
//
//  Created by fmustafa on 1/30/21.
//

import Foundation

struct Response: Codable {
    var status: String
    var results: Results
}

struct Results: Codable {
    var list_name: String
    var list_name_encoded: String
    var display_name: String
    var books: [Book]
}

struct Book: Codable {
    var title: String
    var author: String
    var book_image: String
    var description: String
    var buy_links: [Links]
}

struct Links: Codable {
    var name: String
    var url: String
}
