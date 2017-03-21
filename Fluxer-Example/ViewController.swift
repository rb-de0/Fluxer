//
//  ViewController.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import UIKit
import Fluxer

class ViewController: UIViewController {
    
    private let mainStore = MainStore()
    
    private var dispacher: Dispatcher<MainStore>!
    
    private var compositeDisposable = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispacher = Dispatcher(store: mainStore)
        
        _ = dispacher.register { action, store in
            store.value.value += 10
        }
        
        let disposable = mainStore.value.asRender().subscribe {
            print($0)
        }
        
        compositeDisposable += disposable
    }
}
