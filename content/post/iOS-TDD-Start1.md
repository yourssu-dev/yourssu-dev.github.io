---
title: "IOS TDD 시작하기1"
date: 2019-11-17T01:10:26+09:00
draft: false
categories : ["iOS"]
tags : ["iOS"]
author: ["한상준"]
---

# iOS Test Driven Development 시작하기 1
안녕하세요. 유어슈에서 iOS 개발을 리드하고 있는 앤드류입니다 :) 저는 앞으로 유어슈 기술블로그에서 iOS TDD를 연재할 계획입니다. 글솜씨가 좋지 못해서 여러분에게 제대로 정보를 전달할 수 있을지 걱정도 되는데 잘못된 내용이나, 고치면 좋은 부분은 댓글로 남겨주시면 감사하겠습니다.

## Unit Tests시작하기
iOS에서 테스트를 시작할 때 기본적으로 Unit Tests, UI Tests 이 두가지를 할 수 있습니다. Unit Tests의 경우 우리가 직접 작성한 코드들을 테스트해볼 수 있는 기능이며 UI Tests는 실제 구동을 했을 때 디바이스에서 작동하는 테스트입니다. 우리는 Unit Tests먼저 시작합니다 :)

먼저 프로젝트를 하나 생성합니다. 프로젝트 생성할 때 주의할 점은 
`Include Unit Tests`
`Include UI Tests`
를 반드시 체크해주셔야 합니다. 
물론 위 항목을 체크하지 않아도 나중에 직접 Unit Tests, UI Tests를 추가할 수 있습니다. 하지만 이건 매우 번거로운 과정이므로 미리 추가하는걸 추천드립니다 ㅎㅎ
![][image-1]

프로젝트가 생성되었으면 `ViewController`에  간단한 코드를 추가해봅시다. 
<pre><code class="swift">

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func andrewNeedLunch(isHungry:Bool) -> Bool{
        if isHungry {
            return true
        }else {
            return false
        }
    }
}

</code></pre>

저는 `andrewNeedLunch`라는 함수를 추가했습니다. 배가 고프면 점심이 필요함을 나타내고 배가 안고프면 점심을 먹지않는 그런 함수입니다. 그러면 이 함수가 제대로 동작하는지 알기 위해서는 어떻게 해야하죠? 우리는 늘 그랬듯이 `viewDidLoad()` 메소드에 해당 함수를 넣을거에요. 하지만 `viewDidLoad()` 에  `andrewNeedLunch` 함수를 넣고 실행하면 먼저 가상머신(혹은 자신의 iphone)에 앱이 설치되고, 실행되고, 그리고 뷰가 로드되는 과정을 거쳐야만 결과를 확인할 수 있습니다. 물론 지금은 아주 간단하고 짧은 코드여서 빌드시간이 오래걸리지 않지만 코드가 많아지고 뷰가 로드되는 시점에 많은 다른 기능들이 동작한다면 효율적인 방법은 아닌것 같습니다. 그러면 좀 더 효율적으로  `andrewNeedLunch` 가 잘 동작하는지 확인하기 위해 Test 코드를 작성해봅시당.

## Test Code 작성하기
프로젝트 폴더 구조를 유심히 보면 `자신의프로젝트이름Tests`폴더와 `자신의프로젝트이름UITests` 폴더를 찾을 수 있습니다. 저는 프로젝트이름을 YourssuTDD로 했으니 YourssuTDDTests 폴더에 있는 YourssuTDDTests.swift파일을 열었습니당.

## 프로젝트 임포트 하기
가장먼저 우리가 해야할 것은 Test해볼 대상을 가져오는것 입니다. 우리가 외부 라이브러리를 사용할 때 Import를 하는 것 처럼 제가 테스트할 프로젝트를 import 합니다. 
<pre><code class="swift">
@testable import YourssuTDD
</code></pre>

이렇게 임포트를 하면 YourssuTDD 프로젝트에 있는 여러 객체, 혹은 메소를 직접 사용할 수 있습니다. 

## 테스트 메소드 작성하기
다음으론 테스트 클래스에 자신이 테스트할 함수를 생성하면 됩니다. 
<pre><code class="swift">

class YourssuTDDTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewController(){
        let vc = ViewController()
        let hungryStatus = true
        if hungryStatus == vc.andrewNeedLunch(isHungry: hungryStatus){
            XCTAssertTrue(true)
        }else{
            XCTAssertTrue(false)
        }
    }
}

</code></pre>

저는 `testViewController()` 메소드를 만들었습니다. 위 클래스에 기본적으로 여러 메소드들이 생성되어 있는데 이는 다음 포스트때 설명드리겠습니다 :) 
`testViewController()`를 들여다 보면 `ViewController()`를 생성하고 `andrewNeedLunch` 메소드를 직접 실행해 배고픈 상태와 점심을 먹을지 값을 비교하고 있습니다. 여기서 기억해야할 점은 `XCTAssertTrue()`인데용, `XCTAssertTrue(true)`는 테스트 성공, `XCTAssertTrue(false)`는 테스트가 실패한 결과에 넣어주면 됩니다. 저는 `hungryStatus` 와 `andrewNeedLunch` 메소드의 리턴 결과가 같을땐 테스트 성공을, 다를땐 테스트 실패를 나타내기 위해서 위와 같이 코드를 작성하였습니다. 

## 테스트 하기
이제 테스트를 해보겠습니다. 메소드 왼쪽에 위치한 플레이 버튼을 꾹 누르면 테스트가 시작됩니다. 
테스트 결과에 따라 버튼 색이 변경되는데용, 성공하면 초록색 체크 버튼으로, 실패하면 빨강색으로 변경됩니다. 
![][image-2]
![][image-3]
만약 `ViewController`의 코드를 아래처럼 수정하면 테스트는 실패할 것 같네요 :)
<pre><code class="swift">
public func andrewNeedLunch(isHungry:Bool) -> Bool{
        if isHungry {
            return !true
        }else {
            return !false
        }
    }
</code></pre>
![][image-4]

## 정리
- 테스트할 프로젝트를 import한다
- 테스트 클래스에서 테스트 메소드를 생성해준다
- 자신이 원하는 테스트 결과에 따라 적절하게 코드를 작성한 후 테스트! 
이번 포스트에서는 아주 간단하게 테스트 코드를 작성하고 이를 실행해봤습니다. 
사실 테스트 코드를 작성한다고 하면, 뭔가 되게 귀찮고 어려울 것 같은데 막상 해보면 재밌고 쉽습니다 :)
다음시간에는 앞서 언급했듯 `XCTestCase` 의 메소드를 알아보고 더 재밌는 내용을 준비해보겠습니당 ㅎㅎ

[image-1]:    https://raw.githubusercontent.com/escapeanaemia/yourssu-blog-image/master/iOS-TDD-start1/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202019-11-16%20%EC%98%A4%ED%9B%84%2011.54.32.png
[image-2]:    https://raw.githubusercontent.com/escapeanaemia/yourssu-blog-image/master/iOS-TDD-start1/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202019-11-17%20%EC%98%A4%EC%A0%84%2012.24.23.png
[image-3]:    https://raw.githubusercontent.com/escapeanaemia/yourssu-blog-image/master/iOS-TDD-start1/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202019-11-17%20%EC%98%A4%EC%A0%84%2012.24.16.png
[image-4]:    https://raw.githubusercontent.com/escapeanaemia/yourssu-blog-image/master/iOS-TDD-start1/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202019-11-17%20%EC%98%A4%EC%A0%84%2012.23.41.png
