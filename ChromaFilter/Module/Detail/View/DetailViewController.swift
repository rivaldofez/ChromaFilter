//
//  DetailViewController.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit

protocol DetailViewProtocol {
    var presenter: DetailPresenterProtocol? { get set }
    
    func updateImageData(image: UIImage)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    var presenter: DetailPresenterProtocol?
    
    
    let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        
        return imageview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        view.addSubview(imageView)
        
        let imageViewConstraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func updateImageData(image: UIImage) {
        self.imageView.image = image
    }
}
