//
//  ViewController.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/19.
//

import UIKit
import MapKit

class placeModel :Codable{
    var results : results
}
class results :Codable{
    var content : [content]
}
class content :Codable{
    var lat : Double
    var lng : Double
    var name : String
    var vicinity : String
    var photo : String
    var landscape : [String]
    var star : Int
}




class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    //設定類別
    var myData : placeModel?
    var placeClosure : ((String) -> ())?
    var placeLabel : String = "00"
    @IBOutlet weak var mapView: MKMapView!
    static var location:CLLocationManager? = nil

    @IBAction func refreshBtnClick(_ sender: Any) {
        if(ViewController.location == nil){
            ViewController.location = CLLocationManager()
            ViewController.location?.requestWhenInUseAuthorization()
            ViewController.location?.startUpdatingLocation()
        }
        else{
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            print(mapView.userLocation.coordinate)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
    }
    
    
    
    func setToSelectCell(lat: Double, lng:Double){
        let Coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: Coordinate, span: span)
        print(String(format: "lat: %.2f, lng: %.2f", lat, lng))
        mapView.setRegion(region, animated: true)
    }
    
    func getDataFromAPI(){
        let usrString = "https://android-quiz-29a4c.web.app/"
        //let usrString = String(format: "https://android-quiz-29a4c.web.app/?%@", searchBar.text!)
        let url = URL(string: usrString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if(error != nil){
                print("發送失敗",error!.localizedDescription)
            }
            else{
                print("發送成功")
                DispatchQueue.main.async{
                    do{
                        self.myData = try! JSONDecoder().decode(placeModel.self, from: data!)
                        self.addAnnotation()
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
    
    //放置標註
    func addAnnotation(){
        for number in 0..<(myData?.results.content.count ?? 0) {
            let annotation = MKPointAnnotation()
            let lat = myData?.results.content[number].lat ?? 0.0
            let lng = myData?.results.content[number].lng ?? 0.0
            let name = myData?.results.content[number].name ?? ""
            let latLng = CLLocationCoordinate2DMake(lat, lng)
            annotation.coordinate = latLng
            annotation.title = name
            mapView.addAnnotation(annotation)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func searchBtnClick(_ sender: Any) {
        var hasResult = false
        let VC = searchPopUpViewController()
        VC.delegate = self
        VC.myData = myData
        VC.searchBarText = searchBar.text ?? ""
        let searchBarLowercased = searchBar.text?.lowercased() ?? ""
        for content in myData?.results.content ?? [] {
            if content.name.lowercased().contains(searchBarLowercased) || content.vicinity.lowercased().contains(searchBarLowercased) {
                hasResult = true
                break
            }
        }
        if hasResult {
            VC.showInVC(VC: self)
        }
        else{
            view.makeToast("查無結果")
        }
    }
    
    @IBAction func historyBtnClick(_ sender: Any) {
        if(historyIndexes == []){
            view.makeToast("無歷史記錄")
        }
        else{
            let VC = searchHistoryViewController()
            VC.delegate = self
            VC.myData = myData
            VC.showInVC(VC: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.myData = myData
            }
        }
    }

}

extension ViewController:searchPopUpViewControllerDelegate{
    func setNewPlace() {
        setToSelectCell(lat: lat, lng: lng)
    }
}

extension ViewController:searchHistoryViewControllerDelegate{
    func setNewPlace2() {
        setToSelectCell(lat: lat, lng: lng)
    }
    func makeToast() {
        view.makeToast("已清除記錄")
    }
}

extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            lat = annotation.coordinate.latitude
            lng = annotation.coordinate.longitude
            placeLabel = annotation.title!!
            print(placeLabel)
        }
        let VC = annotationPopUpViewController()
        VC.titleTxt = placeLabel
        VC.myData = myData
        VC.showInVC(VC: self)
        VC.delegate = self
    }
}

extension ViewController:annotationPopUpViewControllerDelegate{
    func showDetailVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let VC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        VC.titleTxt = placeLabel
        VC.myData = myData
        navigationController?.pushViewController(VC, animated: true)
    }
}
