import Foundation

enum ApiState{
    case idle
    case loading
    case success
    case error
}

struct IndicatorState{
    var setup : ApiState = .idle
    var enroll : ApiState = .idle
    var auth : ApiState = .idle
    var deEnroll : ApiState = .idle
}

struct EnabledButtonState{
    var setup : Bool = true
    var enroll : Bool = false
    var auth : Bool = false
    var deEnroll : Bool = false
}
