import UIKit

class HabitViewController: UIViewController {
    
    public lazy var newTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.text = "НАЗВАНИЕ"
        return title
    }()
    
    public lazy var colorTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.text = "ЦВЕТ"
        return title
    }()
    
    public lazy var timeTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.text = "ВРЕМЯ"
        return title
    }()
    
    public lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textfield.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textfield.textColor = .black
        textfield.addTarget(self, action: #selector(setTitle), for: .editingDidEnd)
        return textfield
    }()
    
    public lazy var timeText: UILabel = {
        let text = UILabel()
        text.text = "Каждый день в "
        text.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return text
    }()
    
    public lazy var dataPicker: UIDatePicker = {
        let time = UIDatePicker()
        time.datePickerMode = .time
        time.preferredDatePickerStyle = .wheels
        time.locale = .current
        time.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
        return time
    }()
    
    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        let date = dataPicker.date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        formatter.string(from: date)
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    public lazy var selectTimeField: UITextField = {
        let textField = UITextField()
        textField.text = "\(dateFormatter.string(from: dataPicker.date))"
        textField.textColor = UIColor(named: "violet")
        textField.inputView = dataPicker
        textField.tintColor = UIColor(named: "violet")
        return textField
    }()
    
    public lazy var selectColorButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(setColor), for: .touchUpInside)
        return button
    }()
    
    
    /// Gesture
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapDone))
        return tap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(tap)
        view.addSubviews(newTitle, colorTitle, timeTitle, textField, selectColorButton, timeText, selectTimeField, dataPicker)
        setupLayout()
        
        /// Navigation  Bar
        title = "Создать"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "violet")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "violet")
    }
}

private extension HabitViewController {
    
    @objc func cancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveHabit() {
        let newName = textField.text
        guard let name = newName else {return}
        let newColor = selectColorButton.backgroundColor
        guard let color = newColor else {return}
        
        let newHabit = Habit(name: name, date: dataPicker.date, color: color)
        let store = HabitStore.shared
        store.habits.append(newHabit)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func setTitle() {
        _ = textField.text
    }
    
    @objc func setColor() {
        if #available(iOS 14.0, *) {
            let newColor = UIColorPickerViewController()
            newColor.delegate = self
            newColor.selectedColor = selectColorButton.backgroundColor!
            present(newColor, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func timeChanged() {
        selectTimeField.text = dateFormatter.string(from: dataPicker.date)
    }
    
    @objc func tapDone() {
        view.endEditing(true)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectColorButton.backgroundColor = viewController.selectedColor
    }
}

private extension HabitViewController {
    func setupLayout() {
        let constraints = [
            newTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            newTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: newTitle.bottomAnchor, constant: 7),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorTitle.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
            colorTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectColorButton.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 7),
            selectColorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectColorButton.widthAnchor.constraint(equalToConstant: 30),
            selectColorButton.heightAnchor.constraint(equalToConstant: 30),
            timeTitle.topAnchor.constraint(equalTo: selectColorButton.bottomAnchor, constant: 15),
            timeTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeText.topAnchor.constraint(equalTo: timeTitle.bottomAnchor, constant: 7),
            timeText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectTimeField.leadingAnchor.constraint(equalTo: timeText.trailingAnchor, constant: 3),
            selectTimeField.centerYAnchor.constraint(equalTo: timeText.centerYAnchor),
            dataPicker.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: -15),
            dataPicker.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

