//
//  ViewController.swift
//  Image Filters Practice
//
//  Created by Asaph Yuan on 9/26/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addFilter()
    }
    
    func addFilter() {
        
        // filter with GPU instead of CPU
        let openGLContext = EAGLContext(api: .openGLES3)
        if let openGLContext = openGLContext {
            
            let context = CIContext(eaglContext: openGLContext)
            
            // ensures that imageView image is not nil
            guard let image = imageView?.image, let cgimg = image.cgImage else {
                print("imageView doesn't have an image!")
                return
            }
            
            // converts UIImage to CIImage
            let coreImage = CIImage(cgImage: cgimg)
            
            // create new "CISepiaTone" filter
            let filter = CIFilter(name: "CIColorInvert")
            
            // sets input image
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            
            // using kCIInputIntensityKey or kCIInputEVKey for certain filters will cause the app to crash
            // sets intensity
            // filter?.setValue(0.5, forKey: kCIInputIntensityKey)
            // filter?.setValue(1, forKey: kCIInputEVKey)
            
            // makes call to filter image
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = context.createCGImage(output, from: output.extent)
                if let result = cgimgresult {
                    let finishedImage = UIImage(cgImage: result)
                    imageView?.image = finishedImage
                }
            } else {
                print("image filtering failed")
            }
        }
    }
}

