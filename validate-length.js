const fs = require('fs');

try {
  const pdfPath = 'generated/resume.pdf';
  
  if (!fs.existsSync(pdfPath)) {
    console.error('❌ generated/resume.pdf not found');
    process.exit(1);
  }

  // Read PDF and count pages by looking for /Type /Page entries
  const pdfBuffer = fs.readFileSync(pdfPath);
  const pdfText = pdfBuffer.toString('latin1');
  const pageMatches = pdfText.match(/\/Type\s*\/Page[^s]/g);
  const pages = pageMatches ? pageMatches.length : 0;
  
  if (pages > 1) {
    console.error(`❌ Resume is ${pages} pages. Must be 1 page.`);
    process.exit(1);
  }
  
  console.log('✅ Resume is 1 page');
} catch (error) {
  console.error('Error checking page count:', error.message);
  process.exit(1);
}
