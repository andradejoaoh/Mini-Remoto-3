//
//  TextWidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/// A representation of a TextWidgetView. This WidgetView
/// should only be instantiated when being added to a Canvas.
final class TextWidgetView: WidgetView {
    /// The representation of this TextWidget's title.
    @AutoLayout private var titleTextField: UITextField
    /// The representation of this TextWidget's body.
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setupUI()
    }

    /// Set the UI up with constraints so `titleTextField` and `bodyTextView`
    /// occupy 15% and 85% of this TextWidget's frame, respectively.
    /// Configures `titleTextField` and `bodyTextView`.
    private func setupUI() {
        view.backgroundColor = .systemBackground

        titleTextField.font = .preferredFont(forTextStyle: .headline)
        titleTextField.backgroundColor = .systemBackground
        titleTextField.placeholder = "Title"
        titleTextField.delegate = self

        bodyTextView.font = .preferredFont(forTextStyle: .body)
        bodyTextView.backgroundColor = .systemBackground
        bodyTextView.isScrollEnabled = true
        bodyTextView.delegate = self

        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)

        NSLayoutConstraint.activate(
            [titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor),
             titleTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
             titleTextField.topAnchor.constraint(equalTo: view.topAnchor)]
        )

        NSLayoutConstraint.activate(
            [bodyTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
             bodyTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85),
             bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor)]
        )
    }
}

extension TextWidgetView: UITextViewDelegate {
    /// Sends the current `bodyTextView`'s text to
    /// the Controller's body variable when the user ends
    /// their editing.
    func textViewDidEndEditing(_ textView: UITextView) {
        controller.body = bodyTextView.text
    }
}

extension TextWidgetView: UITextFieldDelegate {
    /// Sends the current `titleTextField`'s text to
    /// the Controller's title variable when the user ends
    /// their editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        controller.title = titleTextField.text ?? ""
    }
}
