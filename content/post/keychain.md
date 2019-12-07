---
title: "keychain 사용해보기"
date: 2019-12-07T15:00:00+09:00
draft : false
categories : ["Category"]
tags : ["tags"]
author : ["Elliott (김태인, Denny.k)"]
---
   
이번 포스트에서는 비밀번호, 주민번호 등 민감 정보를 안전하게 처리할 수 있는 Keychain에 대해서 살펴보도록 하겠습니다. 우리는 기존에 데이터를 기기에 저장해두기 위해 UserDefaults를 사용하였었는데 이는 단순 데이터를 저장하기에는 문제가 없으나 비밀번호, 인증서, 개인 정보 등 민감한 정보를 저장하기에는 base-64로 인코딩해서 저장하는 것으로 충분하지 않는가? 라고 생각할 수 있겠지만 이는 보안 상 결코 안전하지 않습니다.

### 1\. KeyChain 이란?

컴퓨터 사용자는 종종 안전하게 보관해야하는 작은 비밀을 가지고 있습니다. 예를 들어, 대부분의 사람들은 수많은 온라인 계정을 관리합니다. 각각에 대해 복잡하고 고유한 암호 (Unique Passwords)를 기억하는 것은 불가능하지만 암호를 적어 두는 것은 안전하지 않습니다. 사용자는 일반적으로 여러 계정에서 간단한 비밀번호를 재활용(Reuse)하여 이러한 상황에 대응하며, 이는 안전하지 않습니다.

**Keychain Services API**는 Keychain 이라는 암호화 된 데이터베이스(Encrypted Database)에 작은 비트의 사용자 데이터를 저장하는 메커니즘을 앱에 제공하여 이 문제를 해결하는 데 도움이됩니다. 암호를 안전하게 기억하면 사용자가 복잡한 암호를 자유롭게 선택할 수 있습니다.

Keychain은 아래 그림과같이  암호에 국한되지 않습니다. 신용  카드  정보  또는  짧은  메모와  같이  사용자가  명시적으로  신경을 쓸 수 있는  다른  비밀 또한저장할  수  있습니다. 사용자에게  필요하지만  알지  못하는  항목을  저장할  수도  있습니다. 예를  들어  인증서(Certificate), 키  및  트러스트  서비스로  관리하는  암호화  키  및  인증서를  통해  사용자는  보안  통신 (Secure Networking) 을  수행하고  다른  사용자  및  장치와  트러스트를  설정할  수  있습니다. 키  체인을  사용하여  이러한  항목도  저장합니다.

Keychain은 하나의 암호화된 Container입니다. 민감 데이터가 저장되는 단위를 item이라고 합니다. 기본적으로 기기가 잠금 상태가 되면 Keychain역시 잠금 상태가 되며 잠금 상태에서는 Item들에 접근도 못하며 복호화를 할 수도 없습니다. 또한 잠금 상태가 해제된 상태에서도 해당 Item을 생성하고 저장한 Application에서만 접근이 가능합니다. 하지만 지정된 그룹에 속한 Application 끼리는 데이터에 접근할 수 있습니다.

![Image](https://docs-assets.developer.apple.com/published/0ddea9db46/1c9e8103-fae2-45f4-832c-c528d2e0c2f6.png)

### 2\. Keychain Items

암호  또는  암호화  키와  같은  비밀을  저장하려면 해당 데이터를 **Keychain Item**으로 **Packaging**합니다. Packaging 된 Item에는 저장하기 위한 데이터 뿐만 아니라**Item**의  접근성을  제어하고  검색  할  수  있도록  공개적으로  표시되는 **Attribute Set**를  제공합니다. 아래 그림과  같이 Keychain Services는  디스크에  저장된  암호화  된  데이터베이스인 **Keychain**의데이터  암호화  및  저장 (**Data Attributes are Included**)을  처리합니다. 나중에  승인  된  프로세스는 Keychain Services를  사용하여  항목을  찾고  데이터를  해독합니다.
![Image](https://docs-assets.developer.apple.com/published/0ddea9db46/0304151a-f84e-44b1-8632-6698ec59854b.png)

### 3\. Keychain 사용하기

Keychain을 사용하려면 C 언어로 주로 구현된 보안 프레임워크를 사용해야 합니다. 하지만 다행스럽게도 Apple은 Swift로 조금 더 상위 레벨에서 Keychain을 구현할 수 있도록 Wrapper를 구현해주었습니다. 

이 포스트에서는 더 간편하게 사용할 수 있도록 오픈 소스로 구현된 **SwiftKeychainWrapper**를 사용하여 KeyChain을 사용해보도록 하겠 습니다. 사용법은 UserDefaults를 사용하는 것과 유사하게 사용할 수 있습니다.

**(SwiftKeychainWrapper GitHub Link)**

[https://github.com/jrendel/SwiftKeychainWrapper](https://github.com/jrendel/SwiftKeychainWrapper)

Keychain Set 함수의 첫 번째 Parameter는 값인데 UserDefaults와 다르게 Nullable 이 아닌 값이 들어가야 합니다.

즉, accessToken? 이 아니라 accessToken! 혹은 accessToken ?? ""와 같이 값이 들어가야 합니다.

```swift
let saveSuccessful: Bool = KeychainWrapper.standard.set("Some String", forKey: "myKey")
let retrievedString: String? = KeychainWrapper.standard.string(forKey: "myKey")
let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "myKey")
```

위 코드는 기본적인 키체인 값 설정, 키체인 값 불러오기, 키체인 오브젝트 제거 함수를 나타낸 코드입니다.

UserDefaults와 상당히 유사하기 때문에 사용하기 굉장히 편리합니다.

**좀 더 깊게 사용해보기**

Keychain Wrapper를 사용하면 모든 키가 서비스 이름이라는 앱의 공통 식별자에 연결됩니다. 기본적으로 기본 Bundle Identifier를 사용합니다. 그러나 변경하거나 다른 식별자로 여러 항목을 KeyChain안에 저장할 수도 있습니다. Application 간에 키 체인 항목을 공유하려면 액세스 그룹을 지정하고 각 Application에서 동일한 액세스 그룹을 사용할 수 있습니다. (위에 설명한 것 처럼 그룹을 지정하여 공유할 수 있는 기능을 의미합니다.) 사용자 지정 서비스 이름 식별자 또는 액세스 그룹을 설정하려면 다음과 같이 고유 KeyChain Wrapper Instance를 만들 수 있습니다.

```swift
let uniqueServiceName = "customServiceName"
let uniqueAccessGroup = "sharedAccessGroupName"
let customKeychainWrapperInstance = KeychainWrapper(serviceName: uniqueServiceName, accessGroup: uniqueAccessGroup)
```

그런 다음 공유 인스턴스 또는 static accessor 대신 **사용자 정의 인스턴스**를 사용할 수 있습니다.

```swift
let saveSuccessful: Bool = customKeychainWrapperInstance.set("Some String", forKey: "myKey")
let retrievedString: String? = customKeychainWrapperInstance.string(forKey: "myKey")
let removeSuccessful: Bool = customKeychainWrapperInstance.removeObject(forKey: "myKey")
```

기본적으로 KeyChain에 저장된 모든 항목은 장치가 잠금 해제 된 경우에만 접근할 수 있습니다. 이 Accessibility을 변경하기 위해 모든 요청에 대해 선택적으로 withAccessibility Parameter를 설정할 수 있습니다. enum Type인 KeychainItemAccessibilty를 사용하여 개발자가 원하는 Accessibility Level을 선택할 수 있습니다.

```swift
KeychainWrapper.standard.set("Some String", forKey: "myKey", withAccessibility: .AfterFirstUnlock)
```

선택할 수 있는 **withAccessibility 항목**은 아래와 같습니다.

afterFirstUnlock   
afterFirstUnlockThisDeviceOnly   
always   
alwaysThisDeviceOnly   
none   
whenPasscodeSetThisDeviceOnly   
whenUnlocked   
whenUnlockedThisDeviceOnly   
   
이번 포스트에서는 키체인의 개요와 간단한 사용법에 대해 알아보았습니다.   
기타 내용은 아래 주소를 참고해주시기 바랍니다.   
[Elliott Blog](https://terry-some.tistory.com)   
