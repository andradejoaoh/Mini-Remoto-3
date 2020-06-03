//
//  TextWidgetController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

/// A Controller to a `TitleTextWidgetView`. It should provide the
/// `TitleTextWidgetView` with input validation, if necessary.
final class TitleTextWidgetController {
    /// The Model used to hold the data from the user's input.
    private var model: TitleTextWidgetModel

    /// Initialise a new instance of this type.
    /// If no `TitleTextWidgetModel` is provied during the instantiaton process,
    /// a new `TitleTextWidgetModel` will be created with empty `title`.
    /// - parameter model: The Model used to hold the data from the user's input.
    init(model: TitleTextWidgetModel? = nil) {
        if let model = model {
            self.model = model
        } else {
            self.model = TitleTextWidgetModel()
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
}
