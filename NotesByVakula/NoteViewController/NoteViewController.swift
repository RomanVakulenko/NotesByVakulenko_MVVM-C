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

    private var viewModel: NoteViewModel


    private var noteState: NoteVCState
    ///устанавливается после ввода  или уже передается заполненным, если нажали на существующую ячейку - заметку
    private var currentTitle = ""

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
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        return textField
    }()

    private lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = self
        return textView
    }()


    // MARK: - Init
    init(viewModel: NoteViewModel, noteState: NoteVCState) {
        self.viewModel = viewModel
        self.noteState = noteState

        self.viewModel.closureChangingText = { [weak self] text in //меняет текст онлайн при вводе
            self?.noteTextView.text = text
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        noteTextView.text = viewModel.noteText //показываем текст заметки при ее открытии
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Список заметок",
            style: .plain,
            target: self,
            action: #selector(backToTableViewController)
        )
        title = noteState == .add ? "Создать заметку" : "Править заметку"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextView.becomeFirstResponder()
    }


    // MARK: - Private methods
    private func setupView() {
        [noteTitle, noteTextView].forEach { baseView.addSubview($0)}
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

            noteTextView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: Constants.insetForCell),
            noteTextView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -Constants.insetForCell),
            noteTextView.topAnchor.constraint(equalTo: noteTitle.bottomAnchor, constant: Constants.insetForCell),
            noteTextView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -Constants.insetForCell),
        ])
    }


    ///предустанавливаем название и текст заметки
    private func presetDataForEditingHabit() {
        guard let model else {return}
        if model.name != "",
           habitState == .edit {
            currentTitle = model.name
            currentDate = model.date
            currentColor = model.color

            deleteButton.isHidden = false

            nameOfHabit.text = currentTitle
            nameOfHabit.textColor = currentColor
            pickerButton.tintColor = currentColor //для "Править", если цвет был - то оставляем
            datePicker.date = currentDate

            pickedTime.text = Format.timeForHabitRepeats.string(from: currentDate)
            pickedTime.textColor = UIColor(named: "dPurple")
            colorPicker.selectedColor = currentColor
        }
    }
    //MARK: - actions
    @objc func backToHabitsViewController() {
        viewModel.didTapBack()
    }
}

// MARK: - Extension
extension NoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // textField перестает быть первым откликающимся
        return true
    }
}

extension NoteViewController: UITextViewDelegate {
    func textFieldDidChangeSelection(_ noteTitle: UITextField) {
        currentTitle = noteTitle.text ?? "" //как только текст в noteTitle меняется, то записывается в currentTitle
        if noteState == .add {
            noteTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateNoteText(textView.text)
    }


}
