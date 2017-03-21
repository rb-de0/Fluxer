//
//  Dispatcher.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import Foundation

public final class Dispatcher<S: Store> {
    
    public typealias AsyncActionCallback = ((S) -> Action) -> ()
    public typealias AsyncActionCreator = (S, @escaping AsyncActionCallback) -> ()
    
    private let store: S
    
    private let lock = NSLock()
    
    private var actionHandlers = [String: ActionHandler<S>]()
    
    private var isDispatching = false
    
    public init(store: S) {
        self.store = store
    }
    
    public func dispatch(_ action: Action) {
        
        lock.lock()
        defer { lock.unlock() }
        
        if isDispatching {
            return
        }
        
        startDispatch()
        
        actionHandlers.values.forEach { handler in
            invokeActionHandler(handler: handler, action: action)
        }
        
        stopDispatching()
    }
    
    public func dispatch(_ asyncActionCreator: AsyncActionCreator) {
        
        asyncActionCreator(store) {[weak self] getAction in
            
            guard let strongSelf = self else {
                return
            }
            
            let action = getAction(strongSelf.store)
            strongSelf.dispatch(action)
        }
    }
    
    public func waitFor(_ registrationTokens: [String], action: Action) {
        
        guard isDispatching else {
            fatalError("waitFor must be invoked while dispatching")
        }
        
        for registrationToken in registrationTokens {
            
            guard let handler = actionHandlers[registrationToken] else {
                return
            }
            
            if handler.status == .pending {
                fatalError("circular dependency detected while")
            }
            
            if handler.status == .waiting {
                invokeActionHandler(handler: handler, action: action)
            }
        }
    }
    
    public func register(_ handler: @escaping (Action, S) -> ()) -> String {
        
        let registrationToken = generateRegistrationToken()
        actionHandlers[registrationToken] = ActionHandler(handler, .waiting)
        
        return registrationToken
    }
    
    public func unregister(registrationToken: String) {
        
        actionHandlers[registrationToken] = nil
    }
    
    // MARK: - Private
    
    private func startDispatch() {
        
        actionHandlers.values.forEach {
            $0.status = .waiting
        }
        
        isDispatching = true
    }
    
    private func stopDispatching() {
        
        isDispatching = false
    }
    
    private func invokeActionHandler(handler: ActionHandler<S>, action: Action) {
        
        guard handler.status == .waiting else {
            return
        }
        
        handler.status = .pending
        handler.handleFunc(action, store)
        handler.status = .handled
    }
    
    private func generateRegistrationToken() -> String {
        return UUID().uuidString
    }
}
