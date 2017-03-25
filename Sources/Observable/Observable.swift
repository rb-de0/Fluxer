//
//  Observable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import Foundation

public protocol Observable {
    
    associatedtype T
    
    func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable
}

// MARK: - Util
extension Observable {
    
    func generateRegistrationToken() -> String {
        return UUID().uuidString
    }
}
