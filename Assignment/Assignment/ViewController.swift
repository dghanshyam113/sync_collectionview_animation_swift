//
//  ViewController.swift
//  Assignment
//
//  Created by Admin on 22/01/21.
//  Copyright © 2021 Ghanshyam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backCollectionView: UICollectionView!
    
    var frontImages = [UIImage]()
    var backImages = [UIImage]()
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...9 {
            frontImages.append(UIImage(named: "\(i)_front")!)
            backImages.append(UIImage(named: "\(i)_bg")!)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if backCollectionView == collectionView {
            return backImages.count
        } else {
            return frontImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if backCollectionView == collectionView {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackImageCollectionViewCell", for: indexPath) as! BackImageCollectionViewCell
            cell.image.image = backImages[indexPath.row]
            return cell

        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrontImageCollectionViewCell", for: indexPath) as! FrontImageCollectionViewCell
            cell.image.image = frontImages[indexPath.row]
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if backCollectionView == collectionView {
            return CGSize(width: backCollectionView.frame.width, height: backCollectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width * 0.7, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let width:CGFloat = collectionView.frame.width
        let margin = width * 0.3
        
        if backCollectionView == collectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: margin / 2, bottom: 0, right: margin / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if backCollectionView == collectionView {
            return 0
        } else {
            return 20
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(collectionView) {
            
            var offset = backCollectionView.contentOffset
            offset.x = CGFloat.rounded(collectionView.contentOffset.x * 1.335)()
            
            if scrollView.isDecelerating {
                
                let calibration = collectionView.frame.width * CGFloat(frontImages.count - 1) - 100
                
                if offset.x > calibration {
                    offset.x = collectionView.frame.width * CGFloat(frontImages.count - 1)
                } else {
                    offset.x = collectionView.frame.width * CGFloat(currentPage)
                }
            }
            
            backCollectionView.setContentOffset(offset, animated: false)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView.isEqual(collectionView) {
         
            let pageWidth = Float(collectionView.frame.width * 0.7 + 20)

            let targetXContentOffset = Float(targetContentOffset.pointee.x)

            let contentWidth = Float(collectionView!.contentSize.width  )

            var newPage = Float(self.currentPage)

            if velocity.x == 0 {

                newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0

            } else {

                newPage = Float(velocity.x > 0 ? self.currentPage + 1 : self.currentPage - 1)

                if newPage < 0 {
                    newPage = 0
                }

                if (newPage > contentWidth / pageWidth) {
                    newPage = ceil(contentWidth / pageWidth) - 1.0
                }
            }

            self.currentPage = Int(newPage)

            let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)

            targetContentOffset.pointee = point
        }
    }
}












