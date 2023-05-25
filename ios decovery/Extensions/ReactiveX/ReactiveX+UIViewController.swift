//
//  ReactiveX+UIViewController.swift
//  ios decovery
//
//  Created by Ray Chow on 25/5/2023.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: UIViewController {
    public var viewWillAppear: ControlEvent<Void> {
        let source = base.rx.methodInvoked(#selector(Base.viewWillAppear))
            .map { _ in }
      return ControlEvent(events: source)
    }
}
