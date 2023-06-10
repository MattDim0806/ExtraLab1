//
//  searchPopUpViewController.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/20.
//

import UIKit
import Toast
import MapKit
//全域
var matchedIndexes: [Int] = []
var historyIndexes: [Int] = []
var lat : Double = 0.0
var lng : Double = 0.0
class searchPopUpViewController: UIViewController {
    
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var TGR: UITapGestureRecognizer!
    var myData : placeModel?
    var searchBarText : String = ""
    //var publicNotification : NSObjectProtocol?
    weak var delegate:searchPopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        normalView.layer.cornerRadius = 10
        tableViewInit()
        TGR.cancelsTouchesInView = false
    }
    
    func showInVC(VC:UIViewController){
        self.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        VC.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false){
            self.tableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.tableView.alpha = 0
            UITableView.animate(withDuration: 0){
                self.tableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.tableView.alpha = 1
            }
        }
    }
    

    @IBAction func dismissView(_ sender: Any) {
        print("觸發TGR")
        dismissViewController()
    }
    
    func dismissViewController(){
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    func tableViewInit(){
        let cellNIB = UINib(nibName: "tableViewCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "cell")
    }
}

extension searchPopUpViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        matchedIndexes = [] // 用來存放符合搜尋結果的內容的index
        let searchBarLowercased = searchBarText.lowercased()
        var cellCount = 0
        for number in 0..<(myData?.results.content.count ?? 0){
            let content = myData?.results.content[number]
            let nameContainsSearchText = content?.name.lowercased().contains(searchBarLowercased)
            let vicinityContainsSearchText = content?.vicinity.lowercased().contains(searchBarLowercased)
            if (nameContainsSearchText == true) || (vicinityContainsSearchText == true) {
                matchedIndexes.append(number) // 將符合搜尋結果的內容的index加入陣列
                cellCount = cellCount + 1
            }
        }
        let numberOfRows = matchedIndexes.count
        // 以matchedIndexes陣列的count作為回傳值
        print(matchedIndexes)
        print(numberOfRows)
        return numberOfRows
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        // 取得符合搜尋結果的內容的index
        let matchedIndex = matchedIndexes[indexPath.row]
        guard let content = myData?.results.content[matchedIndex] else {
            return cell
        }
        cell.nameLabel.text = content.name
        cell.vicinityLabel.text = content.vicinity
        return cell
    }
}


extension searchPopUpViewController:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TGR.isEnabled = false
        let matchedIndex = matchedIndexes[indexPath.row]
        lat = myData?.results.content[matchedIndex].lat ?? 0.0
        lng = myData?.results.content[matchedIndex].lng ?? 0.0
        dismissViewController()
        delegate? .setNewPlace()
        if (historyIndexes.contains(matchedIndexes[indexPath.row]) == false){
            historyIndexes.append(matchedIndexes[indexPath.row])
            print("historyIndexes:")
            print(historyIndexes)
        }
    }
}

@objc protocol searchPopUpViewControllerDelegate{
    func setNewPlace()
}


