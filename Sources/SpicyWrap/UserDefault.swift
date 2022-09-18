//
//
//  MIT License
//
//  Copyright (c) 2022-Present EverythingAtOnce
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

// Inspired by https://habr.com/ru/post/670378/


#if canImport(Foundation)
import Foundation


// MARK: Wrapper

/// Provides an API for a UserDefaults stored values.
@propertyWrapper public struct UserDefault<Value> {
    
    
    public var wrappedValue: Value {
        get { getValue() }
        nonmutating set { setValue(newValue) }
    }
    
    /// Value getter.
    private let getValue: () -> Value
    
    /// Value setter.
    private let setValue: (Value) -> Void
    
}


#if canImport(SwiftUI)
import SwiftUI


extension UserDefault: DynamicProperty {
    
}
#endif


// MARK: Standard types

extension UserDefault {
    
    
    /// Common init. Should be used for standard value types.
    private init(defaultValue: Value, _ key: String, storage: UserDefaults = .standard) {
        
        getValue = {
            if let value = storage.value(forKey: key) as? Value {
                return value
            } else {
                return defaultValue
            }
        }
        
        setValue = { newValue in
            storage.set(newValue, forKey: key)
        }
        
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Int {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Double {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == String {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Bool {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == URL {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Data {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
}


// MARK: Nullable standard values

extension UserDefault where Value: ExpressibleByNilLiteral {
    
    
    /// Common init. Should be used for nullable standard value types.
    private init<WrappedType>(
        wrappedType: WrappedType.Type,
        _ key: String,
        storage: UserDefaults = .standard
    ) {
        
        getValue = {
            if let value = storage.value(forKey: key) as? Value {
                return value
            } else {
                return nil
            }
        }
        
        setValue = { newValue in
            
            if let newValue = newValue as? WrappedType? {
                storage.set(newValue, forKey: key)
            } else {
                storage.removeObject(forKey: key)
            }
            
        }
        
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard nullable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Int? {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard nullable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Double? {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard nullable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == String? {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard nullable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Bool? {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard nullable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == URL? {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for a standard nullable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == Data? {
        self.init(defaultValue: wrappedValue, key, storage: storage)
    }
    
}


// MARK: RawRepresentable values

extension UserDefault where Value: RawRepresentable {
 
    
    /// Common init. Should be used for enums and option sets.
    private init(defaultValue: Value, key: String, storage: UserDefaults) {
        
        getValue = {
            
            guard let rawValue = storage.value(forKey: key) as? Value.RawValue else {
                return defaultValue
            }
            
            if let value = Value(rawValue: rawValue) {
                return value
            }
            
            return defaultValue
            
        }
        
        setValue = { newValue in
            
            storage.set(newValue.rawValue, forKey: key)
            
        }
        
    }
    
    /// Creates a wrapper for UserDefaults storage for raw representable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value.RawValue == String {
        self.init(defaultValue: wrappedValue, key: key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for raw representable value.
    public init(
        wrappedValue: Value,
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value.RawValue == Int {
        self.init(defaultValue: wrappedValue, key: key, storage: storage)
    }
    
}


// MARK: Nullable RawRepresentable values

extension UserDefault {
 
    
    /// Common init. Should be used for nullable enums and option sets.
    private init<V: RawRepresentable>(
        key: String,
        storage: UserDefaults
    ) where Value == V? {
        
        getValue = {
            if let rawValue = storage.value(forKey: key) as? V.RawValue {
                return V(rawValue: rawValue)
            } else {
                return nil
            }
        }
        
        setValue = { newValue in
            if let newValue = newValue as V? {
                storage.set(newValue.rawValue, forKey: key)
            } else {
                storage.removeObject(forKey: key)
            }
        }
        
    }
    
    /// Creates a wrapper for UserDefaults storage for nullable raw representable value.
    public init<R: RawRepresentable>(
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == R?, R.RawValue == Int {
        self.init(key: key, storage: storage)
    }
    
    /// Creates a wrapper for UserDefaults storage for nullable raw representable value.
    public init<R: RawRepresentable>(
        _ key: String,
        storage: UserDefaults = .standard
    ) where Value == R?, R.RawValue == String {
        self.init(key: key, storage: storage)
    }
    
}
#endif
