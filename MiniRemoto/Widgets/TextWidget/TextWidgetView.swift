//
//  TextWidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/// A representation of a `TextWidgetView`. This `WidgetView`
/// should only be instantiated when being added to a Canvas.
final class TextWidgetView: UIViewController, WidgetView {
    var snapshot: TextWidgetModel {
        return TextWidgetModel(frame: self.view.frame,
                               title: controller.title,
                               body: controller.body)
    }
    
    /// The state of a `TextWidget`. Changes in the UI/funcionality
    /// of a `TextWidget` should be called through the `didSet`.
    var state: WidgetState = .idle {
        didSet {
            switch self.state {
            case .editing:
                titleTextField.isEnabled = true
                bodyTextView.isEditable = true
            case .idle:
                titleTextField.isEnabled = false
                bodyTextView.isEditable = false
                view.resignFirstResponder()
            }
        }
    }

    /// The representation of a `TextWidget`'s title.
    @AutoLayout private var titleTextField: UITextField
    /// The representation of a `TextWidget`'s body.
    @AutoLayout private var bodyTextView: UITextView

    /// The Controller used by this type.
    private let controller: TextWidgetController

    /// Initialise a new instance of this type.
    /// - parameter controller: the Controller used by this type.
    init(controller: TextWidgetController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate(
            [titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
             titleTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
             titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.05),
             titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        )

        NSLayoutConstraint.activate(
            [bodyTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
             bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
             bodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.05)),
             bodyTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        )
    }

    /// Set the UI up with constraints so `titleTextField` and `bodyTextView`
    /// occupy 15% and 85% of a `TextWidget`'s frame, respectively.
    /// Configures `titleTextField` and `bodyTextView`.
    private func setupUI() {
        state = .idle
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = view.frame.height * 0.005
        view.clipsToBounds = true

        titleTextField.font = .preferredFont(forTextStyle: .headline)
        titleTextField.backgroundColor = .systemBackground
        titleTextField.placeholder = "Title"
        titleTextField.delegate = self
        titleTextField.textAlignment = .center

        bodyTextView.font = .preferredFont(forTextStyle: .body)
        bodyTextView.backgroundColor = .systemBackground
        bodyTextView.isScrollEnabled = true
        bodyTextView.delegate = self

        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
    }

    func edit() {
        state.toggle()
    }
}

extension TextWidgetView: UITextViewDelegate {
    /// Sends the current `bodyTextView`'s text to
    /// the Controller's body variable when the user ends
    /// their editing. Functions as a passthrough function
    /// to enable safe recording of the operation.
    func textViewDidEndEditing(_ textView: UITextView) {
        updateBody(textView.text)
    }

    /// Updates the body of a `TextWidget`. Records the operation
    /// using `UndoManager` to allow undo and redo.
    private func updateBody(_ text: String) {
        let currentText = controller.body
        controller.body = text

        undoManager?.registerUndo(withTarget: self, handler: { (target) in
            target.updateBody(currentText)
        })
    }
}

extension TextWidgetView: UITextFieldDelegate {
    /// Sends the current `titleTextField`'s text to
    /// the Controller's title variable when the user ends
    /// their editing. Functions as a passthrough function
    /// to enable safe recording of the operation.
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        updateTitle(text)
    }

    /// Updates the title of a `TextWidget`. Records the operation
    /// using `UndoManager` to allow undo and redo.
    private func updateTitle(_ text: String) {
        let currentText = controller.body
        controller.title = text

        undoManager?.registerUndo(withTarget: self, handler: { (target) in
            target.updateTitle(currentText)
        })
    }
}
