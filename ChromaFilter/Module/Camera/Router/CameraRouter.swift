//
//  CameraRouter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit

typealias BeginEntry = CameraRouterProtocol & UIViewController

protocol CameraRouterProtocol {
    var begin: BeginEntry? { get set }
    
    static func start() -> CameraRouterProtocol
}

class CameraRouter: CameraRouterProtocol {
    var begin: BeginEntry?
    
    static func start() -> CameraRouterProtocol {
        let router = CameraRouter()
        
        var view: CameraViewProtocol = CameraViewController()
        var presenter: CameraPresenterProtocol = CameraPresenter()
        
        view.presenter = presenter
        presenter.router = router
        presenter.view = view
        
        router.begin = view as? BeginEntry
        
        return router
    }
}
