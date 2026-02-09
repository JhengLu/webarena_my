#!/usr/bin/env python3
"""
Classify WebArena templates by site based on their content and context.
"""

import json
from collections import defaultdict


def classify_template_by_keywords(template):
    """
    Classify a template into a site based on keywords and patterns.

    Returns:
        str: Site name (shopping, gitlab, reddit, map, wikipedia, shopping_admin)
    """
    template_lower = template.lower()

    # GitLab indicators
    gitlab_keywords = [
        'repo', 'repository', 'commit', 'fork', 'issue', 'merge request',
        'gitlab', 'git', 'clone', 'branch', 'pull request', 'contributor'
    ]

    # Reddit indicators
    reddit_keywords = [
        'subreddit', 'submission', 'comment', 'upvote', 'downvote',
        'like all submissions', 'dislike all submissions', 'forum', 'post',
        'reddit', 'karma'
    ]

    # Map indicators
    map_keywords = [
        'map', 'location', 'coordinate', 'distance', 'walk', 'drive',
        'driving time', 'travel time', 'route', 'nearest', 'closest',
        'latitude', 'longitude', 'dd format', 'state', 'border'
    ]

    # Wikipedia indicators
    wikipedia_keywords = [
        'wikipedia', 'article', 'wiki', 'encyclopedia'
    ]

    # Shopping Admin indicators (order management, customer management, price changes)
    admin_keywords = [
        'order', 'customer', 'phone number', 'email', 'cancellation',
        'review_type', 'delete all', 'fulfilled order', 'pending order',
        'complete order', 'customer name'
    ]

    # Price modification patterns (admin only)
    admin_patterns = [
        'price of this product by',
        'price of {{config}} by',
        'change the price',
        'update the price',
        'increase the price',
        'decrease the price'
    ]

    # Shopping indicators (must check after admin to avoid conflicts)
    shopping_keywords = [
        'product', 'price', 'shopping', 'cart', 'review', 'rating',
        'brand', 'category', 'purchase', 'buy', 'item', 'customer',
        'stock', 'inventory', 'search'
    ]

    # Check for GitLab
    if any(keyword in template_lower for keyword in gitlab_keywords):
        return 'gitlab'

    # Check for Reddit
    if any(keyword in template_lower for keyword in reddit_keywords):
        return 'reddit'

    # Check for Map
    if any(keyword in template_lower for keyword in map_keywords):
        return 'map'

    # Check for Wikipedia
    if any(keyword in template_lower for keyword in wikipedia_keywords):
        return 'wikipedia'

    # Check for Shopping Admin (must be before general shopping)
    if any(keyword in template_lower for keyword in admin_keywords):
        return 'shopping_admin'
    if any(pattern in template_lower for pattern in admin_patterns):
        return 'shopping_admin'

    # Check for Shopping
    if any(keyword in template_lower for keyword in shopping_keywords):
        return 'shopping'

    # Default to unknown
    return 'unknown'


def classify_templates(input_file, output_file):
    """
    Read templates and classify them by site.
    """
    # Read the original templates file
    with open(input_file, 'r') as f:
        data = json.load(f)

    # Classify each template
    templates_by_site = defaultdict(list)
    site_stats = defaultdict(lambda: {'count': 0, 'total_usage': 0})

    for template_info in data['templates_by_frequency']:
        template = template_info['template']
        count = template_info['count']

        site = classify_template_by_keywords(template)

        templates_by_site[site].append({
            'template': template,
            'count': count
        })

        site_stats[site]['count'] += 1
        site_stats[site]['total_usage'] += count

    # Sort templates within each site by frequency
    for site in templates_by_site:
        templates_by_site[site].sort(key=lambda x: x['count'], reverse=True)

    # Create output structure
    output_data = {
        'metadata': {
            'source_file': input_file,
            'total_templates': data['metadata']['unique_templates'],
            'total_tasks': data['metadata']['total_entries'],
            'classification_method': 'keyword-based',
            'sites': list(site_stats.keys())
        },
        'site_statistics': {
            site: {
                'unique_templates': stats['count'],
                'total_tasks': stats['total_usage'],
                'percentage_of_templates': round(100 * stats['count'] / data['metadata']['unique_templates'], 1),
                'percentage_of_tasks': round(100 * stats['total_usage'] / data['metadata']['total_entries'], 1)
            }
            for site, stats in sorted(site_stats.items(), key=lambda x: x[1]['total_usage'], reverse=True)
        },
        'templates_by_site': dict(templates_by_site)
    }

    # Save to file
    with open(output_file, 'w') as f:
        json.dump(output_data, f, indent=2)

    # Print summary
    print(f"Template Classification Complete!")
    print(f"\nTotal templates: {data['metadata']['unique_templates']}")
    print(f"Total tasks: {data['metadata']['total_entries']}")
    print(f"\nTemplates by Site:")
    print("=" * 70)

    for site, stats in sorted(site_stats.items(), key=lambda x: x[1]['total_usage'], reverse=True):
        template_pct = 100 * stats['count'] / data['metadata']['unique_templates']
        task_pct = 100 * stats['total_usage'] / data['metadata']['total_entries']
        print(f"{site:15s}: {stats['count']:3d} templates ({template_pct:5.1f}%), "
              f"{stats['total_usage']:3d} tasks ({task_pct:5.1f}%)")

    print(f"\nOutput saved to: {output_file}")

    # Show top 3 templates per site
    print(f"\n{'='*70}")
    print("Top 3 Templates per Site:")
    print(f"{'='*70}")
    for site in sorted(templates_by_site.keys()):
        print(f"\n{site.upper()}:")
        for i, item in enumerate(templates_by_site[site][:3], 1):
            print(f"  {i}. [{item['count']}x] {item['template'][:70]}...")


if __name__ == '__main__':
    import sys

    input_file = '/mnt/2_1/webarena_my/config_files/extracted_templates/templates.json'
    output_file = '/mnt/2_1/webarena_my/config_files/extracted_templates/templates_by_site.json'

    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]

    classify_templates(input_file, output_file)
