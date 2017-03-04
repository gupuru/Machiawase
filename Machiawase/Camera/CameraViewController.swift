//
//  CameraViewController.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(self.captureStillImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.captureStillImageView.setupCamera()
        self.captureStillImageView.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.captureStillImageView.stopSession()
    }
    
    // MARK: Elements
    
    lazy var captureStillImageView: CaptureStillImageView = {
        let view: CaptureStillImageView = CaptureStillImageView(frame: self.view.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
}
