//
//  ViewController.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit

final class TableViewController: UIViewController {

    // MARK: - Private properties
    private var viewModel: TableViewModel

    private lazy var modelOfNotes: [NoteModel] = {
        let model = viewModel.notesModel
        return model
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    

    // MARK: - Init
    init(viewModel: TableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addNote)
        )
        //        navigationController?.navigationBar.tintColor = UIColor(named: "dPurple")
        bindViewModel()
    }

    // MARK: - Private methods
    private func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = #colorLiteral(red: 0.9495324492, green: 0.9487351775, blue: 0.9706708789, alpha: 1)
        title = "NotesByVakula"
    }

    private func layout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.insetForCell),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.insetForCell),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.closureChangingState = { [weak self] state in
            guard let self else {return}

            switch state {
            case .none:
                ()
            case .createNoteAndReloadTable:
                modelOfNotes = viewModel.notesModel
                self.tableView.reloadData()

            case .reloadEditedNoteInTable(let indexPaths):
                modelOfNotes = viewModel.notesModel
                self.tableView.reloadRows(at: indexPaths, with: .automatic)
            }
        }
    }

    // MARK: - Actions
    @objc func addNote() {
        viewModel.didTapAddNote()
    }

}

// MARK: - UITableViewDataSource
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else { return UITableViewCell() }

        cell.setupPhotoForTableCell(model: gallery[indexPath.row])
        cell.selectionStyle = .none
        return cell

        guard let cellForPosts = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {return UITableViewCell()}
        cellForPosts.setupCell(model: postModel[indexPath.row])
        cellForPosts.selectionStyle = .none

        let tapGestureAtLikesRecognizer = UITapGestureRecognizer(target: self, action: #selector(increaseLikesAtTap(_:)))
        cellForPosts.likesLabelView.addGestureRecognizer(tapGestureAtLikesRecognizer)
        cellForPosts.likesLabelView.isUserInteractionEnabled = true

        let tapGestureAtImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPostDetailVC(_:)))
        cellForPosts.imageViewForPost.addGestureRecognizer(tapGestureAtImageRecognizer)
        cellForPosts.imageViewForPost.isUserInteractionEnabled = true
        return cellForPosts


        viewModel.showNotes(at: indexPath)

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            postModel.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header.backgroundColor =  #colorLiteral(red: 0.9495324492, green: 0.9487351775, blue: 0.9706708789, alpha: 1)
            return header
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.headerHeight
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return .leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //переход на экран заметки
    }
}


