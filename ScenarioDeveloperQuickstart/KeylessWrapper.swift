@preconcurrency import KeylessSDK

class KeylessWrapper {
    
    var isEnrolled: Bool = false
    
    func setup(apiKey:String, hosts:[String]) async throws {
        
        let setupConfig = SetupConfig(apiKey: apiKey, hosts: hosts)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            
            Keyless.configure(setupConfiguration: setupConfig) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    func isUserAndDeviceActive () async throws -> Bool {
        try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation <Bool, Error>) in
            Keyless.validateUserDeviceActive{ error in
                if let error = error {
                    continuation.resume(throwing: error)
                }else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func enroll() async throws {
        
        let enrollConfig = BiomEnrollConfig()
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            DispatchQueue.main.async {
                
                Keyless.enroll(configuration: enrollConfig, onProgress: nil) { result in
                    switch result {
                    case .success(_):
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func authenticate() async throws {
        
        let authConfig = BiomAuthConfig()
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            DispatchQueue.main.async {
                
                Keyless.authenticate(configuration: authConfig) { result in
                    switch result {
                    case .success(_):
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func deEnroll() async throws {
        
        let deEnrollConfig = BiomDeEnrollConfig()
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            DispatchQueue.main.async {
                
                Keyless.deEnroll(deEnrollmentConfiguration: deEnrollConfig) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
        }
    }
    
    func reset() {
        if let error = Keyless.reset(){
            print("Keyless.reset() failed with error: \(error)")
        }
    }
    
}

