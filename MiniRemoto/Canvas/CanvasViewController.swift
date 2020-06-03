//
//  CanvasViewController.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//


import UIKit

class CanvasViewController: UIViewController {
    var snapshot: CanvasModel {
        var imageWidgetSnapshots: [ImageWidgetModel] = []
        var titleTextWidgetSnapshots: [TitleTextWidgetModel] = []
        var bodyTextWidgetSnapshots: [BodyTextWidgetModel] = []
        for widget in widgets {
            switch widget {
            case is TitleTextWidgetView:
                if let titleTextWidgetSnapshot = widget.snapshot as? TitleTextWidgetModel {
                    titleTextWidgetSnapshots.append(titleTextWidgetSnapshot)
                }
            case is BodyTextWidgetView:
                if let bodyTextWidgetSnapshot = widget.snapshot as? BodyTextWidgetModel {
                    bodyTextWidgetSnapshots.append(bodyTextWidgetSnapshot)
                }
            case is ImageWidgetView:
                if let imageWidgetSnapshot = widget.snapshot as? ImageWidgetModel {
                    imageWidgetSnapshots.append(imageWidgetSnapshot)
                }
            default:
                break
            }
        }

        return CanvasModel(name: model.name, lastModifiedAt: model.lastModifiedAt, createdAt: model.createdAt, titleTextWidgets: titleTextWidgetSnapshots, bodyTextWidgets: bodyTextWidgetSnapshots, imageWidgets: imageWidgetSnapshots)
    }

    var widgets = Array<WidgetView>()

    var model: CanvasModel = CanvasModel(name: "MyCanvas", lastModifiedAt: "", createdAt: "") {
        didSet {
            model.imageWidgets.forEach { [weak self] (widget) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let _widget = widget.make()
                    _widget.view.frame = CGRect(frame: widget.frame)
                    self.addWidget(widget: _widget, to: self.canvasView)
                }
            }

            model.titleTextWidgets.forEach { [weak self] (widget) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let _widget = widget.make()
                    _widget.view.frame = CGRect(frame: widget.frame)
                    self.addWidget(widget: _widget, to: self.canvasView)
                }
            }

            model.bodyTextWidgets.forEach { [weak self] (widget) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let _widget = widget.make()
                    _widget.view.frame = CGRect(frame: widget.frame)
                    self.addWidget(widget: _widget, to: self.canvasView)
                }
            }
        }
    }

    let maxZoomOut: CGFloat = 4
    let maxZoomIn: CGFloat = 1/2

    var canvasOrigin: CGPoint = CGPoint.zero
    var canvasTransform: CGAffineTransform = CGAffineTransform()
    var currentWidgetPosition: CGPoint = CGPoint.zero
    var selectedWidgetView: WidgetView?
    
    var transformHandles = [TransformHandle]()

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
        widget.setInteractions(canvas: self)
        view.addSubview(widget.view)
        self.addChild(widget)
        widget.didMove(toParent: self)
        widget.internalFrame = widget.view.frame
        widgets.append(widget)
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

    /**
     Places tap, pan and long press gesture recognizers on the view and add it to the parent view.
     + Parameters:
     + view: The view which will receive the gesture recognizers and be placed.
     + to: The view which will receive the other view.

     - Author:
     Rafael Galdino
     */
    private func addWidgetInteractions(widget: WidgetView, to parentView: UIView) {
        widget.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedWidget(_:))))
        widget.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggedWidget(_:))))
        widget.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressedWidget(_:))))
    }

    /**
     Configure the canvasView to the specifications of the View Controller

     - Author:
     Rafael Galdino
     */
    private func configureCanvasView() {
        canvasView.frame = self.view.frame

        canvasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedCanvas(_:))))
        canvasView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggedCanvas(_:))))
        canvasView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressedCanvas(_:))))
        view.addSubview(canvasView)

        if let backgroundTexture = UIImage(named: "Background_Pattern_PDF") {
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
    
    
    // Widget gestures
    @objc
    public func tappedWidget(_ sender: UITapGestureRecognizer) {
        if let widgetView = widgets.contains(view: sender.view) {
            if selectedWidgetView == nil {
                selectWidget(widgetView: widgetView)
            } else if selectedWidgetView! === widgetView {
                deselectWidget(widgetView: widgetView)
            } else {
                deselectWidget(widgetView: selectedWidgetView!)
                selectWidget(widgetView: widgetView)
            }
        }
    }

    @objc
    public func longPressedWidget(_ sender: UILongPressGestureRecognizer) {
        if let widgetView = widgets.contains(view: sender.view) {
            selectWidget(widgetView: widgetView)
            editWidget(widgetView: widgetView)
        }
    }

    @objc
    public func draggedWidget(_ sender : UIPanGestureRecognizer) {
        if let selectedWidgetView = selectedWidgetView {
            if sender.state == .began {
                canvasOrigin = canvasView.bounds.origin
                currentWidgetPosition = selectedWidgetView.view.center
            }
            
            else if sender.state == .changed {
                if let v = widgets.contains(view: sender.view) {
                    if v is BodyTextWidgetView || sender.view === selectedWidgetView.view {
                        moveWidget(widgetView: selectedWidgetView.view, by: sender.translation(in: canvasView))
                    } else {
                        dragCanvas(from: canvasOrigin, by: sender.translation(in: view))
                    }
                }
            }
        }
    }
    
    // canvas gestures
    @objc
    func tappedCanvas(_ sender: UITapGestureRecognizer) {
        tapCanvas()
    }
    
    @objc
    func draggedCanvas(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            canvasOrigin = canvasView.bounds.origin
        } else if sender.state == .changed {
            dragCanvas(from: canvasOrigin, by: sender.translation(in: view))
        }
    }
    
    @objc
    func longPressedCanvas(_ sender: UILongPressGestureRecognizer) {
        
    }

    // view gestures
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
    Selects the specified widget

    - Author:
    Alex Nascimento
    */
    func selectWidget(widgetView: WidgetView) {
        if selectedWidgetView === widgetView {
            return
        }
        UISelectionFeedbackGenerator().selectionChanged()
        if let selectedWidgetView = selectedWidgetView {
            deselectWidget(widgetView: selectedWidgetView)
        }
        widgetView.select()
        selectedWidgetView = widgetView
        placeTransformHandles(widgetView: widgetView)
    }
    
    func placeTransformHandles(widgetView: WidgetView) {
        if !transformHandles.isEmpty {
            transformHandles.removeAll()
        }
        TransformHandle.makeTransformHandles(on: widgetView, handlesArray: &transformHandles, canvas: self)
        transformHandles[0].setNeedsDisplay()
    }
    
    func updateTransformHandles() {
        transformHandles.forEach { (transformHandle) in
            transformHandle.updatePosition()
        }
    }
    
    /**
    Desselectes the specified widget

    - Author:
    Alex Nascimento
    */
    func deselectWidget(widgetView: WidgetView) {
        widgetView.deselect()
        transformHandles.forEach { (transformHandle) in
            transformHandle.removeFromSuperview()
        }
        transformHandles.removeAll()
        selectedWidgetView = nil
    }
    
    func editWidget(widgetView: WidgetView) {
        widgetView.edit()
    }
    
    /**
    Moves the specified widget

    - Author:
    Alex Nascimento
    */
    func moveWidget(widgetView: UIView, by vector: CGPoint) {
        widgetView.center = currentWidgetPosition + vector
        updateTransformHandles()
    }

    /**
    Drags the canvas

    - Author:
    Alex Nascimento
    */
    func dragCanvas(from origin: CGPoint, by vector: CGPoint) {
        canvasView.bounds.origin = origin - CGPoint(x: vector.x / canvasView.transform.a,y: vector.y / canvasView.transform.d)
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

    func restore(_ model: CanvasModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for widget in self.widgets {
                self.removeWidget(widget: widget)
            }
            self.model = model
        }
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
            receive(widget: widget, at: session.location(in: canvasView))
        }
    }
}
