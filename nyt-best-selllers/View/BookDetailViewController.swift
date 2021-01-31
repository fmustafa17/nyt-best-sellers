//
//  BookDetailViewController.swift
//  nyt-best-sellers
//
//  Created by fmustafa on 1/31/21.
//

import UIKit
import SafariServices

class BookDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    var selectedBook: Book?
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!

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
    
    @IBAction func openActionSheet(_ sender: Any) {
        guard let book = selectedBook else { return }

        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Buy via...", message: "", preferredStyle: .actionSheet)
        
        for buyLink in book.buy_links {
            let action = UIAlertAction(title: "\(buyLink.name)", style: .default) { _ in
                if let url = URL(string: buyLink.url) {
                    if UIApplication.shared.canOpenURL(url) {
                        let safariVC = SFSafariViewController(url: url)
                        safariVC.delegate = self
                        self.present(safariVC, animated: true)
                    }
                }
            }
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem = nil

        self.present(alert, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
