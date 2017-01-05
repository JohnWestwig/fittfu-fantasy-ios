//
//  PlayerStatsLayout.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/4/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class PlayerStatsLayout: UICollectionViewLayout {
    
    var itemSize: CGSize!
    var interItemSpacingY: CGFloat!
    var interItemSpacingX: CGFloat!
    var layoutInfo: Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        itemSize = CGSize(width: 100.0, height: 62.0)
        interItemSpacingY = 0.0
        interItemSpacingX = 0.0
    }
    
    override func prepare() {
        var cellLayoutInfo = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
        
        let sectionCount = self.collectionView?.numberOfSections
        var indexPath: IndexPath!
        
        for section in 0 ..< sectionCount! {
            let itemCount = self.collectionView?.numberOfItems(inSection: section)
            
            for item in 0 ..< itemCount! {
                indexPath = IndexPath(item: item, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForCellAtIndexPath(indexPath: indexPath as NSIndexPath)
                if (item == 0) {
                    itemAttributes.zIndex += 1
                }
                if (section == 0) {
                    itemAttributes.zIndex += 1
                }
                cellLayoutInfo[indexPath as NSIndexPath] = itemAttributes
            }
            
            self.layoutInfo = cellLayoutInfo
        }
        
        
    }
    
    func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        let row = indexPath.section
        let column = indexPath.item

        let originX = (column == 0) ? self.collectionView!.contentOffset.x : (self.itemSize.width + self.interItemSpacingX) * CGFloat(column)
        let originY = (row == 0) ? self.collectionView!.contentOffset.y : (self.itemSize.height + self.interItemSpacingY) * CGFloat(row)
        
        return CGRect(x: originX, y: originY, width: self.itemSize.width, height: self.itemSize.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var allAttributes = Array<UICollectionViewLayoutAttributes>()
        
        if (layoutInfo != nil) {
            for (_, attributes) in self.layoutInfo {
                if (rect.intersects(attributes.frame)){
                    allAttributes.append(attributes)
                }
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutInfo[indexPath as NSIndexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override var collectionViewContentSize: CGSize {
        let numSections = self.collectionView?.numberOfSections
        let height:CGFloat = (self.itemSize.height + self.interItemSpacingY) * CGFloat((self.collectionView?.numberOfSections)!)
        let width:CGFloat = (numSections == 0) ? 0 : (self.itemSize.width + self.interItemSpacingX) * CGFloat((self.collectionView?.numberOfItems(inSection: 0))!)
        return CGSize(width: width, height: height)
    }
}
