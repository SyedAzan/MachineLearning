//
//  ViewController.swift
//  MachineLearning
//
//  Created by Syed Azan on 15/02/2020.
//  Copyright © 2020 Syed Azan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    
    
    var classificationResults: [VNClassificationObservation] = []
    
    @IBAction func BarCameraButton(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            guard let CiImage = CIImage(image: image) else{
                fatalError("Cannot convert image into CiImage")
            }
            
            
            detect(img: CiImage)
        }

            
        }
    //MARK: - detect type of images
    func detect(img : CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Error creating a model")
            
        }
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let result = req.results as? [VNClassificationObservation],
                let topresult = result.first
                    else{
                        fatalError("Error getting result")
                    }
                    DispatchQueue.main.async {
                    self.navigationItem.title = topresult.identifier

                    }
                    
                }
            
            
        
        let handler = VNImageRequestHandler(ciImage: img)
        do{
            try? handler.perform([request])
        }catch{
            print("Error handling image")
        }
            
        }
        
    }

        
        
    



