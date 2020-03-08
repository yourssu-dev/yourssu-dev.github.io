---
title: "에브리타임 봇 제작기 - (1: 에타 크롤러)"
date: 2020-03-09T01:07:00+09:00
draft : false
categories : ["dev"]
tags : ["에브리타임", "bot", "crawling", "python"]
author : ["0G"]
---

# 에브리타임 봇 제작기 - (1: 에타 크롤러)

안녕하세요. 유어슈 **0G** 입니다.

동아리 내에서는 대장 겸, 만능노예를 맡고있습니다. 


<br> 노예의 주 업무는 에브리타임에서 동아리 관련한 글에 답변을 다는 것입니다. 

그러나 **하나하나 매일 찾고 대응하는 것** 이 보통 일이 아니더라고요.

그래서 생각했습니다. 

<br>

## 봇을 만들자!

> <br> 기획/마케팅 출신인 제가 이 짓을 시작하게 된 계기는 심플합니다. <br>개발팀한테 만들어달라 했는데 아무도 관심을 안줬기 때문입니다. <br>( 황금같은 일요일을 쉽게 낭비하는 법 )<br><br> ![slack_img](https://i.imgur.com/Ee1x5ar.png)

<br><br>

봇의 기본적인 구조는 19년도 2월에 작성된 네이버 블로그글을 참고했습니다.

링크: https://blog.naver.com/kbs4674/221460241196 

그러나 곧바로 문제점이 생겼습니다. 

<br> **>>나... 루비 할줄 모르는데?** 

따라서 이번 글은 제가 통계할 때 쓰는 언어인

**Python**으로 진행됩니다!

<br>

### * 우선한 고려사항
에브리타임은 대부분 POST 방식을 채택합니다. 

따라서 일반적으로 URL을 얻기보다는 **크롬 개발자 도구**를 통해 URL과 data 인자를 도출해야 했습니다. 
(책에서는 이런거 안배웠는데)


<br><br><br>

## 0. 로그인

```PYTHON
import requests

# 로그인 정보
LOGIN_INFO = {
    'userid': '본인의 에타 아이디',
    'password': '본인의 에타 비밀번호',
    'redirect': '/',
}
login_url = 'https://ssu.everytime.kr/user/login'
api_url = 'https://api.everytime.kr'

# Session 생성
with requests.Session() as s:
    login_res = s.post(login_url, data=LOGIN_INFO)

    if login_res.status_code != 200: #log-in-check
        raise Exception('Log-in Failed')
    # ~~~~~~~~~~~~~~~ Session 유지!

```

먼저 로그인은 파이썬 기본 모듈인 requests 를 이용했습니다. 

먼저, 개발자 도구로 로그인시 입력되는 폼 데이타를 확인해, 로그인 정보를 얻었습니다. 

리다이렉트 되는 URL을 살펴보니, 학교마다 다른 서브도메인을 사용합니다.(숭실대학교는 'ssu'를 사용) 

<br> 이후 기본 모듈인 requests.Session()을 통하여 세션을 생성합니다. 

다행히 세션을 통해 에브리타임에 접속하는데는 큰 보안적 문제가 발생하지 않았습니다. 

정상적으로 로그인이 되면 200을 반환하니, 이 부분에서 로그인이 잘됐는지 체크해줍니다! 


<br><br><br>

## 1. 크롤링

```PYTHON
everytime_board_list_yourssu = s.post(api_url + '/find/board/article/list', data={
        'id': 'search',
        'limit_num': 20,
        'start_num': 0,
        'moiminfo': True,
        'search_type': 4,
        'keyword': '유어슈',
    })
```

에브리타임의 게시글은

**도메인 값에 data 값을 post로 보내면, 게시글 list가 리턴**되는 방식입니다. (블로그 참고) 

주의 할 점은 제목이 있는 게시판의 경우 크롤링시 전체 내용이 아닌 짤린 내용을 반환합니다. 

따라서 자유게시판과 같은 곳에서는 블로그와 같은 크롤링 후 text 내용에서 키워드를 서칭할 수 없는 문제가 발생합니다. 

<br><br><br>저는 **유어슈** 라는 키워드가 들어가 있는 모든 게시판의 글을 크롤링 하고 싶었기 때문에 상단 블로그의 방식과는 달리,

에브리타임에서 **유어슈** 를 검색한 후, 해당 페이지를 크롤링하기로 했습니다. 


```PYTHON
everytime_board_list_yourssu = s.post(api_url + '/find/board/article/list', data={
        'id': 370455,
        'limit_num': 20,
        'start_num': 0,
        'moiminfo': True,
    })
```

그러나 혹시 모르니, 게시판 크롤링 코드와 주요 게시판 id를 같이 첨부합니다. 
### 숭실대 주요 게시판 id
>자유게시판: 370455<br>
비밀게시판: 257667<br>
졸업생게시판:385967<br>
새내기게시판:374637<br>
장터게시판: 370476<br>

<br>


```PYTHON
print(everytime_board_list_yourssu.text)
```

![console](https://i.imgur.com/Nll1nln.png)


마지막으로 프린트를 해서 콘솔로 확인하면

이 친구가 정상적으로 유어슈가 검색된 페이지를 xml형태로 긁어오는 것을 알 수 있습니다. 

<br><br><br>만약 데이터쪽에서 일하시는 분들이라면

손쉽게 xml 파일에서 텍스트를 긁어

wordcloud를 만들거나, 빈도를 계산하여 통계 자료로 작성하실 수 있을 겁니다. 



<br><br><br>

다음 게시물에는 크롤링한 xml 데이터를 바탕으로

댓글을 작성하는 기능 구현을 올리러 오겠습니다!

안뇽! 감사! **-3-)/**




