//
//  TransformHandle.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 27/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

final class TransformHandle: UIView {

    unowned var referenceView: WidgetView
    unowned var canvas: CanvasViewController
    var corner: Corner

    let constValue: CGFloat = 20
    
    var scale: CGFloat {
        return 1000/canvas.canvasView.frame.width
    }
    
    var size: CGSize {
        return CGSize(width: constValue + 120 * scale, height: constValue + 120 * scale)
    }
    
    var origin: CGPoint {
        var temp = referenceView.view.frame.getCornerPosition(corner)
        temp.x -= size.width/2
        temp.y -= size.height/2
        let diff: CGFloat = size.width/2.82 // to position the ring tangent to the frames corner: width/2 * √2/2 :: width/2/√2
        switch corner {
        case .topLeft:
            temp.x -= diff
            temp.y -= diff
        case .topRight:
            temp.x += diff
            temp.y -= diff
        case .bottomLeft:
            temp.x -= diff
            temp.y += diff
        case .bottomRight:
            temp.x += diff
            temp.y += diff
        }
        return temp
    }
    
    let minHeight: CGFloat = 240
    let minWidth: CGFloat = 240
    
    init(reference: WidgetView, corner: Corner, canvas: CanvasViewController) {
        self.referenceView = reference
        self.corner = corner
        self.canvas = canvas
        super.init(frame: .zero)
        self.frame = CGRect(origin: origin, size: size)
        self.backgroundColor = .clear
    }
    
    static func makeTransformHandles(on view: WidgetView, handlesArray: inout [TransformHandle], canvas: CanvasViewController) {
        for c in Corner.allCases {
            let handleView = TransformHandle(reference: view, corner: c, canvas: canvas)
            handleView.addGestureRecognizer(UIPanGestureRecognizer(target: handleView, action: #selector(handleView.dragHandle(_:))))
            handlesArray.append(handleView)
            canvas.canvasView.addSubview(handleView)
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.frame = CGRect(origin: origin, size: size)
        let path = UIBezierPath()
        
        // main color ring
        UIColor.dotdMain.setStroke()
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let width: CGFloat = constValue/2 + 32.0 * scale
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
        self.center = sender.location(in: canvas.canvasView)
        updateReferenceView()
    }
    
    public func updatePosition() {
        switch corner {
        case .topLeft:
            self.center = referenceView.view.frame.topLeftCorner
        case .topRight:
            self.center = referenceView.view.frame.topRightCorner
        case .bottomLeft:
            self.center = referenceView.view.frame.bottomLeftCorner
        case .bottomRight:
            self.center = referenceView.view.frame.bottomRightCorner
        }
        canvas.deleteButton?.updatePosition()
        self.setNeedsDisplay()
    }
    
    private func updateReferenceView() {
        switch corner {
        case .topLeft:
            let newW = referenceView.view.frame.maxX - self.center.x
            let newH = referenceView.view.frame.maxY - self.center.y
            let newX = newW < minWidth ? referenceView.view.frame.maxX - minWidth : self.center.x
            let newY = newH < minHeight ? referenceView.view.frame.maxY - minHeight : self.center.y
            referenceView.view.frame = CGRect(minX: newX, minY: newY, maxX: referenceView.view.frame.maxX, maxY: referenceView.view.frame.maxY)
        case .topRight:
            let newW = self.center.x - referenceView.view.frame.minX
            let newH = referenceView.view.frame.maxY - self.center.y
            let newX = newW < minWidth ? referenceView.view.frame.minX + minWidth : self.center.x
            let newY = newH < minHeight ? referenceView.view.frame.maxY - minHeight : self.center.y
            referenceView.view.frame = CGRect(minX: referenceView.view.frame.minX, minY: newY, maxX: newX, maxY: referenceView.view.frame.maxY)
        case .bottomLeft:
            let newW = referenceView.view.frame.maxX - self.center.x
            let newH = self.center.y - referenceView.view.frame.minY
            let newX = newW < minWidth ? referenceView.view.frame.maxX - minWidth : self.center.x
            let newY = newH < minHeight ? referenceView.view.frame.minY + minHeight : self.center.y
            referenceView.view.frame = CGRect(minX: newX, minY: referenceView.view.frame.minY, maxX: referenceView.view.frame.maxX, maxY: newY)
        case .bottomRight:
            let newW = self.center.x - referenceView.view.frame.minX
            let newH = self.center.y - referenceView.view.frame.minY
            let newX = newW < minWidth ? referenceView.view.frame.minX + minWidth : self.center.x
            let newY = newH < minHeight ? referenceView.view.frame.minY + minHeight : self.center.y
            referenceView.view.frame = CGRect(minX: referenceView.view.frame.minX, minY: referenceView.view.frame.minY, maxX: newX, maxY: newY)
        }
        referenceView.internalFrame = referenceView.view.frame
        canvas.updateTransformHandles()
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
