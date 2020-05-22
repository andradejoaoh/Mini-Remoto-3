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
        let newWidth = canvasView.bounds.width * maxZoomOut
        let newHeight = canvasView.bounds.height * maxZoomOut
        canvasView.bounds = CGRect(x: 0,
                                   y: 0,
                                   width: newWidth,
                                   height: newHeight)
        canvasView.bounds.origin = CGPoint(x: canvasView.frame.origin.x, y: canvasView.frame.origin.y)

        canvasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        canvasView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        canvasView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))

        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:))))

        // Placeholder objects
        let center = UIView(frame: CGRect(x: -5, y: -5, width: 10, height: 10))
        center.backgroundColor = .yellow
        canvasView.addSubview(center)
        center.layer.zPosition = 100

        let widg1 = WidgetView()
        widg1.view.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
        widg1.view.backgroundColor = .systemPink
        widg1.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        widg1.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        widg1.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))

        let widg2 = WidgetView()
        widg2.view.frame = CGRect(x: 199, y: 500, width: 400, height: 2000)
        widg2.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        widg2.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        widg2.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))

        widg2.view.backgroundColor = .systemBlue

        let widg3 = WidgetView()
        widg3.view.frame = CGRect(x: -200, y: -300, width: 300, height: 300)
        widg3.view.backgroundColor = .systemPurple
        widg3.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        widg3.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        widg3.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))

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
    func tap(_ sender : UITapGestureRecognizer) {
        if widgets.contains(where: { (widgetView) -> Bool in
            widgetView.view == sender.view
        }) {
            tapWidget(widgetView: sender.view!)
            return
        }
        tapCanvas()
    }

    @objc
    func longPress(_ sender: UILongPressGestureRecognizer) {

    }

    @objc
    func drag(_ sender : UIPanGestureRecognizer) {
        if sender.state == .began {
            beginTouchLocation = sender.location(in: view)
            beginCanvasOrigin = canvasView.bounds.origin
            if let wpos = selectedWidgetView?.center {
                beginWidgetPosition = wpos
            }
        }

        else if sender.state == .changed {
            if widgets.contains(where: { (widgetView) -> Bool in
                widgetView.view == sender.view
            }) && sender.view == selectedWidgetView {
                moveWidget(widgetView: selectedWidgetView!, by: sender.translation(in: view))
            } else {
                dragCanvas(by: sender.translation(in: view))
            }
        }
    }

    @objc
    func zoom(_ sender : UIPinchGestureRecognizer) {
        if sender.state == .began {
            beginCanvasTransform = canvasView.transform
        }

        else if sender.state == .changed {

            let scaleResult = beginCanvasTransform.scaledBy(x: sender.scale, y: sender.scale)
            guard scaleResult.a > 1/maxZoomOut, scaleResult.d > 1/maxZoomOut else { return }
            guard scaleResult.a < 1/maxZoomIn, scaleResult.d < 1/maxZoomIn else { return }

            canvasView.transform = scaleResult
        }
    }

    func tapCanvas() {
        if selectedWidgetView != nil {
            deselectWidget(widgetView: selectedWidgetView!)
        }
    }

    func tapWidget(widgetView: UIView) {
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
        widgetView.backgroundColor = .systemYellow
    }

    func deselectWidget(widgetView: UIView) {
        selectedWidgetView?.backgroundColor = .gray
        selectedWidgetView = nil
    }

    func moveWidget(widgetView: UIView, by vector: CGPoint) {
        widgetView.center = beginWidgetPosition + vector
    }

    func dragCanvas(by vector: CGPoint) {
        canvasView.bounds.origin = beginCanvasOrigin - CGPoint(x: vector.x / canvasView.transform.a,y: vector.y / canvasView.transform.d)
    }

    public func receiveWidget(widget: WidgetView) {
        holdedWidget = widget
    }
}
