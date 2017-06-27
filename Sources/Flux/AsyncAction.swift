//
//  AsyncAction.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/06/27.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public protocol AsyncAction {
    
    func exec(callback: @escaping Dispatcher.AsyncActionCallback)
}
