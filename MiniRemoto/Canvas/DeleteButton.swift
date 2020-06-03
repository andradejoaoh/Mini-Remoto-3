//
//  DeleteButton.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 03/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class DeleteButton: UIButton {
    
    unowned var referenceView: WidgetView
    unowned var canvas: CanvasViewController
    
    let constValue: CGFloat = 20
    
    var scale: CGFloat {
        return 1000/canvas.canvasView.frame.width
    }
    
    var size: CGSize {
        return CGSize(width: constValue + 120 * scale, height: constValue + 120 * scale)
    }
    
    var origin: CGPoint {
        return CGPoint(x: referenceView.view.frame.maxX - referenceView.view.frame.width/2 - size.width/2,
        y: referenceView.view.frame.minY - size.height * 1.2)
    }
    
    init(reference: WidgetView, canvas: CanvasViewController) {
        self.referenceView = reference
        self.canvas = canvas
        super.init(frame: .zero)
        self.frame = CGRect(origin: origin, size: size)
        self.addTarget(self, action: #selector(deleteWidget), for: .touchUpInside)
    }
    
    @objc
    func deleteWidget() {
        canvas.removeWidget(widget: referenceView)
    }
    
    override func draw(_ rect: CGRect) {
        self.frame = CGRect(origin: origin, size: size)
        let path = UIBezierPath()
        
        // red circle
        UIColor.systemRed.setFill()
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = max(rect.width/2, rect.height/2)
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.fill()
        
        // x
        path.removeAllPoints()
        UIColor.dotdBackground.setStroke()
        path.lineCapStyle = .round
        path.lineWidth = 10.0 * scale
        path.move(to: CGPoint(x: rect.width*2/6, y: rect.height*2/6))
        path.addLine(to: CGPoint(x: rect.width*4/6, y: rect.height*4/6))
        path.stroke()
        path.move(to: CGPoint(x: rect.width*4/6, y: rect.height*2/6))
        path.addLine(to: CGPoint(x: rect.width*2/6, y: rect.height*4/6))
        path.stroke()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updatePosition() {
        self.center = CGPoint(x: referenceView.view.frame.maxX - referenceView.view.frame.width/2,
                              y: referenceView.view.frame.minY - size.height * 1.2 + size.height/2)
        self.setNeedsDisplay()
    }
}
