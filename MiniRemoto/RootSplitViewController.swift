//
//  RootSplitViewController.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 25/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class RootSplitViewController: UISplitViewController {
    let master: UIViewController
    let detail: UIViewController

    init(master masterVC: UIViewController, detail detailVC: UIViewController) {
        self.master = masterVC
        self.detail = detailVC
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [master, detail]
    }

    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) not implemented")
    }
}
