//
//  UIImage+Extensions.swift
//  Week Routine
//
//  Created by ibrahim uysal on 2.12.2022.
//

import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
