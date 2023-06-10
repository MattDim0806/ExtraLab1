//
//  annotationPopUpViewController.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/26.
//

import UIKit
import MapKit

class annotationPopUpViewController: UIViewController {

    @IBOutlet weak var placeLabelBtn: UIButton!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var radiusView1: UIView!
    @IBOutlet weak var radiusView2: UIView!
    

    var myData : placeModel?
    var titleTxt : String = "沒改"
    weak var delegate : annotationPopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        placeLabelBtn.setTitle(titleTxt, for: .normal)
        normalView.layer.cornerRadius = 10
        radiusView1.layer.cornerRadius = 10
        radiusView2.layer.cornerRadius = 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeLabelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .ended {
            dismissViewController()
        }
    }

    @IBAction func titleBtnClick(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func houseBtn(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController
        navigationController?.pushViewController(VC, animated: false)
        delegate? .showDetailVC()
        dismissViewController()
    }
    
    @IBAction func mapBtn(_ sender: Any) {
        let targetLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let targetPlacemark=MKPlacemark(coordinate: targetLocation)
        let targetItem=MKMapItem(placemark: targetPlacemark)
        let userMapItem=MKMapItem.forCurrentLocation()
        let routes=[userMapItem,targetItem]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func showInVC(VC:UIViewController){
        self.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        VC.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false)
    }
    
    func dismissViewController(){
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}

@objc protocol annotationPopUpViewControllerDelegate{
    func showDetailVC()
}
