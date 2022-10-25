# MeditationContentsList

## 🍎 작동화면

|            작동 화면             |
|:--------------------------------:|
| ![](https://i.imgur.com/Py45w6Q.gif) |


## 🍎 AppleFrameworkWithCompositionalLayout 프로젝트와 많은 부분 비슷하다.

- DiffableDataSource, Snapshot, compositional layout을 사용하는것은 많이 비슷했다.
- 그럼에도 이번 프로젝트에서 새로 발견한 것들을 정리해보자. 먼저 버튼을 눌렀을때 실행되는 코드를 보면..
```swift
@IBAction func changeModeTapped(_ sender: UIButton) {
    curated.toggle()
    self.items = curated ? Meditation.recommendations : Meditation.list
    var snapshot =  NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items, toSection: .main)
    dataSource.apply(snapshot)
    buttonUpdate()
}
```
## 🍎 bool 타입의 .toggle() 메서드
- Bool 타입의 변수에 .toggle() 메서드를 사용하면 원래 가지고 있던 값의 반대값을 넣어준다.
- 예시 코드
    ```swift
    var someBool: Bool = true
    someBool.toggle()
    print(someBool) -> false
    ```
## 🍎 데이터베이스가 바뀌면 snapshot을 다시 적용하자.
```swift
self.items = curated ? Meditation.recommendations : Meditation.list
var snapshot =  NSDiffableDataSourceSnapshot<Section, Item>()
snapshot.appendSections([.main])
snapshot.appendItems(items, toSection: .main)
dataSource.apply(snapshot)
```
- changeModeTapped(_ sender: UIButton) 메서드에서
    - curated의 값을 판단해 self.items에 새로운 값을 넣어준다. 값이 바뀔때 마다 새로운 snapshot을 생성하고 채워준 다음 dataSource에 적용한다. 


## 🍎 dataSource에 적용하는 역할을 하는 apply메서드의 animatingDifferences 값을 false로 주었을때

```swift
dataSource.apply(snapshot, animatingDifferences: false)
```

- ![](https://i.imgur.com/mFucuLk.gif)
- 작동 화면처럼 자연스럽게 바뀌지 않는다. animatingDifferences의 default는 true다.

## 🍎 오토레이아웃 문제
![](https://i.imgur.com/jT2wajy.jpg)
- 앱을 실행하는데는 문제 없지만 현재 무엇을 고쳐야 하는지 잘 몰라서, 나중에 저 경고창을 없앨수 있는 실력을 가졌을때 다시 돌아와서 해결해보자! 
- 2022/10/25 생각-> 화면 아래의 "See Recommendation" 버튼이 collection view의 cell과 같은 공간에 위치하고 있어 경고가 들어오는것으로 추정
