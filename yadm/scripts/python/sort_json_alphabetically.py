# /// script
# dependencies = [
#   "json5"
# ]
# ///
import sys
import os
import json5
import re

def sort_keys_recursively(obj):
    if isinstance(obj, dict):
        return {k: sort_keys_recursively(obj[k]) for k in sorted(obj)}
    elif isinstance(obj, list):
        return [sort_keys_recursively(item) for item in obj]
    else:
        return obj

if len(sys.argv) < 2:
    print("Usage: python sort_json_alphabetically.py <path-to-json-file>")
    sys.exit(1)

file_path = sys.argv[1]
base_dir = os.path.dirname(file_path)
original_filename = os.path.basename(file_path)
sorted_filename = f"sorted_{original_filename}"
sorted_path = os.path.join(base_dir, sorted_filename)

with open(file_path, 'r') as f:
    data = json5.load(f)

sorted_data = sort_keys_recursively(data)

with open(sorted_path, 'w') as f:
    json5.dump(sorted_data, f, indent=2)

# Read the output for post-processing
with open(sorted_path, 'r') as f:
    content = f.read()

# Remove trailing commas before } or ]
content = re.sub(r',(\s*[\}\]])', r'\1', content)

# Double quote all keys (including nested)
# This regex matches keys that are not quoted (before a colon, not preceded by // or inside quotes)
content = re.sub(
    r'(?m)^(?P<indent>\s*)(?P<key>[A-Za-z0-9_\-\.]+):',
    lambda m: f'{m.group("indent")}"{m.group("key")}":',
    content
)

with open(sorted_path, 'w') as f:
    f.write(content)

print(f"Sorted JSON written to {sorted_path}")