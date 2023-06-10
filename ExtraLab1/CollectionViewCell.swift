//
//  CollectionViewCell.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/29.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(imageName : UIImage){
        imageView.image = imageName

    }
}

