//
//  PaletteViewController.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

protocol PaletteWidget {
    var name: String { get }
    var icon: UIImage { get }
    var frame: CGRect { get set }
}

struct TextPaletteWidget: PaletteWidget {
    var name: String
    var icon: UIImage
    var frame: CGRect

    init(imageName: String) {
        self.name = imageName
        self.icon = UIImage(named: imageName) ?? UIImage()
        self.frame = CGRect.zero
    }

    init() {
        self.init(imageName: "placeholder")
    }
}

final class PaletteViewController: UIViewController {
    @AutoLayout private var carouselView: CarouselCollectionView

    init(avaiableWidgets widgets: [PaletteWidget]) {
        widgetOptions = widgets
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(avaiableWidgets: [])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /**
     Collection of avaiable widget options on the palette.

     - Author:
       Rafael Galdino
    */
    public var widgetOptions: [PaletteWidget] = [] {
        didSet{
            carouselView.reloadData()
        }
    }

    /**
     Collection of avaiable widget options on the palette.

     - Author:
       Rafael Galdino
    */
    public var itemPadding: Double = 10 {
        didSet{
            carouselView.reloadData()
        }
    }

//    Override of viewDidLoad for palette setup.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addCarouselView()
    }

//    Override of viewWillTransition to resize collectionView
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carouselView.reloadData()
    }

/**
 Performs basic CarouselView configuration

 - Author:
   Rafael Galdino
*/
    private func addCarouselView() {
        carouselView.dataSource = self
        carouselView.delegate = self
        carouselView.dragDelegate = self
        self.view.addSubview(carouselView)
        positionCarouselView()
    }

/**
 Configure CarouselView Auto Layout to fill the ViewController

 - Author:
   Rafael Galdino
*/

    private func positionCarouselView() {
        let carouselGuide = carouselView.safeAreaLayoutGuide
        let viewGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            carouselGuide.topAnchor.constraint(equalTo:viewGuide.topAnchor),
            carouselGuide.bottomAnchor.constraint(equalTo:viewGuide.bottomAnchor),
            carouselGuide.trailingAnchor.constraint(equalTo:viewGuide.trailingAnchor),
            carouselGuide.leadingAnchor.constraint(equalTo:viewGuide.leadingAnchor)
        ])
    }
}

extension PaletteViewController: UICollectionViewDelegateFlowLayout {

/** Creates a `CGSize` with equal height and witdh based on the Palette's height.
     - parameters:
       - withPadding: Reduces the total size by the determined value.

     - Author:
     Rafael Galdino
*/
    private func squareItemSize(withPadding padding: Double) -> CGSize {
        let viewHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        let side = viewHeight - CGFloat(padding)
        return CGSize(width: side, height: side)
    }

//    Defines the size of the items in the palette as square minus `itemSpacing`.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return squareItemSize(withPadding: itemPadding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding >= 0 ? CGFloat(itemPadding) : 0
    }
}

extension PaletteViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widgetOptions.count
    }

//  Casts collection view cell as CarouselCellView and atributes image based on widgetOptions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as? CarouselCellView else { return UICollectionViewCell()}
        cell.image = widgetOptions[indexPath.item].icon
        return cell
    }
}

extension PaletteViewController: UICollectionViewDragDelegate {
    /**
     Creates  a `UIDragItem` with the selected `PaletteWidget` as the `localObject` and it's name as an item for `NSItemProvider`

     - Author:
     Rafael Galdino
     */
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let item = NSString(string: widgetOptions[indexPath.item].name)
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)

        dragItem.localObject = widgetOptions[indexPath.item]

        return [dragItem]
    }
}
