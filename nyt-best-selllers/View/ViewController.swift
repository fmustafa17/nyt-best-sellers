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
    
    let reuseIdentifier = "BookCell"
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 10.0,
                                     bottom: 10.0,
                                     right: 10.0)
    var viewModel: BookViewModel!
    let apiKey = Config.apiKey
    
    var books = [Book]()
    //TODO: see if NYT has some access to all the displaynames
    let displayNames = ["Hardcover Fiction", "Combined Print and E-book Fiction"]
    //list_name : list_name_encoded
    var categories = [
        "Hardcover Fiction": "hardcover-fiction",
        "Combined Print and E-book Fiction": "combined-print-and-e-book-fiction",
        "": "paperback-trade-fiction"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookViewModel()
        loadBookDataFromService()
        
        // Initialize the collection views, set the desired frames
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        collectionView2.delegate = self
//        collectionView2.delegate = self
//
//        collectionView3.dataSource = self
//        collectionView3.dataSource = self
        
        // Register the cells
//        collectionView1.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
        
        self.title = "New York Times Best Seller Books"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func loadBookDataFromService() {
        // TODO: add query params
        let baseUrl = "https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key="
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
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? BookSectionHeaderView {
//            for name in displayNames {
////                if let title = categories[name] {
////                    sectionHeader.sectionHeaderLabel.text = title
////                }
//                sectionHeader.sectionHeaderLabel.text = name
//                sectionHeader.sectionHeaderLabel.textAlignment = .left
//            }
//            return sectionHeader
//        }
//        return UICollectionReusableView()
//    }

}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCell
        cell.bookCover.loadImageKf(urlString: books[indexPath.row].book_image, imageView: cell.bookCover)
        
        if collectionView == collectionView2 {
            let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "BookCell2", for: indexPath) as! BookCell2
            cell2.backgroundColor = .red
            return cell2
        }
        
        if collectionView == collectionView3 {
            let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "BookCell3", for: indexPath) as! BookCell3
            cell3.backgroundColor = .blue
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
        vc.selectedBook = books[indexPath.row]

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
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return displayNames.count
//    }
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
