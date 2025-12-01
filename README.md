# GemKit

GemKit provides Python modules and command-line tools that integrate with Google's Gemini API. It includes tools for analyzing PDFs and academic papers, processing audio and video, and working with images.

## Objective

GemKit enables developers and researchers to interact with various document and media types using AI without writing complex API integration code. Instead of building custom solutions for each use case, users can import modules or run command-line tools to:

- Extract information and insights from PDF documents and research papers
- Process and analyze audio, video, and image files
- Generate structured outputs (JSON, reviews) that fit specific needs
- Automate document analysis workflows

## Why Use GemKit

**For Researchers**: Quickly analyze academic papers, extract key findings, and generate structured review summaries without manual parsing.

**For Developers**: Integrate multi-modal AI analysis into applications with minimal code. Use pre-built tools or import modules directly into Python projects.

**For Organizations**: Automate document processing, content analysis, and knowledge extraction at scale.

**For Teams**: Standardize how documents and media are processed across projects using consistent, reusable components.

## Features

- **Multi-modal support**: PDFs, audio files, videos, and images
- **Structured output**: Uses Pydantic for schema-driven responses
- **Command-line and programmatic interfaces**: Tools can be used from the terminal or imported into Python scripts
- **Modular design**: Components can be used independently or combined

## Available Tools

### PDF & Paper Analysis

Tools for interacting with PDF documents using Google's Gemini API and generating academic paper reviews.

### 1. **PDF Paper Reviewer** (`gemkit/cli_paper_reviewer.py`)
Tool that combines PDF chat with academic paper review generation.

#### Review Command
Generate an academic paper review with structured output:
```bash
python -m gemkit.cli_paper_reviewer review -i paper.pdf
python -m gemkit.cli_paper_reviewer review -i paper.pdf --model gemini-1.5-pro
python -m gemkit.cli_paper_reviewer review -i paper.pdf -o review.json
```

#### Chat Command
Start an interactive chat session with a PDF:
```bash
python -m gemkit.cli_paper_reviewer chat -i paper.pdf
python -m gemkit.cli_paper_reviewer chat -i paper.pdf -q "Summarize the methodology"
python -m gemkit.cli_paper_reviewer chat -i paper.pdf --model gemini-1.5-pro
```

### 2. **PDF Chat** (`gemkit/gemini_pdf_chat.py`)
PDF chat interface for asking questions about document content.

```bash
python -m gemkit.gemini_pdf_chat -i document.pdf
python -m gemkit.gemini_pdf_chat -i document.pdf -q "What is the main contribution?"
python -m gemkit.gemini_pdf_chat -i document.pdf --model gemini-1.5-pro
```

### 3. **Paper Reviewer** (`gemkit/paper_reviewer.py`)
Pydantic models and functions for generating academic paper reviews. Can be imported and used in other scripts.

```python
from gemkit.paper_reviewer import ComprehensivePaperReview, review_paper_with_gemini

# Review a paper
review = review_paper_with_gemini(paper_content)
print(review.recommendation.decision)
print(review.overall_assessment.strengths)

# Export to JSON
with open("review.json", "w") as f:
    f.write(review.model_dump_json(indent=2))
```

### Audio Analysis

Tools for processing and analyzing audio files.

### Video Analysis

Tools for processing and analyzing video files.

### Image Analysis & Generation

Tools for analyzing, editing, and generating images.

#### 1. **Image Generation** (`gemkit/gemini_image_generation.py`)
Generate images from a text prompt.

**Command-Line Usage:**
```bash
python -m gemkit.gemini_image_generation -p "A futuristic cityscape at sunset" -o cityscape.png
```

**Programmatic Usage:**
```python
from gemkit.gemini_image_generation import GeminiImageGenerator

generator = GeminiImageGenerator()
result = generator.generate_image(
    prompt="A surreal landscape with floating islands",
    output_filename="surreal_landscape.png"
)
if result["filepath"]:
    print(f"Image saved to {result['filepath']}")
```

#### 2. **Image Editing** (`gemkit/gemini_image_edition.py`)
Edit an existing image based on a text prompt.

**Command-Line Usage:**
```bash
python -m gemkit.gemini_image_edition -i "path/to/your/image.png" -p "Add a cat sitting on the grass" -o "edited_image.png"
```

**Programmatic Usage:**
```python
from gemkit.gemini_image_edition import GeminiImageEditor

editor = GeminiImageEditor()
result = editor.edit_image(
    source="path/to/your/image.png",
    prompt="Change the color of the car to blue",
    output_filename="blue_car.png"
)
if result["filepath"]:
    print(f"Edited image saved to {result['filepath']}")
```

#### 3. **Image Segmentation** (`gemkit/gemini_image_segmentation.py`)
Generate segmentation masks for objects in an image.

**Command-Line Usage:**
```bash
python -m gemkit.gemini_image_segmentation -s "path/to/your/image.png" --objects "cat,dog"
```

**Programmatic Usage:**
```python
from gemkit.gemini_image_segmentation import GeminiImageSegmentation
from PIL import Image

segmenter = GeminiImageSegmentation()
image = Image.open("path/to/your/image.png")
result = segmenter.segment_image(
    image=image,
    objects_to_segment=["person", "bicycle"]
)
print(result)
```


## Setup

### Requirements
- Python 3.10+
- Google Generative AI SDK
- Pydantic v2

### Installation
```bash
pip install google-generativeai pydantic
```

### Configuration
Set your Gemini API key:
```bash
export GEMINI_API_KEY="your-api-key-here"
```

## Architecture

### GeminiPDFChat Class
Handles PDF uploads and chat interactions with the Gemini API.

**Methods:**
- `load_pdf(pdf_file)` - Upload and validate PDF
- `generate_text(prompt, response_schema=None)` - Generate response with optional schema
- `_delete_pdf()` - Clean up uploaded file

Supports context manager usage for automatic cleanup.

### ComprehensivePaperReview Schema
Pydantic model for academic paper reviews. Includes the following sections:

**Sections:**
- `metadata` - Paper information
- `executive_summary` - Brief overview
- `methodology` - Methodology assessment
- `novelty` - Novelty and contribution
- `writing` - Writing quality
- `visual_elements` - Tables, figures, diagrams, images
- `literature` - Literature review assessment
- `results` - Results and analysis
- `ethical_considerations` - Ethics (optional)
- `overall_assessment` - Key strengths and weaknesses
- `specific_issues` - Major/minor issues and author questions
- `detailed_feedback` - Detailed comments for authors
- `recommendation` - Publication decision with justification

## Usage Examples

### Generate a Paper Review Programmatically
```python
from paper_reviewer import review_paper_with_gemini
import json

with open("paper.txt", "r") as f:
    paper_content = f.read()

review = review_paper_with_gemini(paper_content, model_name="gemini-1.5-pro")

# Access structured data
print(f"Recommendation: {review.recommendation.decision}")
print(f"Confidence: {review.recommendation.confidence}")
print(f"Strengths:")
for strength in review.overall_assessment.strengths:
    print(f"  - {strength}")

# Save to JSON
with open("review.json", "w") as f:
    json.dump(json.loads(review.model_dump_json()), f, indent=2)
```

### Interactive PDF Chat
```python
from pdf_paper_reviewer import GeminiPDFChat

with GeminiPDFChat(model_name="gemini-1.5-pro") as chat:
    chat.load_pdf("research_paper.pdf")

    # Ask questions
    response = chat.generate_text("What are the main results?")
    print(response)
```

### Structured Output for Custom Schemas
```python
from pdf_paper_reviewer import GeminiPDFChat
from pydantic import BaseModel, Field
from typing import List

class Summary(BaseModel):
    title: str = Field(description="Paper title")
    main_contribution: str = Field(description="Main contribution in 1-2 sentences")
    methodology: str = Field(description="Methodology overview")
    results: List[str] = Field(description="Key results")

with GeminiPDFChat() as chat:
    chat.load_pdf("paper.pdf")
    summary = chat.generate_text("Summarize this paper", response_schema=Summary)
    print(summary.title)
    print(summary.main_contribution)
```

## Design Notes

- No state management - `response_schema` passed per-request, not stored
- No history tracking in the base chat class
- Returns Pydantic models when schema is provided, otherwise returns plain text
- Two main CLI entry points: `review` and `chat`
- Includes error handling for missing API keys, invalid PDFs, and connection errors

## API Models Supported

- `gemini-2.5-flash` (default)
- `gemini-1.5-pro`
- Any other Gemini model available in the API

## Error Handling

Scripts include error handling for:
- Missing API key
- Invalid PDFs
- Connection errors
- Logging to file and console

## Logging

Logs are written to:
- `pdf_paper_reviewer.log` - Main integrated tool
- `pdf_chat.log` - PDF chat standalone
- Console (INFO level and above)

## Limitations

- PDF must be valid and accessible
- API key required (set via environment variable)
- Structured output depends on Gemini model quality
- Large PDFs may hit API limits

## Future Enhancements

- Batch processing multiple PDFs
- Custom review templates
- Review comparison/aggregation
- PDF annotation export
- Web interface for reviews

## License

MIT
