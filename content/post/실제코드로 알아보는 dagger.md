---
title: "실제코드로 알아보는 dagger"
date: 2019-12-7T20:35:04+09:00
draft: false
categories: ["Android"]
tags: ["Android", "dagger", "DI"]
author: ["mintPark"]
---

# 실제코드로 알아보는 dagger

유어슈에서 안드로이드 개발을 하고 있는 박정현입니다 오늘은 Android에서 DI(dependence injection) 문제를 해결하기 위해
가장 많이 쓰이고 있는 dagger2에 대해 보다 쉽게 알아보겠습니다

처음 안드로이드 개발을 시작하는 분들은 dagger의 필요성을 인식하지 못하는 것 같습니다 사실 저도 그런 사람들 중에 한명이었습니다 하지만 항상 극한의 상황을 생각해야 하는 프로그래머의 현실;;

사실 어느정도 규모의 어플을 개발하다 보면 의존성 문제라는 것에 직면하게 되는 시기가 찾아오는 것 같습니다

하지만 dagger 혼자 시작하기도 힘들고 개념이나 사용법을 공부한다 하더라고 막상 어떻게 적용해야 할지 막막한 것이 현실입니다 저도 이해하는데 너무나 오래 걸렸고 사실 지금도 제대로 이해했는지 확신이 들지 않을 정도로 러닝커브가 긴 기술인것 같습니다

그런 분들을 위해 이 포스트는 dagger에 관련된 개념보다는 실제 코드 위주로 설명할 생각입니다

(사실 dagger에 관한 개념이나 전문적인 내용은 다른 곳에서 잘 찾아 볼수 있지만 그런 내용들을 보고 실제로 사용할 때 참고하면 좋을 것 같습니다)

그래도 포스트를 보는 분들의 편의성을 위해서 간단하게 개념 설명은 하고 넘어가야겠죠!

#

## DI (dependence injection)

이를 설명하기 위해선 DI(의존성 주입)에 대해 먼저 이야기해야 할것 같습니다

다른곳에서 이야기하는 개념을 먼저 설명하자면 의존성을 주입하는 이유는 Class A 가 Class B를 내부에 그냥 가지고 있으면 변하는 Class B가 변경된다거나 새롭게 Class C 를 생성해야하는 상황이 오면 매번 모든 class를 고쳐야한다고 합니다 이를 해결하기 위해 외부에서 객체를 생성해서 setter 같은 메소드를 이용해 객체를 주입하는 과정을 의존성 주입이라고 한다 하네요

여러분들은 이해가 가나요? 흠 대충 이해는 할수도 있을거 같긴 하네요 개념적으로는요 근데 정확히 어떤 상황이고 어떤 코드를 말하는건지 저는 감이 잘 안왔습니다

그럼 실제 상황을 고려해서 retrofit을 사용하는 상황이라고 생각해 봅시다 일반적인 상황이라면 그냥 하나의 retrofit을 사용하겠죠?
근데 만약 대부분의 API 에서 accessToken을 header에 담아 보내고 몇가지 API만 refreshToken을 담아 보내는 상황이라고 생각해봅시다

그럼 각각의 API를 불러올때마다 accessToken과 refreshToken을 담아서 작동시킬까요?
가능은 하겠지만 그다지 효율적인 방법은 아닌거 같네요 `그럼 보통 accessToken이 많으니 accessToken을 헤더에 미리 담아둬서 retrofit 객체를 만들어야겠네!` 음????
그럼 refreshToken은...?

아.... 여기까지 보셨으면 왜 의존성 주입이 필요한지 감이 오셨을거라 생각합니다

다시 개념을 볼까요

`외부에서 객체를 생성해서 주입`

음 그렇다면 accessToken을 담고 있는 retrofit 객체와 refreshToken을 담고 있는 retrofit 객체를 만들어 두고 필요할때마다 불러와서 쓰면 되겠네!!

라는 결론에 도달했습니다 여기까지 DI가 필요한 이유, 어디에 쓰이는지 생각해봤습니다

그럼 실제로 한번 적용해봐야겠죠!

#

## Dagger 의 기본개념

1. Inject
2. Component
3. Subcompoenet
4. Module
5. Scope

Inejct

의존성 주입을 요청합니다. Inject 어노테이션으로 주입을 요청하면 연결된 Component가 Module로부터 객체를 생성하여 넘겨줍니다.

Component

연결된 Module을 이용하여 의존성 객체를 생성하고, Inject로 요청받은 인스턴스에 생성한 객체를 주입합니다. 의존성을 요청받고 주입하는 Dagger의 주된 역할을 수행합니다.

Subcomponent

Component는 계층관계를 만들 수 있습니다. Subcomponent는 Inner Class 방식의 하위계층 Component 입니다. Sub의 Sub도 가능합니다. Subcomponent는 Dagger의 중요한 컨셉인 그래프를 형성합니다. Inject로 주입을 요청받으면 Subcomponent에서 먼저 의존성을 검색하고, 없으면 부모로 올라가면서 검색합니다.

Module

Component에 연결되어 의존성 객체를 생성합니다. 생성 후 Scope에 따라 관리도 합니다.

Scope

생성된 객체의 Lifecycle 범위입니다. 안드로이드에서는 주로 PerActivity, PerFragment 등으로 화면의 생명주기와 맞추어 사용합니다. Module에서 Scope을 보고 객체를 관리합니다.

출처: https://medium.com/@maryangmin/di-%EA%B8%B0%EB%B3%B8%EA%B0%9C%EB%85%90%EB%B6%80%ED%84%B0-%EC%82%AC%EC%9A%A9%EB%B2%95%EA%B9%8C%EC%A7%80-dagger2-%EC%8B%9C%EC%9E%91%ED%95%98%EA%B8%B0-3332bb93b4b9

#

자 위의 내용은 다른 블로그에서 가져온 dagger의 정의입니다 여러분들은 이해가 가시나요? 흠 저는 느낌이 팍 오진 않네요

```kotlin
@Module
class APIModule {

    @SuppressLint("DefaultLocale")
    @Provides
    @Singleton
    @ForAuthAPI
    fun AuthRetrofit(@ForAccessToken okHttpClient: OkHttpClient, ...
```

바로 실제 코드를 봅시다 저희가 개발하고 있는 코드중 일부이며 일단 `@Module`로 Module이라는 것을 알려주고 있네요

`@Provides`로 객체를 만든다는걸 명시해주고 `@Singleton`으로 싱글톤패턴이라는 것도 명시하고 있군요 근데 `@ForAuthAPI`는 뭘까요?

사실 dagger를 사용하기 이전에 customAnnotation을 만들어 두었습니다

```kotlin
@Qualifier
@Retention(AnnotationRetention.RUNTIME)
annotation class ForAuthAPI
```

이 부분에 대해서는 일단 뒤에 설명하기로 하고

자 일단 객체는 있으니 넣어주는 부분이 있지 않겠습니까?
한번 찾아보았습니다

```kotlin
class PostSignInUseCase @Inject constructor(@ForAuthAPI retrofit: Retrofit, ...
```

엥? 아까 만들었던 어노테이션은 이따가 설명하기로 했으니 넘어간다해도 여기도 constructor에 retrofit 객체를 넣어주는 부분은 없군요 아 그럼 PostSignInUseCase를 사용하는 곳에서 넣어주겠네! 뭐 그럼 따라가 보죠

```kotlin
class LoginViewModel @Inject constructor(application: Application,
                                         private var postSignInUseCase: PostSignInUseCase) : AndroidViewModel(application) {
```

??? 여기서도 객체를 안넣어주네요......

자 다시 생각해보죠 dagger는 외부에서 객체를 생성후 주입한다고 했죠 사실 우리는 이미 module에서 객체를 생성했습니다 외부에서 객체를 생성해서 주입해주는 무언가를 스프링에서는 컨테이너, Dagger에서는 Component와 Module이라고 부릅니다

DI는 이렇게 의존성이 있는 객체의 제어를 외부 Framework로 올리면서 IoC 개념을 구현합니다. IoC는 Inversion of Control(제어의 역전)의 준말입니다.

`'제어의 역전'` 다시말해 우리가 지금 처럼 객체를 넣어주는것이 아닌 객체가 필요한 곳에서 객체를 요청하는 방식이기에 제어가 역전되었다고 말하게 되는것이죠

개념을 다시 돌아보죠 객체를 요청하는것 `@Inject`를 사용하면 필요한 객체를 요청하게 되는겁니다

#### 이제 다시 반대로 밑에서 부터 올라가보죠

1. @Inject를 통해 통해 PostSignInUseCase와 application을 가져옵니다
2. PostSignInUseCase에선 @Inject를 통해 retrofit 객체를 요청하네요
3. 따라서 module에 미리 생성해둔 retrofit 객체를 가져오게 됩니다

여기서 집고 넘어갈 부분은 @ForAuthAPI 라는 어노테이션을 통해서 retrofit 객체 중에서도 `AuthRetrofit` 을 가져왔다는 점입니다
만약 다른 retrofit 객체가 필요하다면 어노테이션을 새롭게 정의해 객체를 요구하는 쪽에서 필요한 객체에 맞는 어노테이션으로 요청하면 손쉽게 DI가 이루어집니다

마찬가지로 `@ForAccessToken` 도 만약 RefreshToken이 필요하다면 필요한 자리에 어노테이션만 바꾸면 되는것입니다

#

retrofit을 중심적으로 이야기 하니 component와 scope에 대한 이야기가 빠져버렸네요

마찬가지로 간단한 예제를 통해 알아보죠

scope를 먼저 볼까요

```kotlin
@Provides
@ActivityScope
fun provideActivity(): Activity {
    return activity
}
```

간단하게 생각해봅시다 객체의 LifeCycle 범위 즉 객체를 얼마동안 유지하느냐를 정해주겠네요
위의 경우엔 Activity가 유지되는 동안 존재하는 객체이겠네요

자 마지막으로 어찌보면 핵심이라고 할 수 있는 component에 대해 알아보죠

```kotlin
@Singleton
@Component(modules = arrayOf(
        ApplicationModule::class,
        JsonParserModule::class,
        SharedPreferenceModule::class,
        HttpClientModule::class,
        APIModule::class,
        ...
```

위에 module이 필요한 객체를 생성한다고 했지만 component에 연결되어 있지 않으면 객체를 생성하지 않습니다 위에서 객체를 생성해 내려준것도 결국 미리 BaseApplication 통해 inject를 수행하고 component에서 객체생성을 요청했기 때문입니다

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_main)

        BaseApplication.getAppComponent()
                .mainComponentBuilder()
                .activity(this)
                .build()
                .inject(this)
```

즉 component가 연결된 module들에게 객체생성을 요구하고 inject요청을 받으면 객체를 넘겨주었기 때문에 dagger가 잘 동작한다고 할 수 있겠네요 게다가 요청한 객체만 받아오니 더욱 효율적이겠죠

참고로 찾는 모듈이 없으면 부모의 component로 계속 이동하면서 찾는다고 하네요

#

## 마무리

생각보다 길고 장황한 글이 된거 같네요 최대한 실제 코드와 비교해보며 어떻게 쓰이는지 활용가능한지 설명해 봤는데요 이해가 잘 되었나요?

제가 이해한 순서대로 나열했기 때문에 다른 방식으로 생각하시는 분들도 계실거라고 생각이 들긴 합니다

어쨋든 의존성문제를 해결하고 효율적으로 프로젝트를 진행하는 dagger, 잘 사용해서 도움이 되었으면 좋겠습니다 감사합니다
