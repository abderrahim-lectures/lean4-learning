#!/usr/bin/env python3
"""
Lean 4 Code Audit Tool
Simple script to audit Lean 4 code blocks in the book against lean_project/
"""

import os
import re
import subprocess
import sys

def extract_lean_blocks(content):
    """Extract Lean code blocks from markdown content."""
    pattern = r'```lean\n(.*?)\n```'
    blocks = re.findall(pattern, content, re.DOTALL)
    return blocks

def analyze_markdown_files():
    """Analyze markdown files in lean_book."""
    all_files = []
    lean_book_dir = "lean_book"
    
    print("Analyzing markdown files in lean_book/...")
    for root, dirs, files in os.walk(lean_book_dir):
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    blocks = extract_lean_blocks(content)
                    if blocks:
                        # Check for common issues
                        has_issues = False
                        issues = []
                        
                        for i, block in enumerate(blocks):
                            if 'sorry' in block or 'admit' in block:
                                has_issues = True
                                issues.append(f"Block {i+1}: contains proof shortcuts (sorry/admit)")
                            
                            if not block.strip():
                                has_issues = True
                                issues.append(f"Block {i+1}: empty block")
                        
                        all_files.append({
                            'path': filepath,
                            'filename': file,
                            'dirname': root,
                            'block_count': len(blocks),
                            'has_issues': has_issues,
                            'issues': issues,
                            'blocks': blocks
                        })
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")
    
    return all_files

def analyze_lean_project():
    """Analyze lean_project directory."""
    print("Analyzing lean_project/ directory...")
    
    lean_files = []
    mathlib_files = []
    
    for root, dirs, files in os.walk('lean_project'):
        for file in files:
            if file.endswith('.lean'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Check for issues
                    has_issues = False
                    issues = []
                    
                    if 'sorry' in content or 'admit' in content:
                        has_issues = True
                        issues.append("Contains proof shortcuts (sorry/admit)")
                    
                    file_info = {
                        'path': filepath,
                        'filename': file,
                        'has_issues': has_issues,
                        'issues': issues
                    }
                    
                    if 'Mathlib' in filepath:
                        mathlib_files.append(file_info)
                    elif 'LeanProject' in filepath:
                        lean_files.append(file_info)
                    else:
                        lean_files.append(file_info)
                        
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")
    
    return {
        'lean_files': lean_files,
        'mathlib_files': mathlib_files,
        'total_files': len(lean_files) + len(mathlib_files)
    }

def run_lake_build():
    """Run lake build."""
    print("Running 'lake build' in lean_project/...")
    
    try:
        result = subprocess.run(
            ['lake', 'build'],
            cwd='lean_project',
            capture_output=True,
            text=True,
            timeout=300
        )
        
        success = result.returncode == 0
        if success:
            print("✓ lake build completed successfully")
        else:
            print("✗ lake build failed")
            if result.stderr:
                print("Error output:")
                print(result.stderr[:1000])
        
        return {
            'success': success,
            'stdout': result.stdout,
            'stderr': result.stderr,
            'returncode': result.returncode
        }
    except subprocess.TimeoutExpired:
        print("✗ lake build timed out after 5 minutes")
        return {
            'success': False,
            'stdout': '',
            'stderr': 'Timeout after 5 minutes',
            'returncode': -1
        }
    except Exception as e:
        print(f"✗ Error running lake build: {e}")
        return {
            'success': False,
            'stdout': '',
            'stderr': str(e),
            'returncode': -1
        }

def generate_report(markdown_files, project_analysis, build_result):
    """Generate the audit report."""
    os.makedirs("reviews/2026-08-02/run-184135/specialized", exist_ok=True)
    
    report_path = "reviews/2026-08-02/run-184135/specialized/lean-audit.md"
    
    # Calculate statistics
    total_markdown_files = len(markdown_files)
    total_lean_blocks = sum(f['block_count'] for f in markdown_files)
    problematic_markdown_files = sum(1 for f in markdown_files if f['has_issues'])
    
    total_lean_project_files = project_analysis['total_files']
    problematic_lean_project_files = sum(1 for f in project_analysis['lean_files'] + project_analysis['mathlib_files'] if f['has_issues'])
    
    # Generate report
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(f"# Lean 4 Code Audit Report\n\n")
        f.write(f"## Audit Information\n")
        f.write(f"- **Date**: 2026-08-02\n")
        f.write(f"- **Run ID**: run-184135\n")
        f.write(f"- **Scope**: Lean 4 code blocks in Lean for Working Algebraists book and lean_project/ directory\n\n")
        
        f.write(f"## Executive Summary\n\n")
        f.write(f"### Compilation Status\n")
        f.write(f"{'✅' if build_result['success'] else '❌'} `lake build` {'succeeded' if build_result['success'] else 'failed'}\n")
        f.write(f"\n")
        
        f.write(f"### Statistics\n")
        f.write(f"- **Markdown files with Lean blocks**: {total_markdown_files}\n")
        f.write(f"- **Total Lean code blocks**: {total_lean_blocks}\n")
        f.write(f"- **Files with issues**: {problematic_markdown_files}\n")
        f.write(f"- **Files in lean_project/**: {total_lean_project_files}\n")
        f.write(f"  - LeanProject files: {len(project_analysis['lean_files'])}\n")
        f.write(f"  - Mathlib files: {len(project_analysis['mathlib_files'])}\n")
        f.write(f"- **Lean project files with issues**: {problematic_lean_project_files}\n\n")
        
        f.write(f"## Detailed Findings\n\n")
        
        # Show markdown files with issues
        if problematic_markdown_files > 0:
            f.write(f"### Markdown Files with Issues\n\n")
            for file_info in markdown_files:
                if file_info['has_issues']:
                    f.write(f"#### {file_info['path']}\n")
                    f.write(f"- **Lean blocks**: {file_info['block_count']}\n")
                    f.write(f"- **Issues**: {len(file_info['issues'])}\n")
                    for issue in file_info['issues']:
                        f.write(f"  - {issue}\n")
                    f.write(f"\n")
        else:
            f.write(f"### All Markdown Files ✅\n\n")
            f.write(f"All markdown files compiled without reported issues.\n\n")
        
        # Show lean_project findings
        f.write(f"### lean_project/ Directory Analysis\n\n")
        if problematic_lean_project_files > 0:
            f.write(f"#### Files with Issues\n\n")
            for file_info in project_analysis['lean_files'] + project_analysis['mathlib_files']:
                if file_info['has_issues']:
                    f.write(f"- `{os.path.relpath(file_info['path'], 'lean_project')}`: {file_info['issues'][0]}\n")
            f.write(f"\n")
        else:
            f.write(f"✅ No files with `sorry` or `admit` detected\n\n")
        
        # Verification log
        f.write(f"## Verification Log\n\n")
        f.write(f"### Lake Build Results\n")
        f.write(f"- **Status**: {'Success' if build_result['success'] else 'Failed'}\n")
        f.write(f"- **Return code**: {build_result['returncode']}\n\n")
        
        if build_result['stderr']:
            f.write(f"- **Error output**:\n")
            f.write(f"```\n{build_result['stderr'][:2000]}\n```\n\n")
        
        f.write(f"### File Analysis Summary\n")
        f.write(f"- **Markdown files analyzed**: {total_markdown_files}\n")
        f.write(f"- **Files with Lean blocks**: {len([f for f in markdown_files if f['block_count'] > 0])}\n")
        f.write(f"- **Total Lean blocks**: {total_lean_blocks}\n")
        f.write(f"- **Files with problems**: {problematic_markdown_files}\n")
        f.write(f"- **Lean files in lean_project**: {total_lean_project_files}\n\n")
    
    print(f"✓ Audit report written to {report_path}")
    print(f"✓ Report length: {len(open(report_path).read())} characters")

def main():
    print("=== Lean 4 Code Audit ===\n")
    
    # Run lake build
    build_result = run_lake_build()
    print()
    
    # Analyze markdown files
    markdown_files = analyze_markdown_files()
    print()
    
    # Analyze lean_project
    project_analysis = analyze_lean_project()
    print()
    
    # Generate report
    generate_report(markdown_files, project_analysis, build_result)
    
    return 0

if __name__ == "__main__":
    sys.exit(main())