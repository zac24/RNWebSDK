//
//  MFLibViewController.swift
//  RNWebSDK
//
//  Created by Prashant Dwivedi on 03/12/20.
//  Copyright © 2020 Prashant Dwivedi. All rights reserved.
//

import Foundation
import UIKit

public class MFLibViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    public static func appendString(str:String) -> String {
        return "Hello" + str
    }
    
    public static func openNativeCamera() {
        
        print("Inside Open Camera")
        let vc = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        }else {
            vc.sourceType = .photoLibrary
        }
        
        vc.allowsEditing = true
        let weakSelf = MFLibViewController()
        vc.delegate = weakSelf
        weakSelf.present(vc, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        
    }
    
}
