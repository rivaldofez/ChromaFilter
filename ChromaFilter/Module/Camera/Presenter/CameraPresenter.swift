//
//  CameraPresenter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import Foundation

protocol CameraPresenterProtocol {
    var view: CameraViewProtocol? { get set }
    var router: CameraRouterProtocol? { get set }
}

class CameraPresenter: CameraPresenterProtocol {
    var view: CameraViewProtocol?
    
    var router: CameraRouterProtocol?
    
    
}
