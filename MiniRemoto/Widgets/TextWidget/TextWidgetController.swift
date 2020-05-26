//
//  TextWidgetController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

/// A Controller to a `TextWidgetView`. It should provide the
/// `TextWidgetView` with input validation, if necessary.
final class TextWidgetController {
    /// The Model used to hold the data from the user's input.
    private var model: TextWidgetModel

    /// Initialise a new instance of this type.
    /// If no `TextWidgetModel` is provied during the instantiaton process,
    /// a new `TextWidgetModel` will be created with empty `title` and `body`.
    /// - parameter model: The Model used to hold the data from the user's input.
    init(model: TextWidgetModel? = nil) {
        if let model = model {
            self.model = model
        } else {
            self.model = TextWidgetModel(title: "", body: "")
        }
    }

    /// The title input from the user. Exposed to the View in order
    /// to avoid exposing the Model directly. Any modification to the
    /// value necessary in order to provide the View or the Model with
    /// the data, should be done in the `get` and `set` of this variable.
    var title: String {
        get {
            return model.title
        } set {
            model.title = newValue
        }
    }

    /// The body input from the user. Exposed to the View in order
    /// to avoid exposing the Model directly. Any modification to the
    /// value necessary in order to provide the View or the Model with
    /// the data, should be done in the `get` and `set` of this variable.
    var body: String {
        get {
            return model.body
        } set {
            model.body = newValue
        }
    }
}
