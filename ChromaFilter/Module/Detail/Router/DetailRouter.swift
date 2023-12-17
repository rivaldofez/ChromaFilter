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
        
    }
    
    
}
