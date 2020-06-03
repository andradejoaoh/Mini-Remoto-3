//
//  BodyTextWidgetController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 03/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

/// A Controller to a `BodyTextWidgetView`. It should provide the
/// `BodyTextWidgetView` with input validation, if necessary.
final class BodyTextWidgetController {
    /// The Model used to hold the data from the user's input.
    private var model: BodyTextWidgetModel

    /// Initialise a new instance of this type.
    /// If no `BodyTextWidgetModel` is provied during the instantiaton process,
    /// a new `BodyTextWidgetModel` will be created with empty `title` and `body`.
    /// - parameter model: The Model used to hold the data from the user's input.
    init(model: BodyTextWidgetModel? = nil) {
        if let model = model {
            self.model = model
        } else {
            self.model = BodyTextWidgetModel()
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
