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
    
    let minHeight: CGFloat = 60
    let minWidth: CGFloat = 60
    
    init(reference: UIView, corner: Corner, canvas: CanvasViewController) {
        self.referenceView = reference
        self.corner = corner
        self.canvas = canvas
        let size = CGSize(width: 40, height: 40)
        var origin = reference.frame.getCornerPosition(corner)
        origin.x -= size.width/2
        origin.y -= size.height/2
        let frame = CGRect(origin: origin, size: size)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    static func makeTransformHandles(on view: UIView, handlesArray: inout [TransformHandle], canvas: CanvasViewController) {
        for c in Corner.allCases {
            let handleView = TransformHandle(reference: view, corner: c, canvas: canvas)
            handleView.addGestureRecognizer(UIPanGestureRecognizer(target: handleView, action: #selector(handleView.dragHandle(_:))))
            handlesArray.append(handleView)
            canvas.canvasView.addSubview(handleView)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // main color ring
        UIColor.main.setStroke()
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let width: CGFloat = 12.0
        let radius = max(rect.width/2, rect.height/2) - width/2
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.lineWidth = width
        path.stroke()
        
        // slimmer white ring on top
        UIColor.white.setStroke()
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.lineWidth = width/2
        path.stroke()
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
        self.setNeedsDisplay()
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
