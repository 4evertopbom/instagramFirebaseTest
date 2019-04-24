//
//  CameraController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/15/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let dismissButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let capturePhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto(){
    
    }
    
    @objc func handleDismiss(){
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
        capturePhotoButton.anchor(top: nil, paddingtop: 0, left: nil, paddingleft: 0, right: nil, paddingright: 0, bot: view.bottomAnchor, botpadding: 24, height: 80, width: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.anchor(top: view.topAnchor, paddingtop: 12, left: nil, paddingleft: 0, right: view.rightAnchor, paddingright: 12, bot: nil, botpadding: 0, height: 50, width: 50)
    }
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        
        //1. Set up Input
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not set up camera:", err)
        }
        //2. Set up Output
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //3. Set up Output view
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}
