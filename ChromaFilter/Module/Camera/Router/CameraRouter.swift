//
//  CameraRouter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit

typealias BeginEntry = CameraViewProtocol & UIViewController

protocol CameraRouterProtocol {
    var begin: BeginEntry? { get set }
    
    static func start() -> CameraRouterProtocol
    
    func navigateToDetail(image: UIImage)
}

class CameraRouter: CameraRouterProtocol {
    var begin: BeginEntry?
    
    static func start() -> CameraRouterProtocol {
        let router = CameraRouter()
        
        var view: CameraViewProtocol = CameraViewController()
        var presenter: CameraPresenterProtocol = CameraPresenter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        router.begin = view as? BeginEntry
        
        return router
    }
    
    func navigateToDetail(image: UIImage) {
        let detailRouter = DetailRouter.createDetail(with: image)
        guard let detailview = detailRouter.entry else { return }
        guard let viewcontroller = self.begin else { return }
        
        viewcontroller.navigationController?.pushViewController(detailview, animated: true)
    }

}



