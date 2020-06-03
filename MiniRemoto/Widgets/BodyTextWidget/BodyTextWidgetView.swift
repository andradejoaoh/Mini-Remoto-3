//
//  BodyTextWidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 03/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class BodyTextWidgetView: UIViewController, WidgetView {
    var snapshot: WidgetData {
        return BodyTextWidgetModel(frame: Frame(rect: internalFrame), body: controller.body)
    }

    var state: WidgetState = .idle {
        didSet {
            switch  self.state {
            case .editing:
                bodyTextView.isEditable = true
            case .idle:
                bodyTextView.isEditable = false
                view.resignFirstResponder()
            }
        }
    }

    var internalFrame: CGRect = CGRect.zero

    /// The representation of a `BodyTextWidgetView`'s content.
    @AutoLayout private var bodyTextView: UITextView

    /// The Controller used by this type.
    private let controller: BodyTextWidgetController

    /// Initialise a new instance of this type.
    /// - parameter controller: the Controller used by this type.
    init(controller: BodyTextWidgetController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.controller = BodyTextWidgetController()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

   /// Set the UI up with constraints for `bodyTextView` and configures it.
    private func setupUI() {
        state = .idle
        view.backgroundColor = .dotdGrey
        view.layer.cornerRadius = view.frame.height * 0.005
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.clipsToBounds = true

        bodyTextView.font = UIFont(name: "Avenir", size: 17)
        bodyTextView.adjustsFontForContentSizeCategory = true
        bodyTextView.backgroundColor = .systemBackground
        bodyTextView.isScrollEnabled = true
        bodyTextView.text = controller.body
        bodyTextView.delegate = self

        view.addSubview(bodyTextView)

        NSLayoutConstraint.activate(
            [bodyTextView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
             bodyTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
             bodyTextView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
             bodyTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        )
    }

    func edit() {
        state = .editing
    }
}

extension BodyTextWidgetView: UITextViewDelegate {
    /// Sends the current `bodyTextView`'s text to
    /// the Controller's body variable when the user ends
    /// their editing. Functions as a passthrough function
    /// to enable safe recording of the operation.
    func textViewDidEndEditing(_ textView: UITextView) {
        updateBody(textView.text)
    }

    /// Updates the content of a `BodyTextWiget`. Records the operation
    /// using `UndoManager` to allow undo and redo.
    private func updateBody(_ text: String) {
        let currentText = controller.body
        controller.body = text

        undoManager?.registerUndo(withTarget: self, handler: { (target) in
            target.updateBody(currentText)
        })
    }
}
