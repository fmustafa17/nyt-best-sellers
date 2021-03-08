//
//  ViewController.swift
//  nyt-best-selllers
//
//  Created by fmustafa on 1/30/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!

    let reuseIdentifier = "BookCell"
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 10.0,
                                     bottom: 10.0,
                                     right: 10.0)
    var viewModel: BookViewModel!
    let apiKey = Config.apiKey
    
    var books = [Book]()
    var books2 = [Book]()
    var books3 = [Book]()
    //TODO: see if NYT has some access to all the displaynames
    let displayNames = ["Hardcover Fiction", "Combined Print and E-book Fiction"]
    //list_name : list_name_encoded
    var categories = [
        "Combined Print and E-book Fiction": "combined-print-and-e-book-fiction",
        "Combined Print & E-Book Nonfiction": "combined-print-and-e-book-nonfiction",
        "Advice, How-To & Miscellaneous": "advice-how-to-and-miscellaneous",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookViewModel()
        loadBookDataFromService()
        loadBookDataFromServiceIntoCollectionView2()
        loadBookDataFromServiceIntoCollectionView3()
        
        self.title = "New York Times Best Seller Books"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100)
    }
    
    func loadBookDataFromService() {
        // TODO: add query params
        let baseUrl = "https://api.nytimes.com/svc/books/v3/lists/current/combined-print-and-e-book-fiction.json?api-key="
        let urlString = baseUrl + apiKey
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let bookResponse = try? decoder.decode(Response.self, from: json) {
            books = bookResponse.results.books
        }
    }
    
    func loadBookDataFromServiceIntoCollectionView2() {
        let baseUrl = "https://api.nytimes.com/svc/books/v3/lists/current/combined-print-and-e-book-nonfiction.json?api-key="
        let urlString = baseUrl + apiKey
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseIntoCollectionView2(json: data)
            }
        }
    }

    func parseIntoCollectionView2(json: Data) {
        let decoder = JSONDecoder()
        
        if let bookResponse = try? decoder.decode(Response.self, from: json) {
            books2 = bookResponse.results.books
        }
    }

    func loadBookDataFromServiceIntoCollectionView3() {
        let baseUrl = "https://api.nytimes.com/svc/books/v3/lists/current/advice-how-to-and-miscellaneous.json?api-key="
        let urlString = baseUrl + apiKey
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseIntoCollectionView3(json: data)
            }
        }
    }

    func parseIntoCollectionView3(json: Data) {
        let decoder = JSONDecoder()
        
        if let bookResponse = try? decoder.decode(Response.self, from: json) {
            books3 = bookResponse.results.books
        }
    }

}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCell
        cell.bookCover.loadImageKf(urlString: books[indexPath.row].book_image, imageView: cell.bookCover)
        
        if collectionView == collectionView2 {
            let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "BookCell2", for: indexPath) as! BookCell2
            cell2.bookCover.loadImageKf(urlString: books2[indexPath.row].book_image, imageView: cell2.bookCover)
            return cell2
        }
        
        if collectionView == collectionView3 {
            let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "BookCell3", for: indexPath) as! BookCell3
            cell3.bookCover.loadImageKf(urlString: books3[indexPath.row].book_image, imageView: cell3.bookCover)
            return cell3
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}

//MARK: - UICollectionViewDelegate: didSelectItemAt
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bundle = Bundle(for: type(of: self))
        let bookDetailStoryboard = UIStoryboard(name: StoryboardName.bookDetail, bundle: bundle)
        let vc = bookDetailStoryboard.instantiateViewController(withIdentifier: Identifier.bookDetail) as! BookDetailViewController
        
        if collectionView == collectionView1 {
            vc.selectedBook = books[indexPath.row]
        }

        if collectionView == collectionView2 {
            vc.selectedBook = books2[indexPath.row]
        }

        if collectionView == collectionView3 {
            vc.selectedBook = books3[indexPath.row]
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout delegate. Defines how thee UICollectionView will layout the data
extension ViewController: UICollectionViewDelegateFlowLayout {
    
      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
}

extension UIImageView {
    func loadImageKf(urlString: String, imageView: UIImageView) {
        let url = URL(string: urlString)

        // set the image view via kingfisher
        imageView.kf.setImage(with: url, options: [
            .transition(.fade(1)),
            .cacheOriginalImage
        ]) { (result) in
            switch result {
            case .success(let image):
                imageView.image = image.image
            case .failure(_):
                print("Failed to load image via Kingfisher.")
            }
        }
    }
}
