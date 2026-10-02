# Compliance

Read when the app handles personal data, cookies or tracking, payments, marketing email, minors, or health or financial data, or must meet accessibility law.

This is engineering guidance, not legal advice. When an app is tier 3, or the user asks whether they comply, say plainly that a lawyer or the regulator's own guidance must confirm it. Rules apply by where the users are, not where the developer is.

## Contents
- Personal data: the common core
- Regional privacy laws
- Cookies and tracking
- Payments (PCI DSS)
- Accessibility
- Email and messaging
- Children
- Health and financial data
- AI features
- Licenses and content
- What the user must do outside the code

## Personal data: the common core

These principles are shared by nearly every modern privacy law. Building to them covers most of the distance everywhere.

- **Minimize.** Collect only what a feature needs. Do not add fields "just in case".
- **Purpose.** Use data only for what the person was told.
- **Lawful basis and consent.** Where consent is the basis, it is opt-in, specific, and as easy to withdraw as to give. No pre-ticked boxes.
- **Transparency.** A privacy policy that says what is collected, why, who receives it (list the third-party services), how long it is kept, and how to exercise rights.
- **Rights.** Build the mechanics: export my data, correct it, delete my account and data.
- **Security.** Encryption in transit, access control, least privilege, and the measures in `security.md`.
- **Retention.** Delete or anonymize data that is no longer needed.
- **Processors.** Every third-party service that receives personal data (hosting, analytics, email, AI APIs) is a processor: check its terms and whether a data processing agreement is needed.
- **Breach readiness.** Know what data is held and where, so a breach can be assessed and reported within the legal deadline.

## Regional privacy laws

| Law | Applies to | Points that change what you build |
| --- | --- | --- |
| GDPR (EU), UK GDPR | Anyone offering goods or services to, or monitoring, people in the EU/UK | Lawful basis for each use; data-subject rights; breach notification to the regulator within 72 hours; safeguards for transfers outside the region; fines up to 4% of global annual turnover |
| CCPA/CPRA (California) and similar US state laws | Businesses over size or data-volume thresholds | Notice at collection; right to know, delete, correct; "Do Not Sell or Share" opt-out; honor Global Privacy Control signals |
| LGPD (Brazil) | Processing of data of people in Brazil | Close to GDPR: legal bases, rights, a designated data protection contact |
| Ley 21.719 (Chile) | Any organization processing personal data of people in Chile, with no size exemption | In force from 1 December 2026; GDPR-aligned; access, rectification, deletion, objection, portability and blocking rights; a data protection agency with fining powers |

If the user's audience is unknown, build to the common core above and tell them once that the applicable law depends on where their users are.

## Cookies and tracking

- Strictly necessary cookies (session, cart, security) need no consent.
- In the EU/UK, analytics, advertising and other non-essential cookies or trackers must not load before the visitor opts in. Rejecting must be as easy as accepting.
- Do not add analytics, pixels or third-party embeds the user did not request. If they ask for analytics, prefer a privacy-friendly, cookieless option and mention the consent requirement.
- A banner that only says "we use cookies" while trackers already run does not comply.

## Payments (PCI DSS)

- Card data must never reach the app's server, database, logs or frontend state. Use the provider's hosted checkout page or hosted fields (iframe). This keeps the merchant in the lightest PCI DSS scope (SAQ A).
- Even with hosted checkout, the merchant must keep the page that embeds or redirects to the payment form free of scripts that could tamper with it. Keep third-party scripts off checkout pages.
- Amounts, currency and discounts are computed on the server. Fulfil orders from verified webhooks, not from a client redirect.
- Verify webhook signatures; make handlers idempotent; store the provider's IDs, never card numbers or CVV.
- Show prices, taxes, renewal terms and refund policy before payment. Subscriptions need a clear way to cancel.

## Accessibility

- Target WCAG 2.1 level AA (2.2 where practical). It is the technical benchmark behind the European Accessibility Act (in application since 28 June 2025 for e-commerce and other consumer services offered in the EU, through EN 301 549), and the reference courts and regulators use in the US (ADA), UK and elsewhere.
- Minimum to build in: semantic HTML and landmarks; one `h1` and ordered headings; a label for every input; alt text for meaningful images; full keyboard operation with visible focus; text contrast of at least 4.5:1; no information conveyed by color alone; errors announced in text; `lang` attribute; respect `prefers-reduced-motion`; content usable at 200% zoom.
- Accessibility overlays and widgets do not make a site compliant.

## Email and messaging

- Marketing email needs prior opt-in in the EU/UK and many other places; in the US (CAN-SPAM) it needs honest headers, a physical address, and a working unsubscribe honored promptly.
- Every marketing message includes one-step unsubscribe. Transactional messages (receipts, password resets) are exempt from consent but must not carry marketing.
- Set up SPF, DKIM and DMARC on the sending domain.
- Sign-up forms need protection against automated abuse (rate limit, confirmation email, or a challenge).

## Children

- If the product is directed at children, or knowingly collects data from them, special rules apply: in the US, COPPA requires verifiable parental consent for under 13; under GDPR the age of digital consent is 13 to 16 depending on the country.
- If the product is not for children, say so in the terms and do not collect age-revealing data that is not needed.

## Health and financial data

- Health, biometric, genetic, sexual orientation, religion, political opinion and similar categories are "sensitive" or "special category" data almost everywhere: explicit consent, stronger security, and often an impact assessment.
- In the US, health data handled for healthcare providers or insurers falls under HIPAA and needs compliant vendors and signed agreements. Standard tiers of most hosting and AI services are not covered.
- Financial services, lending and anything touching bank data are regulated activities. Flag this to the user before building.

## AI features

- Tell users when they are interacting with an AI and when content is AI-generated where that matters.
- Check the AI provider's data terms before sending personal data, and say so in the privacy policy.
- Decisions with significant effects on a person (credit, hiring, eligibility) need human review and are restricted under GDPR and the EU AI Act.

## Licenses and content

- Check the license of every dependency, font, icon set and image. Copyleft licenses (GPL, AGPL) impose obligations on distribution or network use.
- Do not copy another site's text, images or brand. Use licensed or original assets.
- Put a license on the user's own code if it is public; without one, nobody may legally reuse it.

## What the user must do outside the code

Raise these once, in a heads-up, when they apply:

- Publish a privacy policy and terms that match what the app really does.
- Sign data processing agreements with providers where required.
- Register or notify with a regulator where the law demands it.
- Get legal review before handling payments at scale, health data, financial services or children's data.
