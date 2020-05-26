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
    lazy var canvasView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = .systemGray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        configureCanvasView()

        // Placeholder objects
        let center = UIView(frame: CGRect(x: -5, y: -5, width: 10, height: 10))
        center.backgroundColor = .yellow
        canvasView.addSubview(center)
        center.layer.zPosition = 100
    }

    func addWidget(widget: WidgetView, to view: UIView) {
        addInteractable(view: widget.view, to: view)
        self.addChild(widget)
        widget.didMove(toParent: self)
        widgets.append(widget)
    }

    private func addInteractable(view: UIView, to parent: UIView) {
        parent.addSubview(view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))
    }

    private func configureCanvasView() {
        canvasView = UIView(frame: self.view.frame)

        addInteractable(view: canvasView, to: self.view)

        if let backgroundTexture = UIImage(named: "tiled_paper_texture") {
            canvasView.backgroundColor = UIColor(patternImage: backgroundTexture)
        }

        let newWidth = canvasView.bounds.width * maxZoomOut
        let newHeight = canvasView.bounds.height * maxZoomOut
        canvasView.bounds = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        canvasView.bounds.origin = CGPoint(x: canvasView.frame.origin.x, y: canvasView.frame.origin.y)

        let dropInteraction = UIDropInteraction(delegate: self)
        canvasView.addInteraction(dropInteraction)

        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:))))
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
        if holdedWidget != nil {
            if sender.state == .began {
                holdedWidget?.view.layer.opacity = 0.5
            }
            holdedWidget!.view.center = sender.location(in: self.view)
            if sender.state == .ended {
                holdedWidget?.view.layer.opacity = 1
                addWidget(widget: holdedWidget!, to: self.view)
                holdedWidget = nil
            }
            return
        }
        if sender.state == .began {
            beginTouchLocation = sender.location(in: view)
            beginCanvasOrigin = canvasView.bounds.origin
            if let wpos = selectedWidgetView?.center {
                beginWidgetPosition = wpos
            }
        } else if sender.state == .changed {
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

    public func receiveWidget(widget: WidgetData, location: CGPoint) {
        holdedWidget = widget.make()
        holdedWidget?.view.center = location
        addWidget(widget: holdedWidget!, to: self.canvasView)
        holdedWidget = nil
    }
}

extension CanvasViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)

        let operation: UIDropOperation

        if canvasView.frame.contains(dropLocation) {
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            operation = .cancel
        }

        return UIDropProposal(operation: operation)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let first = session.items.first else { return }
        if let widget = first.localObject as AnyObject as? WidgetData {
            let dropLocation = session.location(in: view)
            receiveWidget(widget: widget, location: dropLocation)
        }
    }
}
