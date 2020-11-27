
import UIKit

class HabitDetailsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(DetailsTableViewCell.self, forCellReuseIdentifier: String(describing: DetailsTableViewCell.self))
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 50
        return tv
        
    }()
    
    private lazy var textTitle: UILabel = {
        let title = UILabel()
        title.text = "АКТИВНОСТЬ"
        title.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        title.textColor = .systemGray
        return title
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .current
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    var dates = HabitStore.shared.dates
    var setTitle: String?
    var habit: Habit?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        view.addSubviews(tableView,textTitle)
        setupLayout()
        title = setTitle
        
        /// Navigation  Bar
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editNav))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "violet")
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailsTableViewCell.self), for: indexPath) as! DetailsTableViewCell
        
        let sortedDates = dates.sorted(by: {$0 > $1})
        let info = sortedDates[indexPath.item]
        cell.dateLable.text =  dateFormatter.string(from: info)
        if HabitStore.shared.habit(habit!, isTrackedIn: info) == true {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(named: "violet")
        } else { return cell }
        return cell }
}

extension HabitDetailsViewController: UITableViewDelegate{
}


extension HabitDetailsViewController {
    @objc func editNav() {
        let newController = HabitEditViewController()
        let navigationController = UINavigationController(rootViewController: newController)
        navigationController.modalPresentationStyle = .automatic
        newController.habit = habit
        present(navigationController, animated: true, completion: nil)
    }
}

private extension HabitDetailsViewController {
    func setupLayout() {
        let constraints = [
            textTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: textTitle.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
