#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Render .R scripts to syntax-highlighted HTML pages for the course website.

GitHub Pages serves .R files as plain text, so clicking one shows raw source.
This generates a highlighted HTML next to each script, with a link back to the
course page.

Usage:
    python3 tools/render-r.py <code-dir> <relative-link-back-to-course-page>

Example:
    python3 tools/render-r.py teaching/code/sta101 ../../course-sta101.html
"""
import glob
import html
import os
import sys

from pygments import highlight
from pygments.formatters import HtmlFormatter
from pygments.lexers import get_lexer_by_name

PAGE = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title} — R Code — Cong Xu</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:300,400,500,700&amp;display=swap">
<style>
  body {{ margin:0; font-family:Roboto,-apple-system,sans-serif; color:#000;
         line-height:1.7; background:#fff; }}
  .wrap {{ max-width:960px; margin:0 auto; padding:0 24px 48px; }}
  .back {{ display:block; padding:14px 0; font-size:14px; color:#b509ac;
           text-decoration:none; border-bottom:1px solid rgba(0,0,0,.1); }}
  h1 {{ font-family:"Roboto Slab",serif; font-weight:400; font-size:1.6rem;
        margin:1.6rem 0 .3rem; }}
  .meta {{ color:#828282; font-size:.9rem; margin:0 0 1.4rem; }}
  .code {{ border:1px solid rgba(0,0,0,.1); border-radius:6px; padding:16px;
           overflow-x:auto; font-size:.86rem; line-height:1.6; }}
  {css}
</style>
</head>
<body>
<div class="wrap">
  <a class="back" href="{back}">&larr; 返回课程页 / Back to course page</a>
  <h1>{title}</h1>
  <p class="meta">{filename} &middot; 下载：<a href="{filename}">{filename}</a></p>
  <div class="code">{code}</div>
</div>
</body>
</html>
"""


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 1
    code_dir, back = sys.argv[1], sys.argv[2]

    try:
        formatter = HtmlFormatter(style="github-light", linenos=False)
    except Exception:
        formatter = HtmlFormatter(style="default", linenos=False)
    css = formatter.get_style_defs(".code")
    lexer = get_lexer_by_name("r", stripall=False)

    for path in sorted(glob.glob(os.path.join(code_dir, "*.R"))):
        src = open(path, encoding="utf-8").read()
        code = highlight(src, lexer, formatter)
        name = os.path.basename(path)
        title = html.escape(os.path.splitext(name)[0].replace("-", " "))
        out = os.path.join(code_dir, os.path.splitext(name)[0] + ".html")
        with open(out, "w", encoding="utf-8") as f:
            f.write(PAGE.format(title=title, back=back, css=css,
                                code=code, filename=name))
        print(f"{name}  ->  {os.path.basename(out)}  {os.path.getsize(out)/1024:.0f} KB")
    return 0


if __name__ == "__main__":
    sys.exit(main())
