//
//  FileManager+Extensions.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 02/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

extension FileManager {
    static var userDocumentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
