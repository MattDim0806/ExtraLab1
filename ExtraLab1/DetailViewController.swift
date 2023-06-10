//
//  DetailViewController.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var subTitleTxtLabel: UILabel!
    @IBOutlet weak var titleTxtLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myData : placeModel?
    var titleTxt : String = "00"
    var myDataNumber : Int = 0
    var photoArray : [UIImage] = []
    var photoArrayIndex : [Int] = []
    var doneDownloadCount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細資訊"
        titleTxtLabel.text = titleTxt
        for number in 0..<(myData?.results.content.count ?? 0){
            let content = myData?.results.content[number]
            if(content?.name == titleTxt){
                myDataNumber = number
                setSubTitle(myDataNumber : myDataNumber)
                setPhoto(myDataNumber : myDataNumber)
                setStar(myDataNumber : myDataNumber)
                countLabel.text = String(format: "景觀圖(%d)", myData?.results.content[myDataNumber].landscape.count ?? 1)
            }
        }
        collectionViewInit()
        photoArray = []
        photoArrayIndex = []
        doneDownloadCount = 0
    }
    
    func setStar(myDataNumber:Int){
        let basicColor = UIColor(rgb: 0xC6C6C8)
        star1.tintColor = basicColor
        star2.tintColor = basicColor
        star3.tintColor = basicColor
        star4.tintColor = basicColor
        star5.tintColor = basicColor
        let color = UIColor(rgb: 0xECC733)
        switch myData?.results.content[myDataNumber].star{
        case 1:
            star1.tintColor = color
        case 2:
            star1.tintColor = color
            star2.tintColor = color
        case 3:
            star1.tintColor = color
            star2.tintColor = color
            star3.tintColor = color
        case 4:
            star1.tintColor = color
            star2.tintColor = color
            star3.tintColor = color
            star4.tintColor = color
        case 5:
            star1.tintColor = color
            star2.tintColor = color
            star3.tintColor = color
            star4.tintColor = color
            star5.tintColor = color
        default:
            print("error")
        }
    }
    func setSubTitle(myDataNumber:Int){
        subTitleTxtLabel.text = myData?.results.content[myDataNumber].vicinity
    }
    
    func setPhoto(myDataNumber:Int){
        let imageUrl : String = (myData?.results.content[myDataNumber].photo)!
        let url = URL(string:imageUrl)
        URLSession.shared.dataTask(with: url!) { data, response, error in
               if let data,
                  let image = UIImage(data: data) {
                  DispatchQueue.main.async {
                      self.photoImgView.image = image
                      
                  }
               }
        }.resume()
        doneDownloadCount += 1
    }
    
    func collectionViewInit(){
        let cellNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "cell")
    }
    
    
}

extension DetailViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section : Int) -> Int {
        return myData?.results.content[myDataNumber].landscape.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let imageUrl : String = (myData?.results.content[myDataNumber].landscape[indexPath.row])!
        let url = URL(string:imageUrl)
        URLSession.shared.dataTask(with: url!) { data, response, error in
               if let data,
                let image = UIImage(data: data) {
                  DispatchQueue.main.async {
                      cell.setCell(imageName: image)
                      self.photoArray.append(image)
                      self.photoArrayIndex.append(indexPath.row)
                      self.doneDownloadCount += 1
                  }
               }
        }.resume()
        return cell
    }
    
  
}

extension DetailViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath : IndexPath){
        if(doneDownloadCount == myData?.results.content[myDataNumber].landscape.count){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let VC = storyboard.instantiateViewController(withIdentifier: "photoViewController") as? photoViewController else { return }
            VC.photoArray = photoArray
            VC.photoArrayIndex = photoArrayIndex
            VC.initialPhotoNumber = indexPath.item
            print("indexPath.item")
            print(indexPath.item)
            print("photoArray.count")
            print(photoArray.count)
            navigationController?.pushViewController(VC, animated: true)
        }else{
            view.makeToast("請等圖片下載完再點擊～")
        }
        
    }

}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
