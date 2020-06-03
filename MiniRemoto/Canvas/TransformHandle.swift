//
//  TransformHandle.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 27/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

final class TransformHandle: UIView {
    
    weak var referenceView: WidgetView?
    weak var canvas: CanvasViewController?
    var corner: Corner
    
    let minHeight: CGFloat = 50
    let minWidth: CGFloat = 50
    
    init(frame: CGRect, reference: WidgetView, corner: Corner, canvas: CanvasViewController) {
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
            self.center = ref.view.frame.topLeftCorner
        case .topRight:
            self.center = ref.view.frame.topRightCorner
        case .bottomLeft:
            self.center = ref.view.frame.bottomLeftCorner
        case .bottomRight:
            self.center = ref.view.frame.bottomRightCorner
        }
    }
    
    private func updateReferenceView() {
        guard let ref = referenceView else { return }
        switch corner {
        case .topLeft:
            let newW = ref.view.frame.maxX - self.center.x
            let newH = ref.view.frame.maxY - self.center.y
            let newX = newW < minWidth ? ref.view.frame.maxX - minWidth : self.center.x
            let newY = newH < minHeight ? ref.view.frame.maxY - minHeight : self.center.y
            ref.view.frame = CGRect(minX: newX, minY: newY, maxX: ref.view.frame.maxX, maxY: ref.view.frame.maxY)
        case .topRight:
            let newW = self.center.x - ref.view.frame.minX
            let newH = ref.view.frame.maxY - self.center.y
            let newX = newW < minWidth ? ref.view.frame.minX + minWidth : self.center.x
            let newY = newH < minHeight ? ref.view.frame.maxY - minHeight : self.center.y
            ref.view.frame = CGRect(minX: ref.view.frame.minX, minY: newY, maxX: newX, maxY: ref.view.frame.maxY)

        case .bottomLeft:
            let newW = ref.view.frame.maxX - self.center.x
            let newH = self.center.y - ref.view.frame.minY
            let newX = newW < minWidth ? ref.view.frame.maxX - minWidth : self.center.x
            let newY = newH < minHeight ? ref.view.frame.minY + minHeight : self.center.y
            ref.view.frame = CGRect(minX: newX, minY: ref.view.frame.minY, maxX: ref.view.frame.maxX, maxY: newY)
        case .bottomRight:
            let newW = self.center.x - ref.view.frame.minX
            let newH = self.center.y - ref.view.frame.minY
            let newX = newW < minWidth ? ref.view.frame.minX + minWidth : self.center.x
            let newY = newH < minHeight ? ref.view.frame.minY + minHeight : self.center.y
            ref.view.frame = CGRect(minX: ref.view.frame.minX, minY: ref.view.frame.minY, maxX: newX, maxY: newY)
        }
        ref.internalFrame = ref.view.frame
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
