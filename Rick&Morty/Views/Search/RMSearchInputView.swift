//
//  RMSearchInputView.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 04/05/23.
//

import UIKit

protocol RMSearchInputViewDelegate:AnyObject {
    func rmSearchInputView(_ inputView:RMSearchInputView,
                           didSelectOption option:RMSearchInputViewViewModel.DynamicOption)
    func rmSearchInputView(_ inputView:RMSearchInputView,
                           didChangeSearchText text:String)
    func rmSearchInputViewdidTapSearchKeyboardButton(_ inputView:RMSearchInputView)
                           
}

/// VIew for top part of search screen with search bar
final class RMSearchInputView: UIView {

    weak var delegate:RMSearchInputViewDelegate?
    
    private var stackView:UIStackView?
    
    private let searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search"
        return bar
    }()
    
    private var viewModel:RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionsSelectionView(options: options)
        }
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        searchBar.delegate = self
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func createOptionsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        addSubview(stackView)
         
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        return stackView
    }
    
    private func  createOptionsSelectionView(options: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionsStackView()
        self.stackView = stackView
        for i in 0..<options.count {
            let option = options[i]
            let button = createButton(with: option, tag: i)
            stackView.addArrangedSubview(button)
        }
    }
    
    public func createButton(with option:RMSearchInputViewViewModel.DynamicOption, tag:Int) -> UIButton{
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: option.rawValue,
                                                     attributes: [.foregroundColor:UIColor.label,
                                                                  .font:UIFont.systemFont(ofSize: 18, weight: .medium) ]),
                                  for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_ :)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        return button
    }
    
    @objc private func didTapButton(_ sender:UIButton) {
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selection = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selection)
        //print(selection.rawValue)
    }
    
    
    //MARK: Public
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentKeyBoard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option:RMSearchInputViewViewModel.DynamicOption, value:String) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option)   else {
            return
        }
        
        let button = buttons[index]
        button.setAttributedTitle(NSAttributedString(
            string: value.uppercased(),
            attributes: [.foregroundColor:UIColor.link,
                         .font:UIFont.systemFont(ofSize: 18, weight: .medium) ]),
                                  for: .normal)
    }
}

//MARK: UISearchBarDelegate
extension RMSearchInputView:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewdidTapSearchKeyboardButton(self)
    }
}
