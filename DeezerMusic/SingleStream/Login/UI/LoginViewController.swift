//
//  
//  LoginViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 22.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//
//
import UIKit
import SnapKit
import RxCocoa
import RxSwift
class LoginViewController: UIViewController {
    weak var loginNavigationDelegate: LoginNavigationDelegate?
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.welcome()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.login().capitalized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 8
        return button
    }()
    let disposeBag = DisposeBag()
    let viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
}

private extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(views: [welcomeLabel, loginButton])
        setupConstraints()
    }
    
    func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(40)

        }
    }
    
    func bindViewModel() {
        disposeBag.insert(viewModel.bindViewModel())
        
        viewModel.output
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (output) in
                guard let safeEvent = output.event else { return }
                switch safeEvent{
                case .loginResult:
                    loginNavigationDelegate?.openHomeScreen()
                }
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                viewModel.input.onNext(.login)
            })
            .disposed(by: disposeBag)
    }
}
