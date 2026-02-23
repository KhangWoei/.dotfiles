---
name: markdown-first-fetch
description: >
  Use this skill whenever an agent needs to fetch, read, or retrieve content from a URL or web page.
  This skill ensures agents ALWAYS send Accept: text/markdown in the request header first, relying on
  Cloudflare's Markdown for Agents content negotiation, before falling back to fetching and parsing HTML.
  Trigger for ANY web fetch, page read, documentation lookup, or content scraping task — even if the
  user just says "go read that page" or "grab the content from X".
---

# Markdown-First Fetch

When fetching content from any URL, **always request markdown first** using HTTP content negotiation.
Many sites (including Cloudflare's own docs and blog, and any site running Cloudflare with Markdown for
Agents enabled) will return clean `text/markdown` instead of HTML when asked — saving tokens and
skipping HTML parsing entirely.

---

## Protocol

### Single request: GET with `Accept: text/markdown`

Always make a single GET request with the `Accept: text/markdown` header and branch on the response:

```
GET https://example.com/some/page
Accept: text/markdown
```

In code:
```javascript
const response = await fetch(url, {
  headers: { Accept: "text/markdown" }
});
```

```python
response = requests.get(url, headers={"Accept": "text/markdown"})
```

```bash
curl https://example.com/some/page -H "Accept: text/markdown"
```

### Branch on the response

- **`Content-Type: text/markdown`** -> use the body directly. Done.
- **`Content-Type: text/html`** -> parse the HTML body you already have. No second request needed.
- **`4xx` / `5xx`** -> retry without the `Accept: text/markdown` header.

---

## Bonus: x-markdown-tokens header

When a Cloudflare-powered site returns markdown, it includes an `x-markdown-tokens` header with the
estimated token count of the response. Use this to inform context window planning or chunking strategy:

```javascript
const tokenCount = response.headers.get("x-markdown-tokens");
```

---

## Decision Flowchart

```
GET with Accept: text/markdown
            │
            ▼
     Check response
            │
   ┌────────┼────────┐
   ▼        ▼        ▼
text/    text/    4xx/5xx
markdown  html       │
   │        │        ▼
   ▼        ▼    Retry without
Use body  Parse   Accept header
directly  HTML
```

---

## Notes

- **Always send `Accept: text/markdown`** — it is safe for any server. Servers that don't support it
  simply return HTML as usual (HTTP content negotiation is not an error case). There is no downside.
- This relies on Cloudflare's [Markdown for Agents](https://developers.cloudflare.com/fundamentals/reference/markdown-for-agents/)
  feature, which is enabled on Cloudflare Pro/Business/Enterprise zones. Sites not on Cloudflare (or without
  the feature enabled) will silently ignore the header and return HTML.
