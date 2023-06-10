//
//  searchHistoryViewController.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/24.
//

import UIKit

class searchHistoryViewController: UIViewController {

    @IBOutlet weak var normalView: UIView!
    @IBOutlet var TGR: UITapGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    
    var myData : placeModel?
    weak var delegate:searchHistoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        normalView.layer.cornerRadius = 10
        tableViewInit()
        tableView.reloadData()
        TGR.cancelsTouchesInView = false
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func clearBtnClick(_ sender: Any) {
        historyIndexes = []
        dismissViewController()
        delegate? .makeToast?()

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
    
    func dismissViewController(){
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    func tableViewInit(){
        let cellNIB2 = UINib(nibName: "tableViewCell", bundle: nil)
        tableView.register(cellNIB2, forCellReuseIdentifier: "cell")
    }
}

extension searchHistoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        
        return historyIndexes.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        // 取得符合搜尋結果的內容的index
        let historyIndex = historyIndexes[indexPath.row]
        guard let content = myData?.results.content[historyIndex] else {
            return cell
        }
        cell.nameLabel.text = content.name
        cell.vicinityLabel.text = content.vicinity
        return cell
    }
}


extension searchHistoryViewController:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyIndex = historyIndexes[indexPath.row]
        lat = myData?.results.content[historyIndex].lat ?? 0.0
        lng = myData?.results.content[historyIndex].lng ?? 0.0
        dismissViewController()
        delegate? .setNewPlace2()
    }
}


@objc protocol searchHistoryViewControllerDelegate{
    func setNewPlace2()
    @objc optional func makeToast()
}
