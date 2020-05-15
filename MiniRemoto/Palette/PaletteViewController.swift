//
//  PaletteViewController.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class PaletteViewController: UIViewController {
    private lazy var carousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private(set) var widgetOptions: [WidgetRepresentation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureCarousel()
        self.view.addSubview(carousel)
        positionCarousel()
    }

    private func newCarouselLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return layout
    }

    private func configureCarousel() {
        carousel.backgroundColor = .clear
        carousel.collectionViewLayout = newCarouselLayout()
        carousel.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        carousel.dataSource = self
        carousel.delegate = self
    }

    private func positionCarousel() {
        let carouselGuide = carousel.safeAreaLayoutGuide
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
    private func squareItemSize(withPadding padding: CGFloat) -> CGSize {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        let paletteLenght = viewHeight >= viewWidth ? viewHeight : viewWidth
        let side = paletteLenght/3
        return CGSize(width: side - padding, height: side - padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return squareItemSize(withPadding: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension PaletteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        //        return widgetOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
}

