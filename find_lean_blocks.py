#!/usr/bin/env python3
import os
import re

def find_lean_blocks(lean_book_path):
    lean_files = []
    lean_blocks = []
    
    for root, dirs, files in os.walk(lean_book_path):
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    if '```lean' in content:
                        lean_files.append(filepath)
                        
                        # Extract lean blocks
                        pattern = r'```lean\s*\n(.*?)\n```'
                        matches = re.findall(pattern, content, re.DOTALL)
                        for i, block in enumerate(matches):
                            lean_blocks.append((filepath, i, block))
    
    return lean_files, lean_blocks

def main():
    lean_book_path = '/home/adrabi/dev/lean/lean4-learning/lean_book'
    lean_files, lean_blocks = find_lean_blocks(lean_book_path)
    
    print(f"Found {len(lean_files)} markdown files with ```lean blocks")
    print(f"Total lean blocks: {len(lean_blocks)}")
    
    # Check for sorry, admit, axiom, unsafe
    forbidden_words = ['sorry', 'admit', 'axiom', 'unsafe']
    
    for filepath, block_num, block in lean_blocks:
        # Check for forbidden words
        for word in forbidden_words:
            if word in block:
                print(f"\nFound '{word}' in {filepath}:{block_num}")
                print("Block content:")
                print(block)
                print("-" * 80)
    
    # Write all lean blocks to a file for review
    with open('/tmp/all_lean_blocks.txt', 'w') as f:
        f.write(f"Total blocks: {len(lean_blocks)}\n\n")
        for filepath, block_num, block in lean_blocks:
            f.write(f"=== {filepath}:{block_num} ===\n")
            f.write(f"```lean\n{block}\n```\n\n")

if __name__ == "__main__":
    main()
