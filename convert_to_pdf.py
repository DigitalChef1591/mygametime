#!/usr/bin/env python3
"""
FairCart Business Plan HTML to PDF Converter

This script converts the FairCart_Business_Plan.html file into a professional,
investor-ready PDF document using WeasyPrint for high-quality output.

Requirements:
- weasyprint
- pathlib
- argparse

Usage:
    python convert_to_pdf.py
    python convert_to_pdf.py --input custom_file.html --output custom_output.pdf
"""

import os
import sys
import argparse
from pathlib import Path

try:
    from weasyprint import HTML, CSS
    from weasyprint.text.fonts import FontConfiguration
except ImportError:
    print("Error: weasyprint is not installed.")
    print("Please install it using: pip install weasyprint")
    print("Note: On some systems you may need additional dependencies.")
    print("See: https://doc.courtbouillon.org/weasyprint/stable/first_steps.html#installation")
    sys.exit(1)


def validate_input_file(file_path):
    """Validate that the input HTML file exists and is readable."""
    if not file_path.exists():
        raise FileNotFoundError(f"Input file not found: {file_path}")
    
    if not file_path.is_file():
        raise ValueError(f"Input path is not a file: {file_path}")
    
    if file_path.suffix.lower() != '.html':
        raise ValueError(f"Input file must be an HTML file: {file_path}")
    
    return True


def setup_font_configuration():
    """Set up font configuration for better PDF rendering."""
    font_config = FontConfiguration()
    return font_config


def create_pdf_styles():
    """Create additional CSS styles for PDF optimization."""
    pdf_css = CSS(string='''
        @page {
            size: A4;
            margin: 20mm;
        }
        
        /* Ensure good page breaks */
        .section {
            page-break-inside: avoid;
        }
        
        /* Optimize table rendering for PDF */
        table {
            page-break-inside: avoid;
        }
        
        /* Ensure images fit properly */
        img {
            max-width: 100%;
            height: auto;
        }
        
        /* Better font rendering for PDF */
        body {
            font-smooth: always;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
    ''')
    return pdf_css


def convert_html_to_pdf(input_file, output_file, verbose=False):
    """
    Convert HTML file to PDF using WeasyPrint.
    
    Args:
        input_file (Path): Path to the input HTML file
        output_file (Path): Path for the output PDF file
        verbose (bool): Whether to print verbose output
    
    Returns:
        bool: True if conversion successful, False otherwise
    """
    try:
        if verbose:
            print(f"Starting conversion...")
            print(f"Input file: {input_file}")
            print(f"Output file: {output_file}")
        
        # Validate input file
        validate_input_file(input_file)
        
        # Set up font configuration
        font_config = setup_font_configuration()
        
        # Create additional PDF-specific styles
        pdf_css = create_pdf_styles()
        
        if verbose:
            print("Loading HTML file...")
        
        # Load HTML file
        html_doc = HTML(filename=str(input_file))
        
        if verbose:
            print("Generating PDF...")
        
        # Convert to PDF with optimized settings
        html_doc.write_pdf(
            str(output_file),
            stylesheets=[pdf_css],
            font_config=font_config,
            optimize_images=True
        )
        
        if verbose:
            print(f"✅ PDF generated successfully: {output_file}")
            print(f"File size: {output_file.stat().st_size / 1024:.1f} KB")
        
        return True
        
    except FileNotFoundError as e:
        print(f"❌ Error: {e}")
        return False
    except ValueError as e:
        print(f"❌ Error: {e}")
        return False
    except Exception as e:
        print(f"❌ Conversion failed: {e}")
        if verbose:
            import traceback
            traceback.print_exc()
        return False


def main():
    """Main function to handle command line arguments and run conversion."""
    parser = argparse.ArgumentParser(
        description="Convert FairCart Business Plan HTML to PDF",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python convert_to_pdf.py
  python convert_to_pdf.py --verbose
  python convert_to_pdf.py --input custom.html --output custom.pdf
  python convert_to_pdf.py -i input.html -o output.pdf -v
        """
    )
    
    parser.add_argument(
        '--input', '-i',
        type=str,
        default='FairCart_Business_Plan.html',
        help='Input HTML file path (default: FairCart_Business_Plan.html)'
    )
    
    parser.add_argument(
        '--output', '-o',
        type=str,
        default='FairCart_Business_Plan.pdf',
        help='Output PDF file path (default: FairCart_Business_Plan.pdf)'
    )
    
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable verbose output'
    )
    
    args = parser.parse_args()
    
    # Convert to Path objects
    script_dir = Path(__file__).parent
    input_file = script_dir / args.input
    output_file = script_dir / args.output
    
    # Print header
    print("=" * 60)
    print("FairCart Business Plan HTML to PDF Converter")
    print("=" * 60)
    
    # Run conversion
    success = convert_html_to_pdf(input_file, output_file, args.verbose)
    
    if success:
        print(f"\n🎉 Conversion completed successfully!")
        print(f"📄 PDF file created: {output_file.name}")
        
        # Print file info
        if output_file.exists():
            size_kb = output_file.stat().st_size / 1024
            print(f"📏 File size: {size_kb:.1f} KB")
        
        return 0
    else:
        print(f"\n💥 Conversion failed. Please check the error messages above.")
        return 1


if __name__ == "__main__":
    sys.exit(main())