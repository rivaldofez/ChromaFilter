//
//  DetailPresenter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import Foundation

protocol DetailPresenterProtocol {
    var view: DetailViewProtocol? { get set }
}

class DetailPresenter: DetailPresenterProtocol {
    var view: DetailViewProtocol?
    
    
}
