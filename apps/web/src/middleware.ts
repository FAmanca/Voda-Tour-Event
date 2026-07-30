import { defineMiddleware } from 'astro:middleware';
import TurndownService from 'turndown';

/**
 * Astro Middleware for AI Agent Discovery and Content Negotiation.
 * 
 * This middleware fulfills two primary functions:
 * 1. Injecting Link headers into every response to advertise agent-friendly endpoints 
 *    (e.g., API Catalog and Agent Skills) as per Cloudflare's AI Discovery standards.
 * 2. Implementing content negotiation by checking the 'Accept' header. If a client (such as an AI agent)
 *    explicitly requests 'text/markdown' and the response is an HTML page, this middleware
 *    will automatically convert the rendered HTML into Markdown using TurndownService.
 * 
 * @param {import('astro').MiddlewareContext} context - The Astro context object.
 * @param {import('astro').MiddlewareNext} next - The next function in the middleware chain.
 * @returns {Promise<Response>} The modified Response object.
 */
export const onRequest = defineMiddleware(async (context, next) => {
  const response = await next();

  response.headers.append('Link', '</.well-known/api-catalog>; rel="api-catalog"');
  response.headers.append('Link', '</.well-known/agent-skills/index.json>; rel="agent-skills"');
  
  const acceptHeader = context.request.headers.get('Accept') || '';
  if (acceptHeader.includes('text/markdown') && response.headers.get('Content-Type')?.includes('text/html')) {
    const html = await response.text();
    
    const turndownService = new TurndownService({ headingStyle: 'atx' });
    turndownService.remove(['script', 'style', 'noscript', 'nav', 'header', 'footer']);
    const markdown = turndownService.turndown(html);
    
    return new Response(markdown, {
      status: 200,
      headers: {
        'Content-Type': 'text/markdown; charset=utf-8',
        'Link': response.headers.get('Link') || ''
      }
    });
  }

  return response;
});
