//
//  ImageTransform+Ext.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import CoreImage

extension CIImage {
    func transformToOrigin(withSize size: CGSize) -> CIImage {
        let originX = extent.origin.x
        let originY = extent.origin.y
        
        let scaleX = size.width / extent.width
        let scaleY = size.height / extent.height
        let scale = max(scaleX, scaleY)
        
        return transformed(by: CGAffineTransform(translationX: -originX, y: -originY))
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    }
}
