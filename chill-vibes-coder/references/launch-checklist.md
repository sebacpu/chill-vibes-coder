# Launch checklist

Read before a deploy, when asked "is it ready?", or when reviewing an existing app. Go in order: earlier sections are the ones that cause real damage. Verify by looking at the code and configuration, not by assuming.

Report results as a short table (issue, risk in plain words, fix), most severe first. Do not list the items that passed.

## 1. Critical (fix before anyone else uses it)

- [ ] No secrets in the repo, in git history, or in anything sent to the browser. Search for key patterns and check the built client bundle.
- [ ] `.env` is in `.gitignore`; `.env.example` has no real values.
- [ ] Every API route and server action checks authentication and record ownership on the server.
- [ ] Database rules or row-level security enabled on every table and storage bucket; no allow-all policies; tested as anonymous and as another user.
- [ ] No user-editable field grants privileges (role, plan, credits, price).
- [ ] All queries parameterized; no raw HTML rendering of user content; no `eval` or shell built from input.
- [ ] Payments use hosted checkout or fields; amounts computed on the server; webhooks signature-verified.
- [ ] Debug mode off; no stack traces or internal errors returned to the client.
- [ ] No test accounts, default passwords or open admin routes.

## 2. Important (fix before launch to the public)

- [ ] HTTPS enforced; security headers set; CORS limited to known origins.
- [ ] Rate limits on login, sign-up, password reset and every endpoint that costs money.
- [ ] Spending caps and billing alerts at paid providers.
- [ ] Server-side validation on every input; upload type and size limits.
- [ ] Session cookies `HttpOnly`, `Secure`, `SameSite`; password reset tokens single-use and short-lived.
- [ ] Production database separate from development; automatic backups on and a restore tested.
- [ ] Migrations committed; no manual schema edits in production.
- [ ] Dependencies exist, are maintained, pass the ecosystem audit; lockfile committed.
- [ ] Error tracking and an uptime check in place.
- [ ] Loading, empty and error states on every screen; custom 404 and 500 pages.
- [ ] Tests pass for auth, payments and core logic.

## 3. Legal and trust (when there are real users)

- [ ] Privacy policy and terms published and accurate, listing third-party services.
- [ ] Only necessary personal data collected; account and data deletion works.
- [ ] No non-essential trackers before consent where the audience requires it.
- [ ] Marketing email has opt-in where required and one-step unsubscribe.
- [ ] Accessibility basics: keyboard operation, labels, alt text, contrast, focus visible.
- [ ] Prices, renewal and refund terms shown before payment; subscriptions can be cancelled.

## 4. Polish

- [ ] Works on a phone and on a slow connection; images sized and compressed.
- [ ] Page titles, meta description, favicon and social preview image.
- [ ] README explains how to run and deploy; someone else could take over.
- [ ] A rollback path for the release is known.
