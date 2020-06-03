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
    
    let minHeight: CGFloat = 60
    let minWidth: CGFloat = 60
    
    init(reference: WidgetView, corner: Corner, canvas: CanvasViewController) {
        self.referenceView = reference
        self.corner = corner
        self.canvas = canvas
        let size = CGSize(width: 40, height: 40)
        var origin = reference.view.frame.getCornerPosition(corner)
        origin.x -= size.width/2
        origin.y -= size.height/2
        let frame = CGRect(origin: origin, size: size)
        super.init(frame: frame)
        
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
        let path = UIBezierPath()
        
        // main color ring
        UIColor.dotdMain.setStroke()
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
            self.center = ref.view.frame.topLeftCorner
        case .topRight:
            self.center = ref.view.frame.topRightCorner
        case .bottomLeft:
            self.center = ref.view.frame.bottomLeftCorner
        case .bottomRight:
            self.center = ref.view.frame.bottomRightCorner
        }
        self.setNeedsDisplay()
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
