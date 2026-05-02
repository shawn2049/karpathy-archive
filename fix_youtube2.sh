#!/usr/bin/env bash
# Fix YouTube metadata using oembed API
set -euo pipefail

BASE="/home/shawn/karpathy-archive"

fix_youtube_meta() {
    local slug="$1"
    local url="$2"
    local dir="$BASE/docs/$slug"
    local video_id="$3"
    
    echo "Fixing $slug (video: $video_id)..."
    
    # Get metadata from oembed
    local oembed_json=$(curl -s "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$video_id&format=json" 2>/dev/null)
    local title=$(echo "$oembed_json" | jq -r '.title // empty' 2>/dev/null)
    local author=$(echo "$oembed_json" | jq -r '.author_name // empty' 2>/dev/null)
    
    if [ -n "$title" ]; then
        {
            echo "Title: $title"
            echo "Author: $author"
            echo "Source URL: $url"
            echo "Video ID: $video_id"
            echo ""
            echo "(Metadata extracted via oembed API on $(date -u +'%Y-%m-%d %H:%M UTC'))"
        } > "$dir/meta.txt"
        echo "  Extracted title: $title"
    else
        {
            echo "Title: (could not fetch)"
            echo "Source URL: $url"
            echo "Video ID: $video_id"
        } > "$dir/meta.txt"
        echo "  Failed to fetch metadata"
    fi
    
    # Clean up the dummy page.html
    rm -f "$dir/page.html"
}

# All YouTube videos with their IDs
fix_youtube_meta "dwarkesh-podcast-2025" "https://www.youtube.com/watch?v=lXUZvyajciY" "lXUZvyajciY"
fix_youtube_meta "yc-ai-startup-school-2025" "https://www.youtube.com/watch?v=LCEmiRjPEtQ" "LCEmiRjPEtQ"
fix_youtube_meta "gpu-mode-2024" "https://www.youtube.com/watch?v=FH5wiwOyPX4" "FH5wiwOyPX4"
fix_youtube_meta "no-priors-podcast-2024" "https://www.youtube.com/watch?v=hM_h0UA7upI" "hM_h0UA7upI"
fix_youtube_meta "uc-berkeley-ai-hackathon-2024" "https://youtu.be/tsTeEkzO9xc" "tsTeEkzO9xc"
fix_youtube_meta "how-i-use-llms" "https://www.youtube.com/watch?v=EWvNQjAaOHw" "EWvNQjAaOHw"
fix_youtube_meta "intro-to-llms" "https://www.youtube.com/watch?v=zjkBMFhNj_g" "zjkBMFhNj_g"
fix_youtube_meta "deep-dive-llms" "https://www.youtube.com/watch?v=7xTGNNLPyMI" "7xTGNNLPyMI"
fix_youtube_meta "state-of-gpt" "https://www.youtube.com/watch?v=bZQun8Y4L2A" "bZQun8Y4L2A"

echo ""
echo "Done fixing YouTube metadata"
