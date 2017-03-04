//
//  DebugViewController.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit

/// View Controller for Debuging
class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.loginViewButton)
        self.view.addSubview(self.cameraViewButton)
    }
    
    lazy var titleLabel: UILabel = {
        let font: UIFont = UIFont.systemFont(ofSize: 24.0)
        let frame: CGRect = CGRect(x: 0.0, y: 60.0, width: UIScreen.main.bounds.width, height: ceil(font.lineHeight))
        let label: UILabel = UILabel(frame: frame)
        label.font = font
        label.text = "Debug View Controller"
        label.textAlignment = .center
        return label
    }()
    
    lazy var loginViewButton: UIButton = {
        let frame: CGRect = CGRect(x: 0.0, y: 200.0, width: UIScreen.main.bounds.width, height: 44.0)
        let button: UIButton = UIButton(type: .system)
        button.frame = frame
        button.setTitle("Show Login View", for: .normal)
        button.addTarget(self, action: #selector(self.onLoginButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cameraViewButton: UIButton = {
        let frame: CGRect = CGRect(x: 0.0, y: 300.0, width: UIScreen.main.bounds.width, height: 44.0)
        let button: UIButton = UIButton(type: .system)
        button.frame = frame
        button.setTitle("Show Camera View", for: .normal)
        button.addTarget(self, action: #selector(self.onCameraButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Actions
    
    func onLoginButtonClicked(sender: UIButton) {
        
    }

    func onCameraButtonClicked(sender: UIButton) {
        
    }
}
