---
title: "유어슈 기술 블로그 첫 개시!"
date: 2019-09-17T00:25:34+09:00
draft: false
categories: ["web"]
tags: ["웹","새로운시작","guide"]
author: ["margarets"]
---
<p>유어슈의 첫 게시글 + 마크다운 가이드 글이에요! 휴고 base 16 테마를 사용했어요, 지금 이 문단은 &lt;p>태그를 사용중이에요! </p>

<h2 id="headings">헤더파일</h2>

<p>html의 6가지 <code>&lt;h1&gt;</code>—<code>&lt;h6&gt;</code> 태그들을 지원하고 있어요. <code>&lt;h1&gt;</code> 에서 <code>&lt;h6&gt;</code> 까지 사용할 수 있답니다.</p>

<h1 id="h1">H1</h1>

<h2 id="h2">H2</h2>

<h3 id="h3">H3</h3>

<h4 id="h4">H4</h4>

<h5 id="h5">H5</h5>

<h6 id="h6">H6</h6>

<h2 id="paragraph">Paragraph</h2>

<p>동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세</p>

<p>p태그를 한번 더 사용할 경우 주어지는 간격입니다</p>

<h2 id="blockquotes">Blockquotes(인용문)</h2>

<p>글을 예쁘게 표현할때 필요한 태그입니다</p>

<h4 id="blockquote-without-attribution">인용문 안에도 마크다운을 사용할 수 있어요!</h4>

<blockquote>
<p> Yea I don't care 모아둔 돈을 깨 Lotta cash 얼마든 I'm okay yea 비싼 옷 빼 입어 Cuz
<strong>It's a good day</strong> 많고 또 많은 스트레스는 어려워 <em>때로는 정답을 몰라</em> Sometimes I feel like I'm at war</p>
</blockquote>

<h4 id="blockquote-with-attribution">Blockquote with attribution</h4>

<blockquote>
<p>I just wanna chill with my homies 하얀색의 모래 또 파란색의 물 위엔 파도들이 쭉 밀려오지 전화해서 잡아둬 펜션 이미 올라온 텐션</p>
— <cite>팔로알토<sup class="footnote-ref" id="fnref:1"><a href="#fn:1">1</a></sup></cite><p></p>
</blockquote>

<h2 id="tables">테이블</h2>

<p>테이블은 마크다운이 아니지만 휴고에서는 테이블을 지원하고 있어요</p>

<table>
<thead>
<tr>
<th>이름</th>
<th>나이</th>
</tr>
</thead>

<tbody>
<tr>
<td>민주</td>
<td>03</td>
</tr>

<tr>
<td>마가레뜨</td>
<td>13</td>
</tr>
</tbody>
</table>

<h4 id="inline-markdown-within-tables">테이블 내 마크다운</h4>

<table>
<thead>
<tr>
<th>Inline&nbsp;&nbsp;&nbsp;</th>
<th>Markdown&nbsp;&nbsp;&nbsp;</th>
<th>In&nbsp;&nbsp;&nbsp;</th>
<th>Table</th>
</tr>
</thead>

<tbody>
<tr>
<td><em>italics</em></td>
<td><strong>bold</strong></td>
<td><del>strikethrough</del>&nbsp;&nbsp;&nbsp;</td>
<td><code>code</code></td>
</tr>
</tbody>
</table>

<h2 id="code-blocks">Code Blocks</h2>

<h4 id="code-block-with-backticks">`를 사용한 코드 블럭`</h4>

<pre><code>html
&lt;!DOCTYPE html&gt;
&lt;html lang="en"&gt;
&lt;head&gt;
  &lt;meta charset="UTF-8"&gt;
  &lt;title&gt;Example HTML5 Document&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
  &lt;p&gt;Test&lt;/p&gt;
&lt;/body&gt;
&lt;/html&gt;
</code></pre>

<h4 id="code-block-indented-with-four-spaces">빈칸 4개로 시작하는 코드블럭</h4>

<pre><code>&lt;!DOCTYPE html&gt;
&lt;html lang="en"&gt;
&lt;head&gt;
  &lt;meta charset="UTF-8"&gt;
  &lt;title&gt;Example HTML5 Document&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
  &lt;p&gt;Test&lt;/p&gt;
&lt;/body&gt;
&lt;/html&gt;
</code></pre>

<h4 id="code-block-with-hugo-s-internal-highlight-shortcode">휴고 내부 하이라이트와 코드블럭을 이용한 짧은 코드 예시</h4>

<div class="highlight"><pre style="color:#f8f8f2;background-color:#272822;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-html" data-lang="html"><span style="color:#75715e">&lt;!DOCTYPE html&gt;</span>
&lt;<span style="color:#f92672">html</span> <span style="color:#a6e22e">lang</span><span style="color:#f92672">=</span><span style="color:#e6db74">"en"</span>&gt;
&lt;<span style="color:#f92672">head</span>&gt;
  &lt;<span style="color:#f92672">meta</span> <span style="color:#a6e22e">charset</span><span style="color:#f92672">=</span><span style="color:#e6db74">"UTF-8"</span>&gt;
  &lt;<span style="color:#f92672">title</span>&gt;Example HTML5 Document&lt;/<span style="color:#f92672">title</span>&gt;
&lt;/<span style="color:#f92672">head</span>&gt;
&lt;<span style="color:#f92672">body</span>&gt;
  &lt;<span style="color:#f92672">p</span>&gt;Test&lt;/<span style="color:#f92672">p</span>&gt;
&lt;/<span style="color:#f92672">body</span>&gt;
&lt;/<span style="color:#f92672">html</span>&gt;</code></pre></div>

<h2 id="list-types">작품과 등장인물(리스트 사용 예시)</h2>

<h4 id="ordered-list">해리포터</h4>

<ol>
<li>해리포터</li>
<li>헤르미온느</li>
<li>론 위즐리</li>
</ol>

<h4 id="unordered-list">트와일라잇</h4>

<ul>
<li>벨라</li>
<li>에드워드</li>
<li>제이콥</li>
</ul>

<h4 id="nested-list">나루토</h4>

<ul>
<li>우즈마키 나루토</li>
<li>우치하 사스케</li>
<li>휴우가 히나타</li>
</ul>

<h2 id="other-elements-abbr-sub-sup-kbd-mark">다른 속성들 — abbr, sub, sup, kbd, mark</h2>

<p><abbr title="Graphics Interchange Format">abbr</abbr> 태그는 약어, 두문자 어를 나타날때 쓰는 태그입니다</p>

<p>아랫글자를 넣을때 사용하는 sub 태그는 <sub>이렇게</sub> 사용할 수 있어요</p>

<p>윗글자는 sup태그를 사용하여 <sup>요로코롬 올려서 </sup>함께 <sup>사용할 수 </sup> 있어요! <sup>안녕!</sup></p>

<p>키보드의 키를 알려줄땐 kbd 태그를 사용하여 <kbd><kbd>ALT</kbd>+<kbd>F4</kbd> 를 표현 할 수 있어요.</p>

<p>중요한 부분을 표현하고 싶다면 <mark>이렇게 중요하다는 것을</mark> 강조할 수 있는 mark 태그도 존재한답니다</p>
<div class="footnotes">

<hr>

<ol>
<li id="fn:1">각주 기능을 사용할 수 있어요! <a href="https://www.youtube.com/watch?v=PAAkCSZUG1c">good day 듣기</a> 옆 ^를 누르면 다시 원본으로 돌아가요.
 <a class="footnote-return" href="#fnref:1">^</a></li>
</ol>
</div>
