//
//  CameraPresenter.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import AVFoundation

protocol CameraPresenterProtocol {
    var view: CameraViewProtocol? { get set }
    var router: CameraRouterProtocol? { get set }
    
    var cameraCapture: CICameraCapture? { get set }
    var filterImageMonochrome: CIFilter & CIColorMonochrome { get set }
    var selectedFilterColor: FilterColor { get set }
    var resultCIImagePublisher: Published<CIImage?>.Publisher { get }
    var cameraPosition: AVCaptureDevice.Position { get set }
    
    func changeFilterColor(selected: FilterColor)
    func changeCustomFilterColor(color: UIColor)
    func cameraCaptureWithFilter()
    func showDetailImage(image: UIImage) 
    func changeCameraPosition(cameraPosition: AVCaptureDevice.Position)
}

class CameraPresenter: CameraPresenterProtocol {
    @Published var resultCIImage: CIImage? = nil
    var resultCIImagePublisher: Published<CIImage?>.Publisher { $resultCIImage }
    
    var view: CameraViewProtocol?
    
    var router: CameraRouterProtocol?
    
    var cameraCapture: CICameraCapture?
    var selectedFilterColor: FilterColor = .normal
    var filterImageMonochrome = CIFilter.colorMonochrome()
    var selectedCustomColorFilter: UIColor = .white
    
    var cameraPosition: AVCaptureDevice.Position = .back
    
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
            break
        case .custom:
            self.filterImageMonochrome.color = CIColor(color: selectedCustomColorFilter)
        }
    }
    
    func changeCameraPosition(cameraPosition: AVCaptureDevice.Position) {
        cameraCapture?.stop()
        self.cameraPosition = cameraPosition
        cameraCaptureWithFilter()
    }
    
    func changeCustomFilterColor(color: UIColor) {
        self.selectedCustomColorFilter = color
        self.changeFilterColor(selected: selectedFilterColor)
    }
    
    func cameraCaptureWithFilter() {
        cameraCapture = CICameraCapture(cameraPosition: cameraPosition, callback: { image in
            guard let image = image else { return }

            self.filterImageMonochrome.inputImage = image

            if(self.selectedFilterColor == .normal) {
                self.resultCIImage = image.cropped(to: image.extent)
            } else {
                self.resultCIImage = self.filterImageMonochrome.outputImage?.cropped(to: image.extent)
            }
        })
        cameraCapture?.start()
    }
    
    func showDetailImage(image: UIImage) {
        router?.navigateToDetail(image: image)
    }
}
