//
//  ___HEADERFILE___
//
import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication

class LoginViewModelImpl: LoginViewModel {
    var input: PublishSubject<LoginInput> = PublishSubject()
    var output: BehaviorRelay<LoginOutput> = BehaviorRelay.init(value: LoginOutput(event: nil))
    

    
    
}

extension LoginViewModelImpl {
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<LoginOutput> in
                                switch input {
                                case .login:
                                    return handleLogin()
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handleLogin() -> Observable<LoginOutput> {
        let context = LAContext()
        context.localizedCancelTitle = R.string.localizable.enter_username_password()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = R.string.localizable.log_in_to_account()
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { [unowned self] success, error in
                if success {
                    output.accept(LoginOutput(event: .loginResult))
                } else {
                    print(error?.localizedDescription ?? R.string.localizable.auth_failed())
                }
            }
        } else {
            print(error?.localizedDescription ?? R.string.localizable.can_not_evaluate())
        }
        return .just(LoginOutput(event: nil))
    }
}

protocol LoginViewModel {
    var input: PublishSubject<LoginInput> {get}
    func bindViewModel() -> [Disposable]
    var output: BehaviorRelay<LoginOutput> {get}
}

enum LoginInput: Equatable{
    case login
}

public struct LoginOutput{
    public var event: LoginOutputEvent?
}

public enum LoginOutputEvent{
    case loginResult
}
