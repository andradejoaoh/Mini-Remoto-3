//
//  SnapshotController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 15/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

protocol SnapshotController {
    var children: [Self]? { get }
    func addChild(_ : Self)
    func capture()
}
