//
//  Dispatcher.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import Foundation

public final class Dispatcher {
    
    public typealias AsyncActionCallback = (Action) -> ()
    public typealias AsyncActionCreator = (@escaping AsyncActionCallback) -> ()
    
    private let lock = NSLock()
    
    private var actionHandlers = [ActionHandler]()
    
    private var isDispatching = false
    
    public init() {}
    
    public func dispatch(_ action: Action) {
        
        lock.lock()
        defer { lock.unlock() }
        
        startDispatch()
        
        actionHandlers.forEach { handler in
            invokeActionHandler(handler: handler, action: action)
        }
        
        stopDispatching()
    }
    
    public func dispatch(_ asyncActionCreator: AsyncActionCreator) {
        
        asyncActionCreator {[weak self] action in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dispatch(action)
        }
    }
    
    public func dispatch(_ asyncAction: AsyncAction) {
        dispatch(asyncAction.exec)
    }
    
    public func waitFor(_ registrationTokens: [String], action: Action) {
        
        guard isDispatching else {
            fatalError("waitFor must be invoked while dispatching")
        }
        
        for registrationToken in registrationTokens {
            
            guard let handler = actionHandlers.filter ({ $0.registrationToken == registrationToken }).first else {
                continue
            }
            
            if handler.status == .pending {
                fatalError("circular dependency detected while")
            }
            
            if handler.status == .waiting {
                invokeActionHandler(handler: handler, action: action)
            }
        }
    }
    
    public func register(_ handler: @escaping (Action) -> ()) -> String {
        
        let registrationToken = generateRegistrationToken()
        actionHandlers.append(ActionHandler(registrationToken, handler, .waiting))
        
        return registrationToken
    }
    
    public func unregister(registrationToken: String) {
        
        actionHandlers = actionHandlers.filter { $0.registrationToken != registrationToken }
    }
    
    // MARK: - Private
    
    private func startDispatch() {
        
        actionHandlers.forEach {
            $0.status = .waiting
        }
        
        isDispatching = true
    }
    
    private func stopDispatching() {
        
        isDispatching = false
    }
    
    private func invokeActionHandler(handler: ActionHandler, action: Action) {
        
        guard handler.status == .waiting else {
            return
        }
        
        handler.status = .pending
        handler.handleFunc(action)
        handler.status = .handled
    }
    
    private func generateRegistrationToken() -> String {
        return UUID().uuidString
    }
}
