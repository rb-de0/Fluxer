//
//  ViewController.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import UIKit
import Fluxer

class MainStore: Store {
    
    var count = ObservableValue(0)
    
    required init(with dispatcher: Dispatcher) {
        
        _ =  dispatcher.register { [weak self] action in
            
            switch action {
            case _ as CountUpAction:
                self?.count.value += 1
                
            case _ as CountDownAction:
                self?.count.value -= 1
                
            default:
                break
            }
        }
    }
}

struct CountUpAction: Action {}

struct CountDownAction: Action {}

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func countUp(_ sender: Any) {
        mainDispatcher.dispatch(CountUpAction())
    }
    
    @IBAction func countDown(_ sender: Any) {
        mainDispatcher.dispatch(CountDownAction())
    }
    
    private let mainDispatcher = Dispatcher()
    
    private var mainStore: MainStore!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStore = MainStore(with: mainDispatcher)
        
        mainStore.count.asRender().subscribe { [weak self] in
            self?.countLabel.text = String($0)
        }.addTo(disposeBag)
    }
}
