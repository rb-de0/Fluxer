//
//  Store.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public protocol Store {
    init(with dispatcher: Dispatcher)
}

public extension Store {
    
    func publish() {
        
        let reflected = Mirror(reflecting: self)
        
        reflected.children
            .flatMap { $0.value as? Publishable }
            .forEach {
                $0.publish()
            }
    }
}
