.PHONY: help install install-dev test coverage lint format type-check clean docs all

# Default target
help:
	@echo "GemKit2 - Makefile targets:"
	@echo ""
	@echo "  install          Install project dependencies"
	@echo "  install-dev      Install project and dev dependencies"
	@echo "  test             Run pytest tests"
	@echo "  coverage         Run tests with coverage report"
	@echo "  lint             Run flake8 linter"
	@echo "  format           Format code with black and isort"
	@echo "  type-check       Run mypy type checker"
	@echo "  clean            Remove generated files and caches"
	@echo "  docs             Build Sphinx documentation"
	@echo "  all              Run lint, type-check, and test"
	@echo ""

install:
	pip install -r requirements.txt

install-dev:
	pip install -r requirements.txt

test:
	pytest Tests/ -v

coverage:
	pytest Tests/ --cov=gemkit --cov-report=html --cov-report=term-missing

lint:
	flake8 gemkit/ Tests/ apps/ --max-line-length=120 --extend-ignore=E203

format:
	black gemkit/ Tests/ apps/
	isort gemkit/ Tests/ apps/

type-check:
	mypy gemkit/ --ignore-missing-imports

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".coverage" -delete 2>/dev/null || true
	find . -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "dist" -exec rm -rf {} + 2>/dev/null || true

docs:
	cd docs 2>/dev/null && make html || echo "docs/ directory not found"

all: lint type-check test
	@echo "All checks passed!"
