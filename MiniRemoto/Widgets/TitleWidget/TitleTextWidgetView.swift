//
//  TextWidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/// A representation of a `TitleTextWidgetView`. This `WidgetView`
/// should only be instantiated when being added to a Canvas.
final class TitleTextWidgetView: UIViewController, WidgetView {
    var internalFrame: CGRect = CGRect.zero


    var snapshot: WidgetData {
        return TitleTextWidgetModel(frame: Frame(rect: internalFrame),
                               title: controller.title)
    }
    
    /// The state of a `TitleTextWidgetView`. Changes in the UI/funcionality
    /// of a `TitleTextWidgetView` should be called through the `didSet`.
    var state: WidgetState = .idle {
        didSet {
            switch self.state {
            case .editing:
                titleTextField.isEnabled = true
                titleTextField.becomeFirstResponder()
            case .idle:
                titleTextField.isEnabled = false
                titleTextField.resignFirstResponder()
            }
        }
    }

    /// The representation of a `TitleTextWidgetView`'s content.
    @AutoLayout private var titleTextField: UITextField

    /// The Controller used by this type.
    private let controller: TitleTextWidgetController

    /// Initialise a new instance of this type.
    /// - parameter controller: the Controller used by this type.
    init(controller: TitleTextWidgetController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.controller = TitleTextWidgetController()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setInteractions(canvas: CanvasViewController) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: canvas, action: #selector(canvas.tappedWidget(_:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: canvas, action: #selector(canvas.draggedWidget(_:))))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: canvas, action: #selector(canvas.longPressedWidget(_:))))
    }

    /// Set the UI up with constraints for `titleTextField` and configures it.
    private func setupUI() {
        state = .idle
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = view.frame.height * 0.005
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.clipsToBounds = true

        titleTextField.font = .preferredFont(forTextStyle: .headline)
        titleTextField.backgroundColor = .systemBackground
        titleTextField.placeholder = "Title"
        titleTextField.delegate = self
        titleTextField.textAlignment = .center
        titleTextField.text = controller.title

        view.addSubview(titleTextField)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            titleTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }

    func edit() {
        state = .editing
    }
    
    func deselect() {
        state = .idle
        view.backgroundColor = .white
    }
}

extension TitleTextWidgetView: UITextFieldDelegate {
    /// Sends the current `titleTextField`'s text to
    /// the Controller's title variable when the user ends
    /// their editing. Functions as a passthrough function
    /// to enable safe recording of the operation.
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        updateTitle(text)
    }

    /// Updates the content of a `TitleTextWidget`. Records the operation
    /// using `UndoManager` to allow undo and redo.
    private func updateTitle(_ text: String) {
        let currentText = controller.title
        controller.title = text

        undoManager?.registerUndo(withTarget: self, handler: { (target) in
            target.updateTitle(currentText)
        })
    }
}
