//
//  CameraPresenter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

protocol CameraPresenterProtocol {
    var view: CameraViewProtocol? { get set }
    var router: CameraRouterProtocol? { get set }
    
    var cameraCapture: CICameraCapture? { get set }
    var filterImageMonochrome: CIFilter & CIColorMonochrome { get set }
    var selectedFilterColor: FilterColor { get set }
    var resultCIImagePublisher: Published<CIImage?>.Publisher { get }
    
    func changeFilterColor(selected: FilterColor)
    func cameraCaptureWithFilter()
}

class CameraPresenter: CameraPresenterProtocol {
    @Published var resultCIImage: CIImage? = nil
    var resultCIImagePublisher: Published<CIImage?>.Publisher { $resultCIImage }
    
    var view: CameraViewProtocol?
    
    var router: CameraRouterProtocol?
    
    var cameraCapture: CICameraCapture?
    var selectedFilterColor: FilterColor = .normal
    var filterImageMonochrome = CIFilter.colorMonochrome()
    
    func changeFilterColor(selected: FilterColor) {
        selectedFilterColor = selected
        switch selected {
        case .red:
            self.filterImageMonochrome.color = CIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        case .green:
            self.filterImageMonochrome.color = CIColor(red: 0.5, green: 1, blue: 0.5, alpha: 1)
        case .blue:
            self.filterImageMonochrome.color = CIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1)
        case .normal:
            self.filterImageMonochrome.color = CIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func cameraCaptureWithFilter() {
        cameraCapture = CICameraCapture(cameraPosition: .back, callback: { image in
            guard let image = image else { return }
            
            print("called image capture")

            self.filterImageMonochrome.inputImage = image

            if(self.selectedFilterColor == .normal) {
                self.resultCIImage = image.cropped(to: image.extent)
            } else {
                self.resultCIImage = self.filterImageMonochrome.outputImage?.cropped(to: image.extent)
            }
        })
        cameraCapture?.start()
    }
}
