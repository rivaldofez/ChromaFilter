//
//  DetailRouter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit

protocol DetailRouterProtocol {
    var entry: DetailViewController? { get }
    
    static func createDetail(with image: UIImage) -> DetailRouterProtocol
}

class DetailRouter: DetailRouterProtocol {
    var entry: DetailViewController?
    
    static func createDetail(with image: UIImage) -> DetailRouterProtocol {
        let router = DetailRouter()
        
        var view: DetailViewProtocol = DetailViewController()
        var presenter: DetailPresenterProtocol = DetailPresenter()
        
        view.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.setImage(image: image)
        
        router.entry = view as? DetailViewController
        return router
    }
}
