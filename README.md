# my_gametime

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## FairCart Business Plan PDF Converter

This project includes a Python-based HTML-to-PDF converter for generating professional, investor-ready business plan documents.

### Features

- Convert HTML business plans to high-quality PDF documents
- Preserve all CSS styling, colors, tables, and layouts
- A4 page size with proper margins for professional presentation
- Optimized for sharing with investors and stakeholders
- Error handling and validation

### Quick Start

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Convert the business plan to PDF:**
   ```bash
   python convert_to_pdf.py
   ```

   This will generate `FairCart_Business_Plan.pdf` from the HTML source.

### Advanced Usage

```bash
# Convert with verbose output
python convert_to_pdf.py --verbose

# Convert custom HTML file
python convert_to_pdf.py --input my_plan.html --output my_plan.pdf

# Short form options
python convert_to_pdf.py -i input.html -o output.pdf -v
```

### Files Included

- `FairCart_Business_Plan.html` - Professional business plan with CSS styling
- `convert_to_pdf.py` - Python conversion script
- `requirements.txt` - Python dependencies
- `FairCart_Business_Plan.pdf` - Generated PDF output

### Requirements

- Python 3.7+
- Dependencies listed in `requirements.txt`
- On some systems, additional system packages may be required for WeasyPrint

### Troubleshooting

If you encounter issues with WeasyPrint installation, refer to the [WeasyPrint installation guide](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html#installation) for system-specific dependencies.
