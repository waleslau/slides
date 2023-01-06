# 用 Markdown 创建幻灯片

## pandoc & reveal.js

```bash
pandoc -t revealjs -M revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@4 --mathjax -s revealjs.md -o docs/index.html
```

## Visual Studio Code & Markdown Preview Enhanced

只需要在 Visual Studio Code 中安装 Markdown [Preview Enhanced](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced) 插件
