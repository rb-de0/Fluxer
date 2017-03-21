//
//  ActionHandler.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

class ActionHandler<S: Store> {
    
    let handleFunc: (Action, S) -> ()
    var status: DispatchStatus
    
    init(_ handleFunc: @escaping (Action, S) -> (), _ status: DispatchStatus) {
        self.handleFunc = handleFunc
        self.status = status
    }
}
