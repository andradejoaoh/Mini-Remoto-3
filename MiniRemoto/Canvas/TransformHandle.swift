//
//  TransformHandle.swift
//  MiniRemoto
//
//  Created by Alex Nascimento on 27/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

final class TransformHandle: UIView {
    
    weak var referenceView: UIView?
    var corner: Corner
    
    init(frame: CGRect, reference: UIView, corner: Corner) {
        self.referenceView = reference
        self.corner = corner
        super.init(frame: frame)
    }
    
    func updateReferenceView() {
        guard let ref = referenceView else { return }
        switch corner {
        case .topLeft:
            ref.frame = CGRect(minX: self.center.x, minY: self.center.y, maxX: ref.frame.maxX, maxY: ref.frame.maxY)
        case .topRight:
            ref.frame = CGRect(minX: ref.frame.minX, minY: self.center.y, maxX: self.center.x, maxY: ref.frame.maxY)
        case .bottomLeft:
            ref.frame = CGRect(minX: self.center.x, minY: ref.frame.minY, maxX: ref.frame.maxX, maxY: self.center.y)
        case .bottomRight:
            ref.frame = CGRect(minX: ref.frame.minX, minY: ref.frame.minY, maxX: self.center.x, maxY: self.center.y)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Corner: CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
