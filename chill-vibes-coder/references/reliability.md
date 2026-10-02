# Reliability, performance and cost

Read for error handling, tests, logging, performance, running costs, deployment and backups.

## Contents
- Error handling and UI states
- Testing
- Version control
- Logging and monitoring
- Performance
- Running costs
- Deployment
- Backups and recovery
- Working efficiently (token cost)

## Error handling and UI states

- Every data-driven screen has four states: loading, empty, error, success. Build all four.
- Forms: disable the submit button while sending, show field-level messages, keep what the user typed after a failure, prevent double submission.
- Custom 404 and 500 pages. An error boundary (or equivalent) so one failing component does not blank the page.
- User-facing messages say what happened and what to do next, with no internals.
- Server: one central error handler, consistent error shape, correct status codes.
- External calls: timeout, limited retries with backoff, and a defined behavior when the dependency is down.

## Testing

Proportionate to the stakes. Do not aim for coverage numbers.

- Always test: authentication and permission checks (including "user A cannot read user B's record"), payment and money calculations, core business rules.
- Add a regression test when fixing a bug.
- One end-to-end happy path for the main flow is worth more than many trivial unit tests.
- A failing test means the code or the expectation is wrong. Find out which. Never delete, skip or loosen a test to get a green run.
- Run the linter, type checker and tests before saying a task is done, and report honestly if something still fails.

## Version control

- Commit before any large change so there is a point to return to. Small commits with messages that say what changed.
- `.gitignore` from the first commit: `.env*` (except `.env.example`), dependency folders, build output, local databases, OS and editor files.
- Do not commit generated files, uploads or credentials.
- Work on a branch for risky changes; keep the main branch deployable.

## Logging and monitoring

- Structured logs with level, timestamp and request or user ID. No secrets or personal data in logs.
- An error tracker in production and an uptime check on the main URL.
- A health endpoint that verifies the app can reach its database.

## Performance

Measure first; fix what is slow for real users.

- Database: indexes on filtered and joined columns; avoid N+1 queries (fetch related rows in one query); select only needed columns; paginate.
- Frontend: compress and size images, lazy-load below the fold, ship less JavaScript, avoid layout shift by reserving space for media.
- Cache what is expensive and rarely changes; set cache headers for static assets.
- Move slow work (emails, file processing, AI calls that can wait) to background jobs so requests return quickly.
- Debounce search-as-you-type and similar chatty inputs.

## Running costs

- Tell the user what a design will cost to run when it is not obviously free: per-request AI calls, database size, bandwidth, email/SMS volume.
- Set spending limits and billing alerts at every paid provider. A public endpoint that calls a paid API without a cap is an open wallet.
- Cache or reuse AI responses where the input repeats; choose the smallest model that does the job; cap output length.
- Serverless functions that call themselves or retry forever can produce a runaway bill. Bound every loop and retry.

## Deployment

- Deploy from the repository through the host's pipeline, not by copying files by hand.
- Configuration and secrets live in the host's environment settings, never in the repo.
- Run migrations as a deliberate step, and know how to roll back the previous release.
- After deploy: load the site, sign in, run the main flow once.
- Custom domain with HTTPS enforced and automatic certificate renewal.

## Backups and recovery

- Automatic database backups enabled before real users arrive, with at least one restore actually tested.
- User-uploaded files are backed up or stored on durable object storage.
- Destructive operations (drop, truncate, mass delete, reset) never run against production without the user's explicit confirmation and a fresh backup. Prefer soft delete for user data.

## Working efficiently (token cost)

- Read the relevant files before editing; do not regenerate a whole file to change a few lines.
- Make the smallest change that solves the request. Do not refactor unrelated code or add features nobody asked for.
- Reuse existing utilities and patterns in the project instead of adding parallel ones.
- When stuck on the same error twice, stop and reconsider the cause instead of retrying variations.
- Keep explanations short. The deliverable is working software, not commentary.
