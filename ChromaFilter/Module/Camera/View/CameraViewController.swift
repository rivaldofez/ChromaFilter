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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
