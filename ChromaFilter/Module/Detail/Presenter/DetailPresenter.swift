//
//  DetailPresenter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit

protocol DetailPresenterProtocol {
    var view: DetailViewProtocol? { get set }
    var router: DetailRouter? { get set }
    
    func setImage(image: UIImage)
}

class DetailPresenter: DetailPresenterProtocol {
    var router: DetailRouter?
    
    var view: DetailViewProtocol?
    
    func setImage(image: UIImage) {
        view?.updateImageData(image: image)
    }
}
