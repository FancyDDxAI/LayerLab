# Release notes

## v1.0.1 — fixes

Download `LayerLab-v1.0.1-win-x64.zip` → unzip → run `LayerLab.exe`. The full app (Electron, ONNX
runtime and both AI models) is included; nothing else to install.

- **Export** — restored the prominent Export button on the main workspace, with a popover for format
  (PNG/JPG), quality and scale, live output dimensions **and a real file-size estimate** before you export.
- **Canvas size** — removed the dark margin around the canvas that was hiding size changes; the canvas
  is now exactly your document size and resizing to Story / Square / etc. is immediately visible.
- **Fonts** — 16 fonts that are actually installed on Windows (Segoe UI, Arial, Georgia, Impact,
  Courier New and more). The previous build defaulted to a font that isn't present, so only one worked.
- **Backspace** no longer deletes layers, and is ignored while you're typing in a text box. Use
  **Delete** to remove a layer.
- **Filmstrip** thumbnails now match each image's real aspect ratio instead of all being the same box.
- Layers can be dragged partly off-canvas for bleed, but always keep a grabbable sliver so nothing gets lost.

---

## v1.0.0 — first public release

The first full release of LayerLab: a complete offline photo editor for AI art and social posts.

**Download:** `LayerLab-v1.0.0-win-x64.zip` → unzip → run `LayerLab.exe`
No installer, no dependencies, no account. Delete the folder to uninstall.

---

### Highlights

**AI background removal, fully offline**
Cuts subjects out on your own machine — nothing is uploaded. Auto mode plus manual brushes, including
an *Erase background* brush that samples the colour under your cursor so line art survives even if you
brush slightly inside the subject. Right-click always restores. Edge sharpness, softness and
shrink/grow can be re-tuned instantly without re-running the AI.

**Batch watermarking**
Place your logo once and it lands on the exact same spot across every image. Single mark or tiled
diagonal repeat for anti-repost protection, with shadow, outline, blend modes and 9 snap positions.

**Platform resizing**
Exact-pixel presets for Instagram, TikTok, YouTube, X, Facebook, Pinterest and Patreon. Drag to
reframe and zoom to choose exactly what's kept, with fill or padded fit and a rule-of-thirds grid.

**20+ effects, GPU accelerated**
Glitch, VHS, halftone, duotone, split tone, pixelate, posterize, threshold, sharpen, radial blur, film
grain, light leaks and more — plus one-click looks like Polaroid, Vintage and Soft BG. Save any
combination as your own preset and apply it to a whole folder.

**Censor brush**
Pixelate, blur or black-bar any area, so you can post a safe version publicly and keep the original.

**A real workspace**
Layers with blend modes and drag-to-reorder, a live RGB histogram, a history panel, full undo/redo, a
bottom filmstrip of every layer, project save/load, and a global export folder so you never pick a
destination twice.

**Make it yours**
Seven theme presets, a full colour editor for every part of the interface, and the option to use your
own picture as the app background.

---

### Known issues

- **Anime background model** — in testing this model returned an empty mask on synthetic images. The
  app detects this and automatically falls back to the General model rather than producing a bad
  cutout. The General model handles illustration well in practice.
- **Background removal runs on the CPU.** ONNX Runtime's WebGPU backend can't execute this model
  (unsupported `MaxPool` operation), so cutouts take a few seconds per image rather than being
  instant. Everything else in the app is GPU accelerated.
- The three batch studios still use the older interface styling; the main editor has the current design.

---

### Requirements

Windows 10 or 11 (64-bit) · ~1 GB disk space · no internet connection required

---

Made by **FDDX** · [ko-fi.com/fancyddxai](https://ko-fi.com/fancyddxai)
