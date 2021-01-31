//
//  ViewController.swift
//  nyt-best-selllers
//
//  Created by fmustafa on 1/30/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let reuseIdentifier = "BookCell"
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 10.0,
                                     bottom: 10.0,
                                     right: 10.0)
    var viewModel: BookViewModel!
    var service = BookService()
    let apiKey = Config.apiKey
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookViewModel()
        loadBookDataFromService()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.minimumLineSpacing = 0
//        flowLayout.minimumInteritemSpacing = 0
//        flowLayout.sectionInset = sectionInsets
        
        let itemSize = UIScreen.main.bounds.width/2 - 3

        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)

        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
    }
    
    func loadBookDataFromService() {
        let baseUrl = "https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key="
        let urlString = baseUrl + apiKey
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
//                service.parse(json: data)
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

}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
//        cell.bookCover.load(urlString: viewModel.books[0].book_image)
        print(books)
        cell.bookCover.load(urlString: books[indexPath.row].book_image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}

//MARK: - UICollectionViewDelegate: didSelectItemAt
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
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
//
//      func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//      }
//
//      func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//      }
}

extension UIImageView {
    func load(urlString: String) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
