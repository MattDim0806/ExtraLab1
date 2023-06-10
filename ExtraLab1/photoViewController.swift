//
//  photoViewController.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/30.
//

import UIKit
class photoViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var initialPhotoNumber : Int = 0
    var myData : placeModel?
    var photoArray : [UIImage] = []
    var photoArrayIndex : [Int] = []
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        index = photoArrayIndex.firstIndex(of: initialPhotoNumber)!
        navigationItem.title = String(format: "%d/%d", initialPhotoNumber+1, photoArray.count)
        imgView.image = photoArray[index]
        
        // Add gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let threshold: CGFloat = 50 // minimum horizontal swipe distance to trigger action
        if gesture.state == .ended {
            if translation.x > threshold { // Swipe right
                showPreviousImage()
            } else if translation.x < -threshold { // Swipe left
                showNextImage()
            }
        }
    }
    
    func showPreviousImage() {
        if initialPhotoNumber > 0 {
            initialPhotoNumber-=1
            index = photoArrayIndex.firstIndex(of: initialPhotoNumber)!
            imgView.image = photoArray[index]
            navigationItem.title = String(format: "%d/%d", initialPhotoNumber+1, photoArray.count)
        }
    }
    
    func showNextImage() {
        if initialPhotoNumber < photoArray.count - 1 {
            initialPhotoNumber+=1
            index = photoArrayIndex.firstIndex(of: initialPhotoNumber)!
            imgView.image = photoArray[index]
            navigationItem.title = String(format: "%d/%d", initialPhotoNumber+1, photoArray.count)
        }
        
    }
    
}
