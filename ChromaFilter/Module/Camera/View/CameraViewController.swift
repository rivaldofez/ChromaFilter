//
//  CameraViewController.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import UIKit

class CameraViewController: UIViewController {

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureConstraints()
    }
    
    private func configureConstraints() {
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
}
