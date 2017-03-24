//
//  BannerScrollView.swift
//  CouponApp
//
//  Created by Michael Liu on 3/12/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class BannerScrollView: UIScrollView, UIScrollViewDelegate, CountdownLabelDelegate{
    
    var totalPages = 0
    var bannerItems:[Item] = []
    var pageControl: UIPageControl?
    var scrollView:UIScrollView?
    var parentController: UITableViewController?
    let storage = FIRStorage.storage()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollView = UIScrollView.init(frame: frame)
        self.scrollView?.delegate = self
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y:  self.frame.size.height-20, width: self.frame.size.width, height: 20))
        pageControl?.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin , UIViewAutoresizing.flexibleLeftMargin]
        pageControl?.currentPage = 0
        self.addSubview(scrollView!)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loaded(parent:UITableViewController,banners:[Item]){
        self.bannerItems = banners
        if bannerItems.count == 0 {
            self.frame = CGRect.zero
        }
        self.parentController = parent
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        for subview in (self.scrollView?.subviews)! {
            subview.removeFromSuperview()
        }
        totalPages = 0
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedImage))
        self.addGestureRecognizer(tapRecognizer)
        DispatchQueue.global().async {
            for banner in self.bannerItems{
                if banner.bannerImg == nil{
                    banner.bannerDownloadImage = UIImage.init(named: "banner")!
                    self.addBanner(item: banner)
                }else{
                    let gsReference = self.storage.reference(withPath: "banners/"+banner.bannerImg!+".jpg")
                    gsReference.downloadURL(completion: { (url, error) in
                        if (url == nil) {
                            banner.bannerDownloadImage = UIImage.init(named:"banner")!
                            DispatchQueue.main.async {
                                self.addBanner(item:banner)
                                self.setupScrollView()
                            }
                        }else{
                            if let imgUrl = NSURL(string: (url?.absoluteString)!) {
                                if let data = NSData(contentsOf: imgUrl as URL) {
                                    let bannerImage = UIImage.init(data: data as Data!)
                                    banner.bannerDownloadImage = bannerImage
                                    DispatchQueue.main.async {
                                        self.addBanner(item:banner)
                                        self.setupScrollView()
                                    }
                                }
                            }
                        }
                    })
                }
            }
            DispatchQueue.main.async {
                self.setupScrollView()
            }
        }

    }
    
    func addBanner(item:Item){
        let imageView = UIImageView.init(frame: CGRect.init(x: CGFloat(totalPages) * self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        imageView.contentMode = .scaleToFill
        imageView.image = item.bannerDownloadImage!
        let countdown = getCountDownLabel(banner: item)
        self.scrollView?.addSubview(imageView)
        self.scrollView?.addSubview(countdown)
        totalPages += 1
    }
    
    func getCountDownLabel(banner:Item)->CountdownLabel{
        let currentDate = Date()
        let dueDate = currentDate.convertStringToDueDate(date: banner.due)
        let countdown = CountdownLabel.init(frame: CGRect.init(x: CGFloat(totalPages+1) * self.frame.size.width - 170, y: self.frame.size.height - 50, width: 170, height: 50), fromDate: currentDate, targetDate: dueDate)
        countdown.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        countdown.textColor = .white
        countdown.font = UIFont.init(name: "Avenir-Black", size: 30)
        countdown.textAlignment = .center
        countdown.countdownDelegate = self
        countdown.start()
        return countdown
    }
    
    func tappedImage(){
        openCoupon(index: (pageControl?.currentPage)!)
    }
    
    func openCoupon(index:Int){
        let item = bannerItems[index]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let couponController = storyboard.instantiateViewController(withIdentifier: "couponView") as! CouponTableViewController
        couponController.coupon = item
        parentController?.navigationController?.pushViewController(couponController, animated: true)
    }
    
    func setupScrollView(){
        pageControl?.numberOfPages = totalPages
        self.scrollView?.contentSize = CGSize.init(width: self.frame.size.width * CGFloat(totalPages), height: self.frame.size.height)
    }
    
    func changePage(){
        let pageWidth = self.frame.size.width
        if pageControl?.currentPage ==  bannerItems.count - 1 {
            pageControl?.currentPage = 0
            self.setContentOffset(CGPoint.zero, animated: true)
        }else{
            pageControl?.currentPage += 1
            let newX = (self.contentOffset.x) + pageWidth
            self.setContentOffset(CGPoint.init(x: newX, y: 0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page: Int = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth))+1
        pageControl?.currentPage = page
    }
    
    func countdownFinished() {
        var index = 0
        for item in bannerItems{
            let current = Date()
            let dueDate = current.convertStringToDueDate(date: item.due)
            if current.compare(dueDate) == ComparisonResult.orderedDescending{
                let itemManager = ItemManager()
                itemManager.deleteItem(itemId: item.uid)
                bannerItems.remove(at: index)
            }
            index += 1;
        }
        loaded(parent: parentController!, banners: bannerItems)
    }

}
