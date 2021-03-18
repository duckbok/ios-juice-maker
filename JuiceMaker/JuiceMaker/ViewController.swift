//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let juiceMaker = JuiceMaker.shared
    @IBOutlet var fruitStockLabels = [UILabel]()
    @IBOutlet var juiceOrderButtons: [JuiceOrderButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectJuice(to: juiceOrderButtons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update(labels: fruitStockLabels, by: juiceMaker.stock)
    }
    
    @IBAction func touchUpJuiceOrderButton(_ sender: JuiceOrderButton) {
        guard let juice = sender.juice else { return }
        
        if juiceMaker.stock.hasFruits(for: juice) {
            juiceMaker.make(juice)
            alert(title: "\(juice.name) 나왔습니다!", message: "맛있게 드세요!", actionTypes: [.ok("감사합니다!")])
            update(labels: fruitStockLabels, by: juiceMaker.stock)
        } else {
            alert(title: "재고가 모자라요.", message: "재고를 수정할까요?", actionTypes: [.ok("예", { _ in self.performSegue(withIdentifier: "stockChanger", sender: nil)}), .cancel("아니오")])
        }
    }
    
    func alert(title: String, message: String, actionTypes: [UIAlertAction.ActionType]) {
        let alertController = UIAlertController(title: title, message: message)
        
        for actionType in actionTypes {
            alertController.addAction(actionType.action())
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

func update(labels: [UILabel], by stock: Stock) {
    for index in 0..<labels.count {
        guard let fruitType = Fruit(rawValue: index) else { return }
        guard let fruitStock = stock.fruits[fruitType] else { return }
        
        labels[index].text = String(fruitStock)
    }
}

func connectJuice(to buttons: [JuiceOrderButton]) {
    for index in 0..<buttons.count {
        guard let juiceType = Juice(rawValue: index) else { return }
        
        buttons[index].juice = juiceType
    }
}
