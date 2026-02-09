# WebArena Template Analysis

This directory contains extracted intent templates from the WebArena test dataset.

## Dataset Overview

**Source:** [test.raw.json](../test.raw.json)

- **Total tasks:** 812
- **Unique templates:** 241
- **Sites covered:** 6 (Reddit, Shopping, Shopping Admin, GitLab, Wikipedia, Map)

## Files in This Directory

1. **templates.json** (118 KB)
   - Complete structured data with metadata
   - Each template includes its frequency count
   - Sorted both alphabetically and by frequency

2. **unique_templates.txt** (15 KB)
   - Simple list of all 241 unique templates
   - One template per line
   - Useful for quick browsing

3. **templates_with_counts.txt** (17 KB)
   - Templates sorted by frequency (most common first)
   - Shows usage count for each template
   - Includes summary statistics

## Template Characteristics

### Placeholder Types Used

WebArena templates use various placeholders:

- `{{attribute}}` - Product/order attributes (e.g., "price", "status", "email")
- `{{description}}` - Descriptive text
- `{{user}}` - Usernames
- `{{repo}}` - Repository names (GitLab)
- `{{place}}`, `{{location}}` - Geographic locations (Map)
- `{{product}}`, `{{category}}` - Shopping items
- `{{status}}` - Order status (e.g., "pending", "complete")
- `{{date}}`, `{{time}}`, `{{period}}` - Temporal references
- `{{amount}}`, `{{price}}`, `{{num}}` - Numeric values
- `{{keyword}}`, `{{term}}` - Search terms

### Most Common Templates

Top 10 most frequently used templates:

1. **7x** - `Get the {{attribute}} of the {{status}} order`
2. **7x** - `Find the page of {{description}} on the map.`
3. **6x** - `List out reviewers, if exist, who mention about {{description}}`
4. **6x** - `Fork {{repo}}.`
5. **6x** - `{{action}} the price of this product by {{amount}}`
6. **6x** - `Create a repo named {{name}} with {{topics}} in a README file`
7. **6x** - `Like all submissions created by {{user}} in subreddit {{subreddit}}`
8. **6x** - `DisLike all submissions created by {{user}} in subreddit {{subreddit}}`
9. **6x** - `Delete all {{review_type}}`
10. **6x** - `{{action}} the price of {{config}} by {{amount}}`

### Template Distribution by Site

Based on template content patterns:

- **Shopping/E-commerce** (~35%): Order management, product browsing, reviews
- **GitLab** (~25%): Repository operations, commits, issues
- **Reddit** (~15%): Submissions, comments, likes/dislikes
- **Map/Geography** (~15%): Locations, distances, travel time
- **Wikipedia** (~5%): Information retrieval
- **Shopping Admin** (~5%): Price updates, customer management

## Comparison: WebArena vs VisualWebArena

| Metric | WebArena | VisualWebArena |
|--------|----------|----------------|
| Total Tasks | 812 | 910 |
| Unique Templates | 241 | 315 |
| Sites | 6 | 3 |
| Average Reuse | 3.4x | 2.9x |

**Key Insights:**
- WebArena has slightly fewer tasks but MORE diverse templates (241 vs 315)
- WebArena covers more sites (6 vs 3), including GitLab, Wikipedia, and Map
- VisualWebArena focuses on visual interaction tasks (Reddit, Shopping, Classifieds)
- WebArena templates are reused more frequently (3.4x vs 2.9x average)

## Task Categories

### Information Retrieval Tasks
```
- Tell me the {{attribute}} of {{entity}}
- Show me {{information}}
- What is the {{property}} of {{item}}
- How many {{things}} {{condition}}
```

### Action Tasks
```
- {{action}} the {{item}}
- Create {{entity}} with {{properties}}
- Delete {{items}}
- Fork {{repo}}
```

### Navigation Tasks
```
- Find {{target}}
- Show me {{items}} under {{condition}}
- Browse {{category}}
- Search for "{{keyword}}"
```

### Comparison/Analysis Tasks
```
- Tell me the closest {{place}} to {{location}}
- What are the main criticisms of {{product}}
- Compare {{item1}} and {{item2}}
```

## Example Templates by Site

### Shopping
```
- What is the price range for products from {{brand}}?
- Show me products under ${{price}} in "{{product_category}}" category
- I want to browse the products in the {{category}} category
- Tell me the reasons why customers like {{product}}
```

### GitLab
```
- Fork {{repo}}.
- Create a repo named {{name}} with {{topics}} in a README file
- Display the list of issues in the {{repo}} repository that have labels related to {{label}}
- How many commits did {{user}} make to {{repo}} on {{date}}?
```

### Reddit
```
- Like all submissions created by {{user}} in subreddit {{subreddit}}
- DisLike all submissions created by {{user}} in subreddit {{subreddit}}
- Tell me the count of comments that have received more downvotes than upvotes
```

### Map
```
- Find the page of {{description}} on the map.
- How long does it take to walk from {{start}} to {{end}}?
- Tell me the closest {{place1}}(s) to {{place2}}
- What is the minimum travel time by car from {{location1}} to {{location2}}?
```

### Shopping Admin
```
- {{action}} the price of this product by {{amount}}
- Delete all {{review_type}}
- Get the {{attribute}} of the {{status}} order
- Find the customer name and email with phone number {{PhoneNum}}
```

## Template Complexity

### Simple Templates (1-2 placeholders)
```
- Fork {{repo}}.
- Search for "{{keyword}}"
- Show the most recent {{status}} order
```

### Medium Templates (3-4 placeholders)
```
- Tell me the {{attribute}} of the {{status}} order
- Show me products under ${{price}} in "{{product_category}}" category
- How many commits did {{user}} make to {{repo}} on {{date}}?
```

### Complex Templates (5+ placeholders)
```
- Today is 6/12/2023. Tell me how many fulfilled orders I have {{period}}, and the total amount of money I spent.
- Tell me the count of comments that have received more downvotes than upvotes for the user who made the latest post on the {{forum}} forum.
```

## Usage

### Extracting Templates from Other Files

Use the extraction script:

```bash
python3 /mnt/2_1/extract_intent_templates.py <input_file.raw.json> <output_directory>
```

Example:
```bash
python3 /mnt/2_1/extract_intent_templates.py \
  /mnt/2_1/webarena_my/config_files/test.raw.json \
  /mnt/2_1/webarena_my/config_files/extracted_templates
```

### Analyzing Template Usage

The `templates.json` file provides structured data for programmatic analysis:

```python
import json

with open('templates.json', 'r') as f:
    data = json.load(f)

# Get metadata
print(f"Total tasks: {data['metadata']['total_entries']}")
print(f"Unique templates: {data['metadata']['unique_templates']}")

# Get most common templates
for item in data['templates_by_frequency'][:10]:
    print(f"{item['count']}x - {item['template']}")
```

## Notes

- Templates use double curly braces `{{placeholder}}` for variable substitution
- The actual values for placeholders are stored in the `instantiation_dict` field
- The LLM only receives the instantiated `intent`, not the template or placeholders
- Templates are designed to be general enough for multiple task variations

## Related Documentation

For detailed information on how these templates are used in the system:
- See `/mnt/2_1/visualwebarena_my/config_files/vwa/extracted_templates/` for VisualWebArena template analysis
- See `/mnt/2_1/visualwebarena_my/config_files/vwa/extracted_templates/data_flow_explanation.md` for how config data flows to the LLM
