//
//  UsageTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class UsageTableViewCell: UITableViewCell {

    static let height:CGFloat = 75
    
    @IBOutlet weak var getCouponBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getCouponBtn.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func getCoupon(_ sender: Any) {
        
    }
    
    class func getHeight() -> CGFloat{
        return height
    }

}


class infoTableViewCell: UITableViewCell {
    static let height:CGFloat = 45
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var websiteURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    class func getHeight() -> CGFloat{
        return height
    }
    
    func setInfoCell(icon:UIImage, content:String){
        self.icon.image = icon
        self.websiteURL.text = content
    }
}

class offerTableViewCell:UITableViewCell{
    static let height:CGFloat = 75
    
    @IBOutlet weak var offerText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    class func getHeight() -> CGFloat{
        return height
    }
    
    func setOfferDetail(detail:String){
        self.offerText.text = detail
        self.setNeedsLayout()
    }
}

class imagesTableViewCell:UITableViewCell{
    
    let itemInRow: CGFloat = 3
    let itemMargins: CGFloat = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        let itemWidth = self.collectionView.frame.size.width/3.05
        layout.sectionInset = UIEdgeInsets.init(top: itemMargins, left: itemMargins, bottom: itemMargins, right: 0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        self.collectionView.collectionViewLayout = layout
    }
    
    func setCollectionDelegate(delegate: UICollectionViewDelegate, datasource: UICollectionViewDataSource){
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = datasource
    }
    
    func getHeight() -> CGFloat{
        return self.frame.width
    }
    
}

class imageCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImage(image:UIImage){
        self.thumbnail.image = image
        self.setNeedsLayout()
    }
}

