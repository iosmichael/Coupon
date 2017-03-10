//
//  CategoryTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/8/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let height: CGFloat = 70

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }
    
    private func configure(){
        self.collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "category")
        let layout = UICollectionViewFlowLayout()
        let itemWidth = 70
        let itemHeight = 65
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.collectionView.collectionViewLayout = layout
    }
    
    func setDelegate(delegate:UICollectionViewDelegate, datasource:UICollectionViewDataSource){
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = datasource
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getHeight() -> CGFloat{
        return height
    }
}
