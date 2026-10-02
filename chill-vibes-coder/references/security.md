# Security

Read when building auth, permissions, forms, uploads, admin areas, LLM features, or handling a leaked secret. Sections follow the OWASP Top 10:2025, followed by the failures most specific to AI-built apps.

## Contents
- The failures AI-built apps ship most
- A01 Broken Access Control
- A02 Security Misconfiguration
- A03 Software Supply Chain Failures
- A04 Cryptographic Failures
- A05 Injection
- A06 Insecure Design
- A07 Authentication Failures
- A08 Software or Data Integrity Failures
- A09 Security Logging and Alerting Failures
- A10 Mishandling of Exceptional Conditions
- LLM features
- A secret leaked: what to do

## The failures AI-built apps ship most

Check these first; they account for most real incidents in AI-generated apps.

1. API keys or admin database keys in frontend code or in the repo.
2. Database reachable from the browser with row-level security off or with allow-all policies.
3. API endpoints with no authentication, or that check login but not ownership.
4. Privilege stored where the user can edit it (role, plan, credits on their own profile row).
5. User input passed straight into queries, HTML, shell commands or file paths.
6. Verbose errors and debug mode in production.
7. No rate limits or spending caps on costly endpoints.
8. Packages that do not exist or were never vetted.

## A01 Broken Access Control

- Deny by default. Every route and server action checks authentication, then authorization, on the server.
- Check ownership per record: `WHERE id = ? AND owner_id = <session user>`. Never trust an ID, role or tenant sent by the client.
- Admin functions verify the admin role on the server on each call.
- Supabase/Firebase: enable RLS/rules on every table and bucket; write policies per operation (select, insert, update, delete); test them as an anonymous user and as a different user.
- Server-side request forgery belongs here: when the server fetches a user-supplied URL, allowlist hosts and block private/internal addresses.
- CORS is not access control. Do not use `*` with credentials.
- State-changing requests authenticated by cookie need CSRF protection (SameSite cookies plus a token, or the framework's built-in mechanism).

## A02 Security Misconfiguration

- Production: debug off, default accounts removed, directory listing off, admin panels and database ports not exposed to the internet.
- Headers: `Strict-Transport-Security`, `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, and `frame-ancestors` (or `X-Frame-Options`).
- Storage buckets private by default; serve private files through signed, expiring URLs.
- Least privilege for every key, database user and cloud role.

## A03 Software Supply Chain Failures

- Before adding a package: confirm it exists on the official registry, is maintained, and is the name you meant (typo-squatting and hallucinated names are real attack vectors).
- Commit the lockfile. Install with the locked command in CI (`npm ci`, `pip install --require-hashes` or equivalent).
- Run the ecosystem's audit (`npm audit`, `pip-audit`) and enable automated dependency alerts on the repo.
- Third-party scripts loaded from a CDN get Subresource Integrity or are self-hosted.
- Do not pipe remote scripts into a shell or run install scripts from unknown sources.

## A04 Cryptographic Failures

- HTTPS everywhere, including between services where possible.
- Passwords: argon2id (preferred) or bcrypt with a sensible cost. Never MD5, SHA-1, plain SHA-256 or reversible encryption.
- Never invent cryptography. Use the platform's vetted libraries.
- Tokens and IDs that must be unguessable come from a cryptographically secure random generator.
- Encrypt sensitive fields at rest; keep keys out of the database and the repo.
- Compare secrets and signatures with a constant-time function.

## A05 Injection

- SQL/NoSQL: parameterized queries or the ORM's safe API. Never build a query by string concatenation, including for sort and filter fields (allowlist those).
- XSS: rely on the framework's automatic escaping. Avoid `dangerouslySetInnerHTML`/`v-html`/`innerHTML`; if rich HTML is required, sanitize with a maintained library.
- Commands: no `eval`, no shell built from input. Pass arguments as arrays.
- Paths: never join user input into a filesystem path without normalizing and confirming it stays inside the allowed directory.
- Validate every input on the server with a schema (type, length, range, format) and reject what does not match.

## A06 Insecure Design

- Before building, name what must never happen (another user reads my data, someone buys at a price they chose, an attacker runs up my bill) and design the control for each.
- Business rules live on the server: prices, quotas, eligibility, state transitions.
- Limit quantities, sizes and frequencies for every action a user can repeat.

## A07 Authentication Failures

- Use a proven provider or the framework's auth library.
- Session cookies: `HttpOnly`, `Secure`, `SameSite=Lax` or `Strict`. Do not store session tokens in `localStorage`.
- Rate-limit and add lockout or backoff on login, sign-up, password reset and code verification.
- Password reset and email verification tokens: random, single-use, short-lived.
- Identical responses for "wrong password" and "no such user".
- Offer multi-factor authentication for admin accounts at minimum.
- JWTs: verify signature and algorithm, set short expiry, never put secrets in the payload.

## A08 Software or Data Integrity Failures

- Verify signatures on every incoming webhook before acting on it.
- Do not deserialize untrusted data into objects that can execute code.
- CI/CD secrets scoped to what the pipeline needs; protected main branch.

## A09 Security Logging and Alerting Failures

- Log sign-ins, failed sign-ins, permission denials, admin actions and payment events, with user ID and timestamp.
- Never log passwords, tokens, full card numbers or secrets.
- Send errors to a tracker and set an alert for spikes; a log nobody reads protects nothing.

## A10 Mishandling of Exceptional Conditions

- Fail closed: if a permission check errors, deny.
- Catch errors at boundaries, log the detail on the server, return a generic message to the client.
- No empty `catch` blocks, no swallowed promise rejections.
- Timeouts and bounded retries with backoff on external calls; handle the partial-failure case in multi-step operations with transactions or compensation.
- Validate file sizes, list lengths and numeric ranges so unusual input cannot exhaust memory or money.

## LLM features

- The model's API key stays on the server. The client calls your endpoint, which calls the model.
- Per-user rate limits and a provider-side spending cap.
- Treat model output as untrusted input: never execute it, render it as raw HTML, or use it in a query without validation.
- Content fetched or uploaded (web pages, documents, emails) can carry instructions. Do not give a model that reads untrusted content the ability to take privileged actions without a confirmation step.
- Do not put secrets or other users' data in prompts. Assume the system prompt can be extracted.

## A secret leaked: what to do

1. Revoke or rotate the key at the provider immediately. This is the only real fix.
2. Replace it in the deployment's environment settings.
3. Check the provider's usage logs for activity you did not cause.
4. Remove it from the code and add the file to `.gitignore`. History rewriting is optional cleanup, not a remedy; assume the old value is known.
5. Add a secret scanner (for example gitleaks) as a pre-commit hook or CI step.
