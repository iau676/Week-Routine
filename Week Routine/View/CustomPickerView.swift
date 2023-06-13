//
//  CustomPickerView.swift
//  Week Routine
//
//  Created by ibrahim uysal on 11.06.2023.
//

import UIKit

enum CustomPickerViewType {
    case date
    case timer
    case sound
}

final class CustomPickerView: UIPickerView {
    let type: CustomPickerViewType

    init(type: CustomPickerViewType) {
        self.type = type
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
