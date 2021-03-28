//
//  UIAnimatable.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 27.03.2021.
//

import Foundation
import MBProgressHUD

//делаем протокол анимации. Можно создать анимацию в площядке SeachTableViewController, но чтобы не нагружать код лишним создаем отдельный файл
protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}
//создаем расширение
extension UIAnimatable {
    
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
