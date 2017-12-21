---
layout: page
title: List of posts
---

{% for post in site.posts %}
  <article>
    <h4>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
    </h4>
    <time datetime="{{ post.date | date: "%Y-%m-%d" }}">{{ post.date | date_to_long_string }}</time>
  </article>
{% endfor %}