#!/usr/bin/env python3
"""
Classify WebArena templates by site using the actual 'sites' field from config.
This is 100% accurate unlike keyword-based classification.
"""

import json
from collections import defaultdict


def classify_templates_accurately(raw_json_file, output_file):
    """
    Read the raw JSON and classify templates by their actual site field.
    """
    # Read the raw JSON file
    with open(raw_json_file, 'r') as f:
        tasks = json.load(f)

    # Map templates to sites
    template_to_site = {}
    template_counts = defaultdict(int)
    site_stats = defaultdict(lambda: {'count': 0, 'total_usage': 0})
    templates_by_site = defaultdict(list)

    # Process each task
    for task in tasks:
        template = task.get('intent_template', '')
        sites = task.get('sites', [])

        if not template:
            continue

        # Use the first site in the list (tasks usually have 1 site)
        site = sites[0] if sites else 'unknown'

        # Track the template
        template_counts[template] += 1
        template_to_site[template] = site

    # Build the output structure
    for template, site in template_to_site.items():
        count = template_counts[template]

        templates_by_site[site].append({
            'template': template,
            'count': count
        })

        site_stats[site]['count'] += 1
        site_stats[site]['total_usage'] += count

    # Sort templates within each site by frequency
    for site in templates_by_site:
        templates_by_site[site].sort(key=lambda x: x['count'], reverse=True)

    # Calculate total
    total_templates = sum(stats['count'] for stats in site_stats.values())
    total_tasks = sum(stats['total_usage'] for stats in site_stats.values())

    # Create output structure
    output_data = {
        'metadata': {
            'source_file': raw_json_file,
            'total_templates': total_templates,
            'total_tasks': total_tasks,
            'classification_method': 'ground-truth (from sites field)',
            'sites': sorted(list(site_stats.keys()))
        },
        'site_statistics': {
            site: {
                'unique_templates': stats['count'],
                'total_tasks': stats['total_usage'],
                'percentage_of_templates': round(100 * stats['count'] / total_templates, 1),
                'percentage_of_tasks': round(100 * stats['total_usage'] / total_tasks, 1)
            }
            for site, stats in sorted(site_stats.items(), key=lambda x: x[1]['total_usage'], reverse=True)
        },
        'templates_by_site': dict(templates_by_site)
    }

    # Save to file
    with open(output_file, 'w') as f:
        json.dump(output_data, f, indent=2)

    # Print summary
    print(f"Template Classification Complete (Ground Truth)!")
    print(f"\nTotal templates: {total_templates}")
    print(f"Total tasks: {total_tasks}")
    print(f"\nTemplates by Site (sorted by task count):")
    print("=" * 80)

    for site, stats in sorted(site_stats.items(), key=lambda x: x[1]['total_usage'], reverse=True):
        template_pct = 100 * stats['count'] / total_templates
        task_pct = 100 * stats['total_usage'] / total_tasks
        print(f"{site:20s}: {stats['count']:3d} templates ({template_pct:5.1f}%), "
              f"{stats['total_usage']:3d} tasks ({task_pct:5.1f}%)")

    print(f"\nOutput saved to: {output_file}")

    # Show top 5 templates per site
    print(f"\n{'='*80}")
    print("Top 5 Templates per Site:")
    print(f"{'='*80}")
    for site in sorted(templates_by_site.keys()):
        print(f"\n{site.upper()}:")
        for i, item in enumerate(templates_by_site[site][:5], 1):
            template_preview = item['template'][:65] + "..." if len(item['template']) > 65 else item['template']
            print(f"  {i}. [{item['count']}x] {template_preview}")


if __name__ == '__main__':
    import sys

    raw_json_file = '/mnt/2_1/webarena_my/config_files/test.raw.json'
    output_file = '/mnt/2_1/webarena_my/config_files/extracted_templates/templates_by_site_accurate.json'

    if len(sys.argv) > 1:
        raw_json_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]

    classify_templates_accurately(raw_json_file, output_file)
