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
    let detail: ContainerViewController?

    init(master masterVC: UIViewController, detail detailVC: ContainerViewController) {
        self.master = masterVC
        self.detail = detailVC

        super.init(nibName: nil, bundle: nil)

        self.preferredPrimaryColumnWidthFraction = 0.15
        let navMaster = UINavigationController(rootViewController: self.master)
        let navDetail = UINavigationController(rootViewController: self.detail!)
        self.viewControllers = [navMaster, navDetail]
    }

    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .primaryHidden
    }
}
