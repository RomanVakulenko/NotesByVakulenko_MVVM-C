//
//  NoteViewController.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit

enum NoteVCState {
    case add, edit
}

final class NoteViewController: UIViewController {

    // MARK: - Private properties
    private var noteState: NoteVCState
    private var viewModel: NoteViewModel

    private lazy var noteStore: NoteStore = {
        return NoteStore.shared
    }()

    private lazy var model: NoteModel? = { [unowned self] in
        self.viewModel.noteModel
    }()

    ///устанавливается после ввода  или уже передается заполненным, если нажали на существующую ячейку - заметку
    private var currentTitle = ""
    private var currentText = ""

    private let baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var noteTitle: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.insetForCell*2, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.placeholder = "Type note title here"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        return textField
    }()

    private lazy var noteTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.text = "    Введите ниже текст заметки"
        return label
    }()

    private lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .darkGray
        textView.delegate = self
        return textView
    }()


    // MARK: - Init
    init(viewModel: NoteViewModel, noteState: NoteVCState) {
        self.viewModel = viewModel
        self.noteState = noteState
        super.init(nibName: nil, bundle: nil)
        self.viewModel.closureChangingText = { [weak self] text in //меняет текст онлайн при вводе
            self?.noteTextView.text = text
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        presetDataForEditingNote()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "< Заметки",
            style: .plain,
            target: self,
            action: #selector(saveNote)
        )
        title = noteState == .add ? "Create new note" : "Read/write note"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if noteState == .add {
            noteTitle.becomeFirstResponder()
        } else {
            noteTextView.becomeFirstResponder()
        }
    }


    // MARK: - Private methods
    private func setupView() {
        [noteTitle, noteTextLabel, noteTextView].forEach { baseView.addSubview($0)}
        view.addSubview(baseView)
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }

    private func layout() {
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            noteTitle.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: Constants.insetForCell),
            noteTitle.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -Constants.insetForCell),
            noteTitle.topAnchor.constraint(equalTo: baseView.topAnchor, constant: Constants.insetForCell),
            noteTitle.heightAnchor.constraint(equalToConstant: Constants.headerHeight),

            noteTextLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: Constants.insetForCell),
            noteTextLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -Constants.insetForCell),
            noteTextLabel.topAnchor.constraint(equalTo: noteTitle.bottomAnchor, constant: Constants.insetForCell),
            noteTextLabel.heightAnchor.constraint(equalToConstant: Constants.headerHeight),

            noteTextView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: Constants.insetForCell),
            noteTextView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -Constants.insetForCell),
            noteTextView.topAnchor.constraint(equalTo: noteTextLabel.bottomAnchor, constant: Constants.insetForCell),
            noteTextView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -Constants.insetForCell),
        ])
    }

    ///предустанавливаем название и текст заметки
    private func presetDataForEditingNote() {
        guard let model else {return}

        if model.name != "" && noteState == .edit {
            currentTitle = model.name
            currentText = model.noteText

            noteTitle.text = currentTitle //model.name
            noteTextView.text = currentText //model.noteText
        }
    }
    // MARK: - Actions
    @objc func saveNote(_ sender: UIBarButtonItem) {
        if noteState == .add {
            //добавляем заметку в store
            noteTitle.text = currentTitle == "" ? "Название заметки не было установлено" : currentTitle
            noteTextView.text = currentText == "" ? "Без текста" : currentText

            noteStore.notes.append(NoteModel(name: currentTitle, noteText: currentText))
            viewModel.didTapBack(at: .add)

        } else if noteState == .edit {
            if let model,
               let tappedNote = noteStore.notes.first(where: { $0.name == model.name }) {
                tappedNote.name = currentTitle
                tappedNote.noteText = currentText
            }
            viewModel.didTapBack(at: .edit)
        }
    }

}

// MARK: - Extensions
extension NoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // textField перестает быть первым откликающимся
        return true
    }
}

extension NoteViewController: UITextViewDelegate {
    func textFieldDidChangeSelection(_ noteTitle: UITextField) {
        currentTitle = noteTitle.text ?? "" //как только текст в noteTitle меняется, то записывается в currentTitle
    }

    func textViewDidChange(_ textView: UITextView) {
        currentText = noteTextView.text
    }
}
