//
//  BookDetailViewController.swift
//  nyt-best-sellers
//
//  Created by fmustafa on 1/31/21.
//

import UIKit

class BookDetailViewController: UIViewController {
    var selectedBook: Book?
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBookDetails()
    }
    
    func showBookDetails() {
        guard let book = selectedBook else { return }
        bookCoverImage.loadImageKf(urlString: book.book_image, imageView: bookCoverImage)
        titleLabel.text = book.title
        authorLabel.text = book.author
        descriptionLabel.text = book.description
    }
}
