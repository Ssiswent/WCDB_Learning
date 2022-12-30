//
//  BaseNavigationController.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/29.
//

import UIKit
import YPNavigationBarTransition

class BaseNavigationController: YPNavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let targets = interactivePopGestureRecognizer!.value(forKey: "_targets") as? [NSObject] else { return }
        let targetObjc = targets.first
        let target = targetObjc?.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        // 禁止系统的手势
        interactivePopGestureRecognizer?.isEnabled = false
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
        panGes.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1 {
            return true
        } else {
            return false
        }
    }
}
