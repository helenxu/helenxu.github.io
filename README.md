# Cong Xu's Academic Homepage

Personal academic website (static HTML/CSS/JS), deployed via GitHub Pages.

**Live site:** https://helenxu.github.io/

The site lives in the `helenxu.github.io` repository on the **helenxu** account —
because the repository name matches the account login, GitHub Pages serves it as a
*user site* at the root URL (no `/repo` sub-path).

---

## Directory structure

```
.
├── index.html                      # Homepage
├── cv.html                         # CV
├── teaching.html                   # Teaching (course cards)
├── teaching/
│   ├── course-sta219.html          # STA219 Probability and Statistics for Engineering
│   ├── course-ma405.html           # MA405 Survival Analysis (in preparation)
│   ├── img/                        # Textbook cover images (used by the cards)
│   ├── slides/sta219/              # Lecture slides (PDF)
│   └── notebooks/sta219/           # Jupyter notebooks (.ipynb)
├── assets/
│   ├── css/style.css               # All styles (colors, fonts, layout)
│   ├── js/main.js                  # Mobile nav toggle
│   ├── img/photo.jpg               # Profile photo
│   └── cv/cv.pdf                   # Downloadable CV
├── .nojekyll                       # Tells GitHub Pages to serve files as-is
└── README.md
```

---

## Preview locally

Because pages use relative paths (e.g. `../assets/css/style.css`), open the site
through a local web server started at the **site root** — opening the HTML files
directly from Finder works too, but a server is safer for link checking:

```bash
# from this directory
python3 -m http.server 8123
# then visit http://127.0.0.1:8123/
```

---

## Everyday updates (SSH)

The local clone pushes over SSH (`git@github.com:helenxu/helenxu.github.io.git`),
so no personal access token is needed:

```bash
cd <this folder>
git add -A
git commit -m "describe the change"
git push origin main:master     # local branch is main, remote branch is master
```

GitHub Pages rebuilds automatically; the site updates in roughly 1 minute.

---

## Deploy to GitHub Pages (first time)

This site is deployed from **helenxu/helenxu.github.io**, branch `master`,
folder `/ (root)` — a GitHub Pages *user site*, served at https://helenxu.github.io/.
To redeploy elsewhere:

1. Create a new **public** repository.
2. Push this folder as the repository root:

```bash
git init
git add .
git commit -m "Initial commit: academic homepage"
git branch -M main
git remote add origin https://github.com/<user>/<repo>.git
git push -u origin main
```

3. In the repository: **Settings → Pages → Build and deployment**
   → Source: *Deploy from a branch* → Branch: `main`, folder: `/ (root)` → Save.
4. Wait 1–2 minutes, then open the Pages URL shown in Settings.

> The `.nojekyll` file is important: it stops GitHub from running Jekyll on upload,
> so the site is served byte-for-byte as you see it locally.

### Custom domain (optional)

To serve at a short URL such as `congxu.org`:

1. Put the domain in a file named `CNAME` at the repository root (one line, no `http://`).
2. Add a `CNAME` DNS record at your registrar pointing to `helenxu.github.io`.
3. In **Settings → Pages → Custom domain**, enter the domain and enable
   *Enforce HTTPS* once the certificate is issued.

---

## Updating content

| What | How |
|---|---|
| Profile / bio / research interests | edit `index.html`, "About Me" and "Research Interests" sections |
| News | edit the `<ul class="news-list">` in `index.html` (newest first) |
| CV | edit `cv.html`; replace `assets/cv/cv.pdf` for the downloadable version |
| Add a course | copy the commented card block in `teaching.html`, then copy any file in `teaching/` as the new course page |
| Add slides | drop PDFs into `teaching/slides/<course>/`, then add `<li>` links in the course page |
| Add R code | drop `.R` into `teaching/code/<course>/`, run the renderer (below), then add `<li>` links |
| Add notebooks | drop `.ipynb` into `teaching/notebooks/<course>/`, convert to HTML (see below), then add `<li>` links |
| Course cover image | put the image in `teaching/img/` and replace the `<img src>` in the card |

### Notebooks: why HTML as well as `.ipynb`

GitHub Pages serves `.ipynb` as `text/plain`, so clicking one shows raw JSON.
Each notebook therefore has a rendered `.html` next to it — that is what the
"查看" link points to. Regenerate after editing a notebook:

```bash
pip install nbconvert jupyterlab_pygments
python - << 'EOF'
import glob, os, re
from nbconvert import HTMLExporter
import nbformat

NB_DIR = "teaching/notebooks/sta219"          # change per course
BACK = "../../course-sta219.html"             # relative link back to the course page
BANNER = ('<div style="max-width:960px;margin:0 auto;padding:10px 16px;'
          'font-family:Roboto,sans-serif;font-size:14px;'
          'border-bottom:1px solid rgba(0,0,0,.1);">'
          f'<a href="{BACK}" style="color:#b509ac;text-decoration:none;">'
          '&larr; 返回课程页 / Back to course page</a></div>')

exporter = HTMLExporter(template_name="lab")
for path in sorted(glob.glob(os.path.join(NB_DIR, "*.ipynb"))):
    nb = nbformat.read(path, as_version=4)
    body, _ = exporter.from_notebook_node(nb)
    body = re.sub(r"(<body[^>]*>)", r"\1" + BANNER, body, count=1)
    out = os.path.splitext(path)[0] + ".html"
    open(out, "w", encoding="utf-8").write(body)
    print("wrote", out)
EOF
```

The exported HTML embeds all figures as base64, so it is fully self-contained.
Each entry also offers a **下载** link (the original `.ipynb`) and a **Colab** link
that opens it directly in Google Colab.

Same problem for `.R` scripts — Pages serves them as plain text. `tools/render-r.py`
turns each script into a syntax-highlighted page with a link back to the course:

```bash
python3 tools/render-r.py teaching/code/sta101 ../../course-sta101.html
```

Then link both files in the course page: `查看` → the `.html`, `下载` → the `.R`.

### Keeping files small

Lecture PDFs were compressed with Ghostscript (≈10× smaller). For new PDFs:

```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf in.pdf
```

Use `-dPDFSETTINGS=/printer` if you need higher resolution (larger file).

---

## Design notes

- Fonts: **Roboto** (body) and **Roboto Slab** (headings), loaded from Google Fonts.
- Theme colour: `#b509ac`, text `#000`, muted text `#828282` — matching the
  [al-folio](https://github.com/alshedivat/al-folio) theme used by the reference site.
- All colours and fonts live in `:root` at the top of `assets/css/style.css`;
  change them there and the whole site updates.

---

© 2026 Cong Xu · xuc6@sustech.edu.cn
