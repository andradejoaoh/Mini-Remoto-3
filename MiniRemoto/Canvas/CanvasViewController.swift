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

    var lastTouchLocation: CGPoint?
    var canvasOrigin: CGPoint = CGPoint.zero
    var canvasScale: CGPoint = CGPoint(x: 1, y: 1)
    var canvasTransform: CGAffineTransform = CGAffineTransform()
    var currentWidgetPosition: CGPoint = CGPoint.zero
    var heldWidget: WidgetView?
    var touchedView: UIView?
    var selectedWidgetView: WidgetView?

    /// This is the drawing view that contains every other view.
    /// self.view must be static just for handling user input
    lazy var canvasView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = .systemGray6
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        configureCanvasView()
    }

    func addWidget(widget: WidgetView, to view: UIView) {
        addInteractable(view: widget.view, to: view)
        self.addChild(widget)
        widget.didMove(toParent: self)
        widgets.append(widget)
    }

    /**
     Places tap, pan and long press gesture recognizers on the view and add it to the parent view.
     + Parameters:
     + view: The view which will receive the gesture recognizers and be placed.
     + to: The view which will receive the other view.

     - Author:
     Rafael Galdino
     */
    private func addInteractable(view: UIView, to parentView: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))
        parentView.addSubview(view)
    }

    /**
     Configure the canvasView to the specifications of the View Controller

     - Author:
     Rafael Galdino
     */
    private func configureCanvasView() {
        canvasView.frame = self.view.frame

        addInteractable(view: canvasView, to: self.view)

        if let backgroundTexture = UIImage(named: "dotPattern") {
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

    /**
     Removes a widget from the canvas

     - Author:
     Alex Nascimento
     */
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
        var tappedWidget: WidgetView?
        if widgets.contains(where: { (widgetView) -> Bool in
            if (widgetView.view == sender.view) {
                tappedWidget = widgetView
                return true
            } else { return false }
        }) {
            tapWidget(widgetView: tappedWidget!)
            return
        }
        tapCanvas()
    }

    @objc
    func longPress(_ sender: UILongPressGestureRecognizer) {

    }

    @objc
    func drag(_ sender : UIPanGestureRecognizer) {
        if let selectedWidgetView = selectedWidgetView {
            if heldWidget != nil {
                if sender.state == .began {
                    heldWidget?.view.layer.opacity = 0.5
                }
                heldWidget?.view.center = sender.location(in: self.view)
                if sender.state == .ended {
                    heldWidget?.view.layer.opacity = 1
                    addWidget(widget: heldWidget!, to: self.view)
                    heldWidget = nil
                }
                return
            }
            if sender.state == .began {
                lastTouchLocation = sender.location(in: view)
                canvasOrigin = canvasView.bounds.origin
                let wpos = selectedWidgetView.view.center
                currentWidgetPosition = wpos
            } else if sender.state == .changed {
                if widgets.contains(where: { (widgetView) -> Bool in
                    widgetView.view == sender.view
                }) && sender.view == selectedWidgetView.view {
                    moveWidget(widgetView: selectedWidgetView.view, by: sender.translation(in: view))
                } else {
                    dragCanvas(by: sender.translation(in: view))
                }
            }
        }
    }

    @objc
    func zoom(_ sender : UIPinchGestureRecognizer) {
        if sender.state == .began {
            canvasTransform = canvasView.transform
        }

        else if sender.state == .changed {
            let scaleResult = canvasTransform.scaledBy(x: sender.scale, y: sender.scale)
            guard scaleResult.a > 1/maxZoomOut, scaleResult.d > 1/maxZoomOut else { return }
            guard scaleResult.a < 1/maxZoomIn, scaleResult.d < 1/maxZoomIn else { return }
            canvasView.transform = scaleResult
        }
    }

    /**
     Removes a widget from the canvas

     - Author:
     Alex Nascimento
     */
    func tapCanvas() {
        if selectedWidgetView != nil {
            deselectWidget(widgetView: selectedWidgetView!)
        }
    }

    /**
    Makes the widget selected or desselected

    - Author:
    Alex Nascimento
    */
    func tapWidget(widgetView: WidgetView) {
        if selectedWidgetView == nil {
            selectWidget(widgetView: widgetView)
        } else if selectedWidgetView! == widgetView {
            deselectWidget(widgetView: widgetView)
        } else {
            deselectWidget(widgetView: selectedWidgetView!)
            selectWidget(widgetView: widgetView)
        }
    }

    /**
    Selects the specified widget

    - Author:
    Alex Nascimento
    */
    func selectWidget(widgetView: WidgetView) {
        selectedWidgetView = widgetView
        widgetView.state.toggle()
        widgetView.view.backgroundColor = .systemPink
    }

    /**
    Desselectes the specified widget

    - Author:
    Alex Nascimento
    */
    func deselectWidget(widgetView: WidgetView) {
        selectedWidgetView?.view.backgroundColor = .gray
        widgetView.state.toggle()
        selectedWidgetView = nil
    }

    /**
    Moves the specified widget

    - Author:
    Alex Nascimento
    */
    func moveWidget(widgetView: UIView, by vector: CGPoint) {
        widgetView.center = currentWidgetPosition + vector
    }

    /**
    Drags the canvas

    - Author:
    Alex Nascimento
    */
    func dragCanvas(by vector: CGPoint) {
        canvasView.bounds.origin = canvasOrigin - CGPoint(x: vector.x / canvasView.transform.a,y: vector.y / canvasView.transform.d)
    }

    /**
     Creates a widget on the canvas based on the `WidgetData` received.
     + Parameters:
        + widget: The widget data blueprint used to create the widget
        + location: The location of the widget will be placed on the canvas
        + withSize: Defines the size of the widget

     - Author:
     Rafael Galdino
     */
    public func receive(widget widgetBlueprint: WidgetData, at location: CGPoint, withSize size: CGSize = CGSize(width: 200, height: 200)) {
        let newWidget = widgetBlueprint.make()
        newWidget.view.frame.size = size
        newWidget.view.center = location
        addWidget(widget: newWidget, to: self.canvasView)
    }
}

// CanvasViewController extends UIDropInteractionDelegate
// so it can receive widgets from the pallete. This can
// further be expanded to receive objects from outside the
// app and create widgets based on them.
extension CanvasViewController: UIDropInteractionDelegate {

    //  This method especifies that only NSString items can be dragged into the app.
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    //  This method specifies that it will only accept items
    //  were dropped into the `canvasView` view AND were
    //  dragged from within the app.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)

        let operation: UIDropOperation

        if canvasView.frame.contains(dropLocation) && session.localDragSession != nil {
            operation = .copy
        } else {
            operation = .cancel
        }

        return UIDropProposal(operation: operation)
    }

    //  This method checks if the dragged item has a localObject
    //  of the type `WidgetData` and calls the widgetCanvas
    //  constructor.
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let first = session.items.first else { return }
        if let widget = first.localObject as AnyObject as? WidgetData {
            receive(widget: widget, at: session.location(in: view))
        }
    }
}
