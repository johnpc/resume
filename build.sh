#!/bin/bash
set -e

# Create generated folder
mkdir -p generated

# Generate PDF
export PUPPETEER_TIMEOUT=120000
npx resume export generated/resume.pdf --theme stackoverflow

# Remove empty second page if exists
cd generated
if command -v pdftotext &> /dev/null; then
  page2_text=$(pdftotext -f 2 -l 2 resume.pdf - 2>/dev/null | tr -d '[:space:]')

  if [ -n "$page2_text" ]; then
    echo "⚠️  Warning: Page 2 contains content. Not removing it."
    echo "Content preview: ${page2_text:0:100}"
  else
    echo "Page 2 is empty, removing it..."
    if command -v gs &> /dev/null; then
      gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=1 -dLastPage=1 -sOutputFile=resume-temp.pdf resume.pdf 2>/dev/null && mv resume-temp.pdf resume.pdf
      echo "✓ Removed empty page 2"
    fi
  fi
fi

# Generate PNG preview
qlmanage -t -s 1000 -o . resume.pdf 2>/dev/null
mv resume.pdf.png resume.png

cd ..

# Validate
node validate-length.js

echo ""
echo "✅ Build complete!"
echo "   PDF: generated/resume.pdf"
echo "   PNG: generated/resume.png"
