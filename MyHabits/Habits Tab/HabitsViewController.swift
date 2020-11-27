
import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(named: "background")
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(collectionView)
        setupLayout()
        collectionView.reloadData()
        //HabitStore.shared.habits.removeAll()
        
        /// Navigation  Bar
        title = "Сегодня"
        navigationController?.tabBarItem.title = "Привычки"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "violet")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HabitStore.shared.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
            cell.layer.cornerRadius = 8
            cell.backgroundColor = .white
            let progress = HabitStore.shared.todayProgress
            cell.progressView.progress = .init(progress)
            cell.percentageLable.text = .init("\(String(Int(HabitStore.shared.todayProgress * 100)))%")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
            cell.habit = HabitStore.shared.habits[indexPath.item]
            cell.markButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            cell.markButton.tag = indexPath.item
            cell.mainTitle.tag = indexPath.item
            cell.layer.cornerRadius = 8
            if cell.habit?.isAlreadyTakenToday == false {
                cell.markButton.backgroundColor = .white
            } else {
                cell.markButton.backgroundColor = .init(cgColor: cell.markButton.layer.borderColor!)
            }
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let sourceVC = HabitsViewController()
            let destinationVC = HabitDetailsViewController()
            _ = UIStoryboardSegue(identifier: "details", source: sourceVC, destination: destinationVC)
            destinationVC.setTitle = HabitStore.shared.habits[indexPath.item].name
            destinationVC.habit = HabitStore.shared.habits[indexPath.item]
            navigationController?.pushViewController(destinationVC, animated: true)
        } else {return}
    }
}


extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let hight: CGFloat = 60
            let width: CGFloat = (collectionView.bounds.width - 32)
            return CGSize(width: width, height: hight)
        } else {
            let hight: CGFloat = 130
            let width: CGFloat = (collectionView.bounds.width - 32)
            return CGSize(width: width, height: hight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 22, left: .zero, bottom: .zero, right: .zero)
        } else {
            return UIEdgeInsets(top: 18, left: .zero, bottom: 22, right: .zero)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let spacing: CGFloat = 12
        return spacing
    }
}


private extension HabitsViewController {
    @objc func addHabit() {
        let newController = HabitViewController()
        let navigationController = UINavigationController(rootViewController: newController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func buttonPressed(sender: UIButton) {
        _ = sender.tag
        let cell = sender.superview?.superview as! HabitCollectionViewCell
        if cell.markButton.backgroundColor == .white {
            sender.backgroundColor = .init(cgColor: sender.layer.borderColor!)
            HabitStore.shared.habit(cell.habit!, isTrackedIn: cell.habit!.date)
            HabitStore.shared.track(cell.habit!)
        } else { return }
    }
}


private extension HabitsViewController {
    func setupLayout() {
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

