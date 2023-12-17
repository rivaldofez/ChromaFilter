//
//  CameraViewController.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Combine


protocol CameraViewProtocol {
    var presenter: CameraPresenterProtocol? { get set }
}

class CameraViewController: UIViewController, CameraViewProtocol {
    var presenter: CameraPresenterProtocol?
    private var cancelable = Set<AnyCancellable>()
   
    
    private let redButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .red
        button.layer.cornerRadius = 25
        button.layer.backgroundColor = UIColor.red.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let greenButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .green
        button.layer.cornerRadius = 25
        button.layer.backgroundColor = UIColor.green.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let blueButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .blue
        button.layer.cornerRadius = 25
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let captureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private var filterColorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var imagePreview: MetalRenderView = {
        var metalview = MetalRenderView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        return metalview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureConstraints()
        setFilterButtonAction()
        bindData()
    }
    
    private func bindData() {
        presenter?.resultCIImagePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] resultImage in
                guard let image = resultImage else { return }
                self?.imagePreview.setImage(image.cropped(to: image.extent))
            })
            .store(in: &cancelable)
    }
    
    private func configureConstraints() {
        view.addSubview(imagePreview)
        view.addSubview(captureButton)
        view.addSubview(filterColorStackView)
        filterColorStackView.addArrangedSubview(redButton)
        filterColorStackView.addArrangedSubview(greenButton)
        filterColorStackView.addArrangedSubview(blueButton)
        
        let captureButtonConstraints = [
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            captureButton.heightAnchor.constraint(equalToConstant: 50),
            captureButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let filterColorStackViewConstraints = [
            filterColorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterColorStackView.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -16)
        ]
        
        let redButtonConstraints = [
            redButton.heightAnchor.constraint(equalToConstant: 50),
            redButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let greenButtonConstraints = [
            greenButton.heightAnchor.constraint(equalToConstant: 50),
            greenButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let blueButtonConstraints = [
            blueButton.heightAnchor.constraint(equalToConstant: 50),
            blueButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(captureButtonConstraints)
        NSLayoutConstraint.activate(filterColorStackViewConstraints)
        NSLayoutConstraint.activate(redButtonConstraints)
        NSLayoutConstraint.activate(greenButtonConstraints)
        NSLayoutConstraint.activate(blueButtonConstraints)
    }
    
    private func setFilterButtonAction() {
        redButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        blueButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
    }
    
    private func changeActiveButton(selected: FilterColor) {
        switch(selected) {
            case .red:
                redButton.layer.borderWidth = 3
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 0
            case .green:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 3
                blueButton.layer.borderWidth = 0
            case .blue:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 3
            case .normal:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 0
        }
    }
    
    @objc private func filterButtonAction(_ button: FilterColorButton) {
        if(presenter?.selectedFilterColor == button.filterColor) {
            changeActiveButton(selected: .normal)
            presenter?.changeFilterColor(selected: .normal)
            
        } else {
            changeActiveButton(selected: button.filterColor)
            presenter?.changeFilterColor(selected: button.filterColor)
        }
    }
    
    @objc private func captureImage() {
        guard let ciimage = imagePreview.getImage() else { return }
        let context: CIContext = CIContext.init(options: nil)
        let cgImage: CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
        
        let image = UIImage(cgImage: cgImage)
        presenter?.cameraCapture?.stop()
        presenter?.showDetailImage(image: image)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.cameraCaptureWithFilter()
    }
}
