
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
        view.addSubviews(tableView)
        setupLayout()
        title = setTitle
        
        /// Navigation  Bar
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
        cell.dateLabel.text =  dateFormatter.string(from: info)
        if HabitStore.shared.habit(habit!, isTrackedIn: info) == true {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(named: "violet")
        } else { return cell }
        return cell }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0))
        header.backgroundColor = UIColor(named: "background")
        
        let textTitle: UILabel = {
            let title = UILabel()
            title.text = "АКТИВНОСТЬ"
            title.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            title.textColor = .systemGray
            return title
        }()
        
        header.addSubviews(textTitle)
        
        let constraints = [
            textTitle.topAnchor.constraint(equalTo: header.topAnchor, constant: 20),
            textTitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            textTitle.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
        
        return header
    }
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
