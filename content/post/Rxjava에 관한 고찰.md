---
title: "Rxjava에 관한 고찰"
date: 2020-02-18T23:30:30+09:00
draft : false
categories : ["develop"]
tags : ["rxjava", "Android"]
author : ["mintpark"]
---

안녕하세요 유어슈에서 안드로이드 개발을 맡고 있는 박정현입니다

오늘은 요즘 많이 사용되고 있는 반응형 프로그래밍에 대해 알아볼까 합니다

반응형 프로그래밍이란 기존의 명령형 방식이 아닌 데이터의 흐름에 따라 동작하게 되는 프로그래밍 기법입니다

안드로이드에서 이를 위해서 가장 많이 사용하는 것이 Rxjava(reactive java) 즉 반응형 프로그래밍을 위한 라이브러리의 일종입니다

때문에 Rxjava에 대해서, 그 중에서도 Observable 객체와 관련된 객체들 그리고 몇가지 연산자에 대한 글을 작성해 보려고 합니다

<br/>


Rxjava에서 반응형 프로그래밍을 하기 위해선 기본적으로 Observable 객체를 생성하고 이를 구독하게 되면 
그 순간부터 데이터가 배출되기 시작해 미리 지정해둔 코드를 실행하게 됩니다
(Hot Observable과 cold Observable 에 대해서는 이 포스트에서 다루지 않습니다)

<br/><br/>
## Observable

우선 기본적인 Observable을 만들어 보겠습니다

```kotlin
val test = Observable.just(1,2,3,4)
```

just는 Observable을 생성하는 기본 연산자 입니다

item이 1,2,3,4가 등록되어 있군요



자 그럼 구독을 한번 해보겠습니다

```kotlin             
test
        .observeOn(Schedulers.io())
        .subscribe {
            Timber.d("$it")
        }
```

observeOn 이 연산자는 구독후 배출된 아이템에 대해서 어떤 스레드에서 처리할 것인지 정해주는 역할을 합니다

저는 비동기로 처리하기 위해서 `Schedulers.io()`에 할당하겠습니다

그리고 subscribe를 통해 동작을 지정해줍니다

자 이렇게 하고 실행을 한다면 Observable 객체는 1,2,3,4 각각의 아이템을 배출하게 되고 이는 비동기로 처리되어 로그를 출력하게 됩니다 
(Timber는 로그를 쉽게 출력할 수 있도록 도와주는 라이브러리 입니다)

<br/><br/>

일단 여기까지만 본다면 가장 기본적인 Observable의 사용법에 대해 알아봤다고 할 수 있을것 같습니다

하지만 제가 이 포스트를 통해 말하고 싶었던건 Observable 객체 이외에 Flowable Single Maybe Completable 객체에 관한 내용입니다

일단 언급한 4개의 객체 모두 기본적으론 Observable과 같은 역할을 하는 객체들입니다 그리고 Rxjava2에서 나온 개념이기도 하죠

이제부터 어떤 차이가 있는지 알아보도록 하겠습니다

## Flowable
Flowable은 기능만 두고 보자면 정말 Observable과 같지만 어찌 보면 Rxjava2가 나오게 된 이유라고도 할 수 있을거 같습니다

### Observable의 한계
기존의 Observable은 너무 많은 아이템을 배출하면서 로직이 복잡하지면 처리속도가 배출속도를 따라가지 못해 out of memory가 발생할 수 있습니다
이러한 개념을 배압이라고 하는데요

<br/>

이 배압을 해결하기 위해 나온것이 Flowable 입니다 Flowable은 배압이 발생할때 배압에 대한 처리를 할수 있는 메소드가 존재하고
버퍼를 사용해 관리할 수 있게 됩니다

아래는 둘 중 어느 객체를 선택해야 되나에 대한 기준입니다

#### Observable

1. 최대 1000개 미만의 데이터 흐름, Out of Memory Exception 이 발생할 확률이 적은 경우

2. 마우스, 터치 이벤트를 다루는 GUI 프로그래밍, 초당 1000회 이하의 이벤트를 다룸



#### Flowable

1. 10000개 이상의 데이터를 처리하는 경우, 메서드 체인에서 데이터 소스에 데이터 개수 제한을 요청해야 함

2. 디스크에서 파일을 읽어 들일 경우

3. JDBC를 활용해 데이터베이스의 쿼리 결과를 가져오는 경우

4. 네트워크 I/O를 실행하는 경우 ( 서버에서 가져오길 원하는 만큼의 데이터양을 요청할 수 있을 때 )

<br/>

## Single
```kotlin
val test = Single.just(1)

test
        .observeOn(Schedulers.io())
        .subscribe { t ->
            Timber.d("$t")
        }
```

Single은 하나의 아이템만 배출하도록 강제한 객체입니다 이 특성을 활용해서 네트워크 로직의 데이터를 가져올때 주로 사용합니다
서버 응답은 보통 하나인 경우가 많기 때문입니다

<br/>

## Maybe
```kotlin
val test = Maybe.fromCallable { null }

test
        .observeOn(Schedulers.io())
        .subscribe { t ->
            Timber.d("$t")
        }
```

Maybe는 Single과 마찬가지로 하나의 아이템만 배출하도록 강제한 객체이지만 값이 없는 경우에 데이터 발행 없이 완료가 가능합니다

<br/>

## Completable
```kotlin
val test = Completable.fromAction { /*function*/ }

test
        .observeOn(Schedulers.io())
        .subscribe {
            // next function
        }
```

Completable은 아이템이 배출되어도 반환값이 없는 동작을 수행할때 사용하게 됩니다

<br/><br/>


##
이상으로 Rxjava에서 사용되는 객체에 대해 알아봤는데요 Observable만 써도 구현 가능한 부분이 많지만 
Rx를 시작할 때라도 이런 객체가 있다라는 것을 인지하고 적절하게 사용하도록 노력한다면 좋은 공부가 될거라 생각합니다

추가로 Rx에 대한 몇가지 연산자를 더 알아보겠습니다

많은 연산자가 있지만 제가 오늘 소개시켜 드리고 싶은 건

FlatMap, SwitchMap, ConcatMap 이 세가지에 대해서 비교해 보겠습니다

<br/>

## FlatMap 
우선 FlatMap은 배출된 아이템들을 다른 형태로 변환하여 다시 Observable의 형태로 반환하는 연산자 입니다
각각의 아이템에 대해서 어떠한 연산이 필요할 때 많이 사용합니다

## SwitchMap
SwitchMap은 아이템이 배출될 때 배출된 아이템에 대해 지정해둔 로직을 처리하다 새로운 아이템이 배출된다면 기존의 작업을 중단하고
새로운 아이템에 대해서 다시 로직을 수행합니다 이러한 특성때문에 결과물은 항상 하나의 아이템만 나오게 되고 이를 가장 대표적으로 활용하는
부분은 아마 실시간 검색이 아닐까 생각합니다

## ConcatMap 
아마 위의 설명을 보고 FlatMap을 사용해 본 사람이라면 그리고 비동기로 처리해본 사람이라면 기본적으로 아이템 배출에 관해서 순서대로 처리하지
않는다는것을 알게 될겁니다 ConcatMap은 이러한 문제를 해결하고자 이전 아이템에 대한 로직이 수행중이라면 새로운 아이템이 배출되어도 대기하고 있다
로직을 수행합니다 이러한 특성은 순서를 보장해주지만 어찌 보면 multicasting의 의미를 잃어버려 시간소요가 길어지게 됩니다

<br/>

# 정리
오늘은 Rxjava를 사용하면서 잊어버릴수 있는 기본개념에 대해서 정리해 보았습니다 어쩌다 보니 고찰이라기 보단 정리가 되어버렸네요
하지만 그만큼 중요한 개념이고 정리해두어서 손해볼게 없는 부분이라고 생각합니다 이 글을 보는 모든 분들께 도움이 되면 좋겠습니다 ㅎㅎ 

