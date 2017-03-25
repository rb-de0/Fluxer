//
//  ActionHandler.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

class ActionHandler {
    
    let registrationToken: String
    let handleFunc: (Action) -> ()
    var status: DispatchStatus
    
    init(_ registrationToken: String, _ handleFunc: @escaping (Action) -> (), _ status: DispatchStatus) {
        self.registrationToken = registrationToken
        self.handleFunc = handleFunc
        self.status = status
    }
}
