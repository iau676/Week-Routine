//
//  Factories.swift
//  Week Routine
//
//  Created by ibrahim uysal on 23.04.2023.
//

import UIKit

//MARK: - UICollectionView

func makeCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
}

//MARK: - UILabel

func makePaddingLabel(withText text: String) -> UILabel {
    let label = UILabelPadding()
    label.textAlignment = .left
    label.numberOfLines = 0
    label.text = text
    return label
}

class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
