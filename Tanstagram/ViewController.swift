//
//  ViewController.swift
//  Tanstagram
//
//  Created by Константин Клинов on 7/5/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var outletCollectionOfImages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createGestures()
        
    }

    
    @IBAction func saveToPhotoTapGesture(_ sender: UITapGestureRecognizer) {
        renderImage()
    }
    
    
    func renderImage(){
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { (goTo) in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.renderComplete), nil)
    }
    
    @objc func renderComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let alert = UIAlertController(title: "Something Went Wrong", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Photo Saved", message: "Your image has been saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated:  true)
        }
    }
    
    //Set Gestures

    func pinchGesture(imageView: UIImageView) -> UIPinchGestureRecognizer{
        return UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch))
    }
    
    func panGesture(imageView: UIImageView) -> UIPanGestureRecognizer{
        return UIPanGestureRecognizer (target: self, action: #selector(self.handlePan))
    }
    
    func rotateGesture(imageView: UIImageView) -> UIRotationGestureRecognizer {
        return UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate))
    }
    
    
    // Handle Gestures

   @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func handleRotate(sender: UIRotationGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform)!.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    // Create Gestures
    
    func createGestures(){
        for shape in outletCollectionOfImages {
            let pinch = pinchGesture(imageView: shape)
            let pan = panGesture(imageView: shape)
            let rotation = rotateGesture(imageView: shape)
            
            
            shape.addGestureRecognizer(pinch)
            shape.addGestureRecognizer(pan)
            shape.addGestureRecognizer(rotation)

            
        }
    }
    
}

