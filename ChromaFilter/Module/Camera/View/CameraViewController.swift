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
import AVFoundation


protocol CameraViewProtocol {
    var presenter: CameraPresenterProtocol? { get set }
}

class CameraViewController: UIViewController, CameraViewProtocol {
    var presenter: CameraPresenterProtocol?
    private var cancelable = Set<AnyCancellable>()
   
    
    private let redButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .red
        button.layer.cornerRadius = 30
        button.layer.backgroundColor = UIColor.red.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let greenButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .green
        button.layer.cornerRadius = 30
        button.layer.backgroundColor = UIColor.green.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let blueButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .blue
        button.layer.cornerRadius = 30
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let customButton: FilterColorButton = {
        let button = FilterColorButton()
        button.filterColor = .custom
        button.setImage(UIImage(systemName: "camera.filters"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 30
        button.layer.backgroundColor = UIColor.darkGray.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let captureButton: UIButton = {
        let button = FilterColorButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.filterColor = .custom
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.imageView?.layer.borderColor = UIColor.black.cgColor
        button.imageView?.layer.borderWidth = 1
        button.imageView?.clipsToBounds = true
        button.imageView?.layer.cornerRadius = 30
        button.tintColor = .white
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        
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
    
    private var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        
        return view
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

        filterColorStackView.addArrangedSubview(redButton)
        filterColorStackView.addArrangedSubview(greenButton)
        filterColorStackView.addArrangedSubview(blueButton)
        filterColorStackView.addArrangedSubview(customButton)
        
        view.addSubview(bottomView)
        bottomView.addSubview(filterColorStackView)
        bottomView.addSubview(captureButton)
        
        let captureButtonConstraints = [
            captureButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -32),
            captureButton.heightAnchor.constraint(equalToConstant: 60),
            captureButton.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        let filterColorStackViewConstraints = [
            filterColorStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            filterColorStackView.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -16)
        ]
        
        let redButtonConstraints = [
            redButton.heightAnchor.constraint(equalToConstant: 60),
            redButton.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        let greenButtonConstraints = [
            greenButton.heightAnchor.constraint(equalToConstant: 60),
            greenButton.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        let blueButtonConstraints = [
            blueButton.heightAnchor.constraint(equalToConstant: 60),
            blueButton.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        let customButtonConstraints = [
            customButton.heightAnchor.constraint(equalToConstant: 60),
            customButton.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        let bottomStackViewConstraints = [
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        NSLayoutConstraint.activate(captureButtonConstraints)
        NSLayoutConstraint.activate(filterColorStackViewConstraints)
        NSLayoutConstraint.activate(redButtonConstraints)
        NSLayoutConstraint.activate(greenButtonConstraints)
        NSLayoutConstraint.activate(blueButtonConstraints)
        NSLayoutConstraint.activate(customButtonConstraints)
        NSLayoutConstraint.activate(bottomStackViewConstraints)
    }
    
    private func setFilterButtonAction() {
        redButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        blueButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        customButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
    }
    
    private func selectCustomFilterColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.isModalInPresentation = false
        present(colorPickerVC, animated: true)
    }
    
    private func changeActiveButton(selected: FilterColor) {
        switch(selected) {
            case .red:
                redButton.layer.borderWidth = 3
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 0
                customButton.layer.borderWidth = 0
            case .green:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 3
                blueButton.layer.borderWidth = 0
                customButton.layer.borderWidth = 0
            case .blue:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 3
                customButton.layer.borderWidth = 0
            case .normal:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 0
                customButton.layer.borderWidth = 0
            case .custom:
                redButton.layer.borderWidth = 0
                greenButton.layer.borderWidth = 0
                blueButton.layer.borderWidth = 0
                customButton.layer.borderWidth = 3
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            //request permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.presenter?.cameraCaptureWithFilter()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            presenter?.cameraCaptureWithFilter()
        @unknown default:
            break
        }
    }
    
    @objc private func filterButtonAction(_ button: FilterColorButton) {
        if(presenter?.selectedFilterColor == button.filterColor) {
            changeActiveButton(selected: .normal)
            presenter?.changeFilterColor(selected: .normal)
            
        } else {
            changeActiveButton(selected: button.filterColor)
            presenter?.changeFilterColor(selected: button.filterColor)
            if button.filterColor == .custom {
                selectCustomFilterColor()
            }
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
//        checkCameraPermission()
    }
}

extension CameraViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
    }
}
