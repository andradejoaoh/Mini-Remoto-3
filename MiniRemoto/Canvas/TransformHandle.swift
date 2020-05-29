//
//  TransformHandle.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 27/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

final class TransformHandle: UIView {
    
    weak var referenceView: UIView?
    weak var canvas: CanvasViewController?
    var corner: Corner
    
    let minHeight: CGFloat = 50
    let minWidth: CGFloat = 50
    
    init(frame: CGRect, reference: UIView, corner: Corner, canvas: CanvasViewController) {
        self.referenceView = reference
        self.corner = corner
        self.canvas = canvas
        super.init(frame: frame)
    }
    
    @objc
    public func dragHandle(_ sender: UIPanGestureRecognizer) {
        self.center = sender.location(in: canvas?.canvasView)
        updateReferenceView()
    }
    
    public func updatePosition() {
        guard let ref = referenceView else { removeFromSuperview(); return }
        switch corner {
        case .topLeft:
            self.center = ref.frame.topLeftCorner
        case .topRight:
            self.center = ref.frame.topRightCorner
        case .bottomLeft:
            self.center = ref.frame.bottomLeftCorner
        case .bottomRight:
            self.center = ref.frame.bottomRightCorner
        }
    }
    
    private func updateReferenceView() {
        guard let ref = referenceView else { return }
        switch corner {
        case .topLeft:
            let newW = ref.frame.maxX - self.center.x
            let newH = ref.frame.maxY - self.center.y
            let newX = newW < minWidth ? ref.frame.maxX - minWidth : self.center.x
            let newY = newH < minHeight ? ref.frame.maxY - minHeight : self.center.y
            ref.frame = CGRect(minX: newX, minY: newY, maxX: ref.frame.maxX, maxY: ref.frame.maxY)
        case .topRight:
            let newW = self.center.x - ref.frame.minX
            let newH = ref.frame.maxY - self.center.y
            let newX = newW < minWidth ? ref.frame.minX + minWidth : self.center.x
            let newY = newH < minHeight ? ref.frame.maxY - minHeight : self.center.y
            ref.frame = CGRect(minX: ref.frame.minX, minY: newY, maxX: newX, maxY: ref.frame.maxY)
        case .bottomLeft:
            let newW = ref.frame.maxX - self.center.x
            let newH = self.center.y - ref.frame.minY
            let newX = newW < minWidth ? ref.frame.maxX - minWidth : self.center.x
            let newY = newH < minHeight ? ref.frame.minY + minHeight : self.center.y
            ref.frame = CGRect(minX: newX, minY: ref.frame.minY, maxX: ref.frame.maxX, maxY: newY)
        case .bottomRight:
            let newW = self.center.x - ref.frame.minX
            let newH = self.center.y - ref.frame.minY
            let newX = newW < minWidth ? ref.frame.minX + minWidth : self.center.x
            let newY = newH < minHeight ? ref.frame.minY + minHeight : self.center.y
            ref.frame = CGRect(minX: ref.frame.minX, minY: ref.frame.minY, maxX: newX, maxY: newY)
        }
        canvas?.updateTransformHandles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Corner: CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
