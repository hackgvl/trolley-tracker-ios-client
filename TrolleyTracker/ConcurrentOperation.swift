//
//  GetETAOperation.swift
//  
//
//  Created by Austin Younts on 8/23/15.
//
//

import Foundation

class ConcurrentOperation: NSOperation {

    override var asynchronous: Bool {
        return true
    }
    
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsCancelled() -> Set<NSObject> {
        return ["state"]
    }
    
    
    private enum State: Int {
        /// The initial state of an `Operation`.
        case Initialized
        
        /// The `Operation` is executing.
        case Executing
        
        /// The `Operation` has finished executing.
        case Finished
        
        /// The `Operation` has been cancelled.
        case Cancelled
    }
    
    private var _state = State.Initialized
    
    private var state: State {
        get {
            return _state
        }
        
        set(newState) {
            // Manually fire the KVO notifications for state change, since this is "private".
            
            willChangeValueForKey("state")
            
            switch (_state, newState) {
            case (.Finished, _):
                break // cannot leave the finished state
            default:
                _state = newState
            }
            
            didChangeValueForKey("state")
        }
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var cancelled: Bool {
        return state == .Cancelled
    }
    
    override final func start() {
        
        if !(state == .Cancelled) {
            state = .Executing
        }
        
        execute()
    }
    
    func execute() {
        print("\(self.dynamicType) must override `execute()`.")
        
        finish()
    }
    
    override func cancel() {
        state = .Cancelled
    }
    
    final func finish() {
        state = .Finished
    }
}
