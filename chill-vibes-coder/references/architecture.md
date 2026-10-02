# Architecture

Read when starting a project, choosing a stack, structuring code, or designing an API or data model.

## Contents
- Choosing a stack
- Backend and frontend separation
- Project layout
- API design
- Data model
- Environments and configuration
- What not to build yet

## Choosing a stack

- Prefer what the user already has. Otherwise pick one mainstream, well-documented stack and stay on it. Do not mix frameworks or switch midway.
- Use the smallest thing that works: a static site needs no backend; a form needs one server function, not a microservice.
- A managed platform (hosting, database, auth) is the right call for someone who cannot operate servers. Say what it costs when free tiers end.
- One relational database (Postgres or SQLite) covers nearly everything. Add queues, caches or a second database only for a measured need.

## Backend and frontend separation

The rule: **the browser is untrusted territory.** Anything shipped to it can be read and altered by the visitor.

| Belongs on the server | Belongs on the client |
| --- | --- |
| Secrets, API keys, admin database access | Layout, interaction, form UX |
| Authorization and ownership checks | Optimistic UI, client-side hints |
| Prices, discounts, quotas, business rules | Display formatting |
| Calls to paid or privileged third-party APIs | Calls to your own API |
| Validation that counts | Validation for convenience only |

- Client-side validation improves the experience; server-side validation is the one that protects. Do both, trust only the second.
- In full-stack frameworks (Next.js, Nuxt, SvelteKit, Remix), keep the boundary explicit: server-only modules for secrets and data access, and never import them from client components.
- With a backend-as-a-service (Supabase, Firebase), the database is reachable directly from the browser. The security rules are the backend. Use the public/anon key in the client, the service/admin key only in server code.

## Project layout

- Separate concerns by folder: routes/handlers, business logic, data access, UI. A handler should not contain SQL and a component should not contain business rules.
- One source of truth for types and validation schemas, shared by client and server where the stack allows.
- Configuration comes from environment variables read in one module, validated at startup. Fail fast if one is missing.
- Keep files small enough to read in one pass. Split when a file holds more than one job.
- Include from the first commit: `.gitignore`, `.env.example`, a README with how to run it, and a lockfile.

## API design

- Resource-oriented routes, correct HTTP verbs, correct status codes (400 bad input, 401 not logged in, 403 not allowed, 404 not found, 409 conflict, 422 validation, 429 rate-limited, 5xx server fault).
- One consistent error shape, for example `{ "error": { "code": "...", "message": "..." } }`.
- Paginate every list endpoint. Never return an unbounded table.
- Return only the fields the client needs. Never serialize a whole database row (it leaks hashes, internal flags, other users' data).
- Identify records by IDs that are hard to guess (UUIDs) and still check ownership on every access.
- Make writes that can be retried idempotent (payments, emails, webhooks).

## Data model

- Design the tables before the screens. Name things plainly and consistently.
- Primary keys, foreign keys, unique and not-null constraints: let the database refuse bad data.
- Index the columns you filter and join on. Add `created_at`/`updated_at`.
- Store money as integer minor units (cents) with a currency code, never floats. Store times in UTC.
- Multi-tenant apps: every tenant-owned table has a tenant column, and every query filters by it on the server.
- Schema changes only through versioned migration files that are committed.

## Environments and configuration

- At least two environments: development and production, with separate databases and separate keys. Never develop against production data.
- Use test/sandbox keys for payment and email providers in development.
- Debug mode, verbose errors and seed/test accounts must be off in production.

## What not to build yet

Skip until there is a real need: microservices, Kubernetes, custom auth, a custom design system, premature caching layers, generic plugin systems, speculative configuration options. Each one costs tokens now and maintenance later.
