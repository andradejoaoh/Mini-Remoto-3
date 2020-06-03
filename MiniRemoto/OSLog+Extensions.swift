//
//  OSLog+Extensions.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 02/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.dotd"

    static let persistenceCycle = OSLog(subsystem: subsystem , category: "persistence")
    static let imageLoadingCycle = OSLog(subsystem: subsystem, category: "image-loading")
}
