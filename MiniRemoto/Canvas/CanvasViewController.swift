//
//  CanvasViewController.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    var widgets = [WidgetView]()
    
    let maxZoomOut: CGFloat = 4
    let maxZoomIn: CGFloat = 1/2
    
    var beginTouchLocation: CGPoint?
    var beginCanvasOrigin: CGPoint = CGPoint.zero
    var beginCanvasScale: CGPoint = CGPoint(x: 1, y: 1)
    var beginCanvasTransform: CGAffineTransform = CGAffineTransform()
    var beginWidgetPosition: CGPoint = CGPoint.zero
    var holdedWidget: WidgetView?
    var touchedView: UIView?
    var selectedWidgetView: UIView?
    var moved = false
    
    /// This is the drawing view that contains every other view.
    /// self.view must be static just for handling user input
    var canvasView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        canvasView = UIView(frame: self.view.frame)
        view.addSubview(canvasView)
        
        view.clipsToBounds = true
        canvasView.clipsToBounds = true
        
        canvasView.backgroundColor = UIColor(patternImage: UIImage(named: "tiled_paper_texture")!)
        canvasView.bounds = CGRect(x: canvasView.frame.origin.x, y: canvasView.frame.origin.y, width: canvasView.frame.width * maxZoomOut, height: canvasView.frame.height * maxZoomOut)
        
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:))))
        view.backgroundColor = UIColor(red: 0.8, green: 0.7, blue: 0, alpha: 0.1)
        
        let widg1 = WidgetView()
        widg1.view.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
        widg1.view.backgroundColor = .systemPink
        
        let widg2 = WidgetView()
        widg2.view.frame = CGRect(x: 200, y: 500, width: 400, height: 2000)
        widg2.view.backgroundColor = .systemBlue
        
        let widg3 = WidgetView()
        widg3.view.frame = CGRect(x: -200, y: -300, width: 300, height: 300)
        widg3.view.backgroundColor = .systemPurple
        
        addWidget(widget: widg1, to: canvasView)
        addWidget(widget: widg2, to: canvasView)
        addWidget(widget: widg3, to: canvasView)
    }
    
    func addWidget(widget: WidgetView, to view: UIView) {
        view.addSubview(widget.view)
        self.addChild(widget)
        widget.didMove(toParent: self)
        widgets.append(widget)
    }
    
    func removeWidget(widget: WidgetView) {
        widget.willMove(toParent: nil)
        widget.removeFromParent()
        widget.view.removeFromSuperview()
        widgets.removeAll { (w) -> Bool in
            widget == w
        }
    }
    
    @objc
    func zoom(_ sender : UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            beginCanvasTransform = canvasView.transform
        }
        
        let scaleResult = beginCanvasTransform.scaledBy(x: sender.scale, y: sender.scale)
        guard scaleResult.a > 1/maxZoomOut, scaleResult.d > 1/maxZoomOut else { return }
        guard scaleResult.a < 1/maxZoomIn, scaleResult.d < 1/maxZoomIn else { return }
        canvasView.transform = scaleResult
//        sender.scale = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginTouchLocation = touches.first!.location(in: view)
        touchedView = touches.first!.view
        
        if touchedView == selectedWidgetView {
            beginWidgetPosition = selectedWidgetView!.center
        } else {
            beginCanvasOrigin = canvasView.bounds.origin
        }
        moved = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let beginTouchLocation = beginTouchLocation else { print("WARNIGN: beginTouchLocation found nil"); return }
        
        let newTouchLocation = touches.first!.location(in: view)
        let diff = newTouchLocation - beginTouchLocation
        
        if selectedWidgetView == nil {
            dragCanvas(by:  diff)
        } else if touchedView == selectedWidgetView {
            moveWidget(widgetView: selectedWidgetView!, by: diff)
        } else {
            dragCanvas(by: diff)
        }
        moved = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if moved { return }
        if touchedView == canvasView {
            // clicked canvas without dragging
            selectedWidgetView?.backgroundColor = .gray
            selectedWidgetView = nil
        }
        else if touchedView != canvasView {
            // clicked widget
            selectedWidgetView = touchedView
            selectedWidgetView?.backgroundColor = .systemYellow
        }
    }
    
    // "click" is the event of touching and releasing without moving the finger
    func clickedCanvas() {
        if selectedWidgetView != nil {
            deselectWidget(widgetView: selectedWidgetView!)
        }
    }
    
    func clickedWidget(widgetView: UIView) {
        if selectedWidgetView == nil {
            selectWidget(widgetView: widgetView)
        } else if selectedWidgetView == widgetView {
            deselectWidget(widgetView: widgetView)
        } else {
            deselectWidget(widgetView: selectedWidgetView!)
            selectWidget(widgetView: widgetView)
        }
    }
    
    func selectWidget(widgetView: UIView) {
        selectedWidgetView = widgetView
    }
    
    func deselectWidget(widgetView: UIView) {
        selectedWidgetView?.backgroundColor = .gray
        selectedWidgetView = nil
    }
    
    func moveWidget(widgetView: UIView, by vector: CGPoint) {
        print("moving widget")
        widgetView.center = beginWidgetPosition + vector
    }
    
    func dragCanvas(by vector: CGPoint) {
        print("moving canvas")
        canvasView.bounds.origin = beginCanvasOrigin - CGPoint(x: vector.x / canvasView.transform.a,y: vector.y / canvasView.transform.d)
    }

    public func receiveWidget(widget: WidgetView) {
        holdedWidget = widget
    }
}
