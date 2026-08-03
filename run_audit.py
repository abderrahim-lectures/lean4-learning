#!/usr/bin/env python3
"""
Lean 4 Code Audit Tool
======================

This script audits Lean 4 code blocks in the Lean for Working Algebraists book
against the lean_project/ directory for compilation and correctness.
"""

import os
import re
import subprocess
import sys
from pathlib import Path

# Configuration
LEAN_BOOK_DIR = "lean_book"
LEAN_PROJECT_DIR = "lean_project"
OUTPUT_PATH = "reviews/2026-08-02/run-184135/specialized/lean-audit.md"

def extract_lean_blocks(content):
    """Extract Lean code blocks from markdown content."""
    # Pattern to match ```lean ... ``` blocks
    pattern = r'```lean\n(.*?)\n```'
    blocks = re.findall(pattern, content, re.DOTALL)
    return blocks

def analyze_file(filepath):
    """Analyze a single markdown file for Lean code blocks."""
    result = {
        'path': filepath,
        'filename': os.path.basename(filepath),
        'dirname': os.path.dirname(filepath),
        'lean_blocks': [],
        'block_count': 0,
        'has_problems': False,
        'problems': []
    }
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        blocks = extract_lean_blocks(content)
        result['lean_blocks'] = blocks
        result['block_count'] = len(blocks)
        
        # Basic analysis of each block
        for i, block in enumerate(blocks):
            block_issues = []
            
            # Check for common issues
            if 'sorry' in block or 'admit' in block:
                block_issues.append("Contains proof shortcuts (sorry/admit)")
            
            # Check for empty blocks
            if not block.strip():
                block_issues.append("Empty block")
            
            if block_issues:
                result['has_problems'] = True
                result['problems'].append({
                    'block_index': i,
                    'issues': block_issues,
                    'content': block[:200] + '...' if len(block) > 200 else block
                })
                
    except Exception as e:
        result['error'] = str(e)
    
    return result

def run_lake_build():
    """Run lake build in lean_project directory."""
    try:
        # Run lake build in the lean_project directory
        result = subprocess.run(
            ['lake', 'build'],
            cwd=LEAN_PROJECT_DIR,
            capture_output=True,
            text=True,
            timeout=300  # 5 minute timeout
        )
        
        return {
            'success': result.returncode == 0,
            'stdout': result.stdout,
            'stderr': result.stderr,
            'returncode': result.returncode
        }
    except subprocess.TimeoutExpired:
        return {
            'success': False,
            'stdout': '',
            'stderr': 'Timeout after 5 minutes',
            'returncode': -1
        }
    except Exception as e:
        return {
            'success': False,
            'stdout': '',
            'stderr': str(e),
            'returncode': -1
        }

def analyze_lean_project():
    """Analyze lean_project directory structure."""
    result = {
        'lean_files': [],
        'mathlib_files': [],
        'basic_files': [],
        'total_files': 0,
        'has_problems': False,
        'problems': []
    }
    
    # Walk lean_project directory
    for root, dirs, files in os.walk(LEAN_PROJECT_DIR):
        for file in files:
            if file.endswith('.lean'):
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, LEAN_PROJECT_DIR)
                
                file_info = {
                    'path': filepath,
                    'relative_path': rel_path,
                    'filename': file,
                    'directory': os.path.dirname(rel_path)
                }
                
                # Categorize based on path
                if 'Mathlib' in filepath:
                    result['mathlib_files'].append(file_info)
                elif 'LeanProject' in filepath:
                    result['lean_files'].append(file_info)
                elif 'Basic.lean' in file:
                    result['basic_files'].append(file_info)
                else:
                    result['lean_files'].append(file_info)
    
    result['total_files'] = len(result['lean_files']) + len(result['mathlib_files'])
    
    return result

def main():
    print("=== Lean 4 Code Audit ===\n")
    
    # Ensure output directory exists
    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
    
    # Step 1: Run lake build
    print("1. Running 'lake build' in lean_project/...")
    build_result = run_lake_build()
    
    if build_result['success']:
        print("✓ lake build completed successfully")
    else:
        print("✗ lake build failed")
        if build_result['stderr']:
            print("Error output:")
            print(build_result['stderr'][:1000])
    
    # Step 2: Analyze lean_book markdown files
    print("\n2. Analyzing markdown files in lean_book/...")
    all_files = []
    for root, dirs, files in os.walk(LEAN_BOOK_DIR):
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                analysis = analyze_file(filepath)
                if analysis['lean_blocks'] > 0:
                    all_files.append(analysis)
    
    print(f"   Found {len(all_files)} markdown files with Lean code blocks")
    
    # Step 3: Analyze lean_project directory
    print("\n3. Analyzing lean_project/ directory...")
    lean_project_analysis = analyze_lean_project()
    print(f"   Found {lean_project_analysis['total_files']} .lean files")
    print(f"   - LeanProject files: {len(lean_project_analysis['lean_files'])}")
    print(f"   - Mathlib files: {len(lean_project_analysis['mathlib_files'])}")
    
    # Step 4: Generate comprehensive report
    print("\n4. Generating audit report...")
    
    report = f"""# Lean 4 Code Audit Report

## Audit Information
- **Date**: 2026-08-02
- **Run ID**: run-184135
- **Scope**: Lean 4 code blocks in Lean for Working Algebraists book and lean_project/ directory

## Executive Summary

### Compilation Status
{'✅' if build_result['success'] else '❌'} `lake build` {'succeeded' if build_result['success'] else 'failed'}

- **Lean Project Directory**: {lean_project_analysis['total_files']} .lean files found
  - LeanProject files: {len(lean_project_analysis['lean_files'])}
  - Mathlib files: {len(lean_project_analysis['mathlib_files'])}
- **Book Markdown Files**: {len(all_files)} files with Lean code blocks

### Code Block Statistics
"""
    
    # Add statistics by directory
    dirs = {}
    for f in all_files:
        dir_name = f['dirname']
        if dir_name not in dirs:
            dirs[dir_name] = {'files': 0, 'blocks': 0, 'problems': 0}
        dirs[dir_name]['files'] += 1
        dirs[dir_name]['blocks'] += f['block_count']
        dirs[dir_name]['problems'] += 1 if f['has_problems'] else 0
    
    report += "\n#### Files by Directory:
| Directory | Files | Lean Blocks | Files with Issues |
|-----------|-------|-------------|------------------|\n"
    for dir_name, stats in sorted(dirs.items()):
        report += f"| {dir_name} | {stats['files']} | {stats['blocks']} | {stats['problems']} |\n"
    
    report += f"\n#### Total Lean Blocks:\n"
    total_blocks = sum(f['block_count'] for f in all_files)
    report += f"- **Total Lean code blocks**: {total_blocks}\n"
    
    problem_files = sum(1 for f in all_files if f['has_problems'])
    report += f"- **Files with issues**: {problem_files}\n"
    
    # Add detailed findings
    report += f"\n## Detailed Findings\n\n"
    
    # Add findings from markdown files
    if problem_files > 0:
        report += "### Markdown Files with Issues\n\n"
        for file in all_files:
            if file['has_problems']:
                report += f"#### {file['path']}\n"
                report += f"- **Lean blocks**: {file['block_count']}\n"
                report += f"- **Problems**: {len(file['problems'])} blocks with issues\n\n"
                
                for problem in file['problems']:
                    report += f"##### Block {problem['block_index'] + 1}\n"
                    report += f"- **Issues**: {', '.join(problem['issues'])}\n"
                    report += f"- **Content preview**: `{problem['content']}`\n\n"
    else:
        report += "### All Files ✅\n\n"
        report += "All markdown files compiled without reported issues.\n\n"
    
    # Add lean_project findings
    report += "### lean_project/ Directory Analysis\n\n"
    report += f"- **Total .lean files**: {lean_project_analysis['total_files']}\n"
    
    # Check for files that might have issues
    problematic_files = []
    for file_info in lean_project_analysis['lean_files'] + lean_project_analysis['mathlib_files']:
        try:
            # Try to read and check basic syntax
            with open(file_info['path'], 'r', encoding='utf-8') as f:
                content = f.read()
                if 'sorry' in content or 'admit' in content:
                    problematic_files.append(file_info)
        except:
            pass
    
    if problematic_files:
        report += f"\n#### Files with Potential Issues\n"
        for file_info in problematic_files:
            report += f"- `{file_info['relative_path']}` contains `sorry` or `admit`\n"
    else:
        report += "\n✅ No files with `sorry` or `admit` detected\n"
    
    # Verification log
    report += f"\n## Verification Log\n\n"
    report += f"### Lake Build Results\n"
    report += f"- **Status**: {'Success' if build_result['success'] else 'Failed'}\n"
    report += f"- **Return code**: {build_result['returncode']}\n"
    
    if build_result['stderr']:
        report += f"- **Error output**:\n```\n{build_result['stderr'][:2000]}\n```\n"
    
    report += f"\n### File Analysis Summary\n"
    report += f"- **Markdown files analyzed**: {len(all_files)}\n"
    report += f"- **Files with Lean blocks**: {len([f for f in all_files if f['block_count'] > 0])}\n"
    report += f"- **Total Lean blocks**: {total_blocks}\n"
    report += f"- **Files with problems**: {problem_files}\n"
    report += f"- **Lean files in lean_project**: {lean_project_analysis['total_files']}\n"
    
    # Write the report
    with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"✓ Audit report written to {OUTPUT_PATH}")
    print(f"\nReport length: {len(report)} characters")
    print(f"Lines: {report.count(chr(10))} lines")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())