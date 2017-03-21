//
//  DisposeBag.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public final class DisposeBag {
    
    private var disposables = [Disposable]()
    
    func append(_ disposable: Disposable) {
        disposables.append(disposable)
    }
    
    deinit {
        disposables.forEach {
            $0.dispose()
        }
    }
}
