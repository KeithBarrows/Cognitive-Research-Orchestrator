# Developer's Before-You-Code Guide

Cognitive Research Orchestrator (CRO)

Date: 2026-11-05

## Purpose and status

Read this before adding a feature or extending the endpoint template.
This guide captures the implementation direction agreed in the
2026-11-05 developer discussion. It describes the intended design,
not functionality already implemented.

Start with [current state](../CURRENT.md), the
[context map](../CONTEXT-MAP.md), and the
[developer architecture overview](developer-architecture-overview.md).
Use the approved Epic and Feature documents to determine what may be
built now. This guide does not approve later-phase functionality.

The roadmap previously left mediator packages open per slice. The
starting template described here needs no mediator package. Revisit
that choice only when an actual need justifies it. Specific identity
providers, token issuance, module boundaries, and event-sourced
workflows still need implementation decisions.

## 1. Architecture: modular monolith, vertical slices

Build one deployable application first. Keep capability boundaries
clear enough that a module can later become a service without moving
business logic out of its HTTP endpoints.

- Use C#/.NET, ASP.NET Core, Kestrel, and minimal APIs.
- Name the application project and root namespace `CRO`, not `CRO.Api`.
- Keep the solution at `src/CRO.slnx` and project at
  `src/CRO/CRO.csproj`.
- Group code by capability, then by use case, not into global folders
  of every command, every handler, and every repository.
- Give modules explicit contracts and ownership of their state.
- Do not let modules read another module's tables or depend on its
  implementation types.
- Start with one project. Add project boundaries when they provide
  useful enforcement, not merely to imitate a larger architecture.

Service extraction is a design option, not a promise of zero effort.
A remote boundary introduces latency, authentication, serialization,
partial failures, and eventual consistency. Do not rely on shared
transactions or mutable domain objects across module boundaries.

## 2. Two transports, one application use case

REST endpoints and MCP tools are adapters into the same application
handlers:

    REST endpoint --+
                    +--> Use-case handler --> Backend interfaces
    MCP tool -------+                              |
                                   APIs / databases / file system

- REST binds HTTP inputs and translates outcomes into HTTP responses.
- MCP binds tool arguments and translates outcomes into MCP results.
- Handlers implement use cases and coordinate dependencies.
- Domain types enforce business rules where a domain model is useful.
- Infrastructure adapters perform backend-specific I/O.

Do not make MCP call CRO's own REST endpoints internally. Do not put
HTTP status codes, `IResult`, `HttpContext`, or MCP SDK types into
application handlers. Both transports must preserve the same business
validation, authorization, and side-effect rules.

## 3. File organization

Use one route-registration file per resource or feature group, and
one handler file per use case. Do not create a single file containing
every route in the application.

Illustrative target structure; not all of these files exist yet:

    src/
      CRO.slnx
      CRO/
        CRO.csproj
        Program.cs
        Features/
          Captures/
            CaptureEndpoints.cs
            CaptureTools.cs
            CreateCapture/
              CreateCaptureRequest.cs
              CreateCaptureCommand.cs
              CreateCaptureHandler.cs
              CreateCaptureResult.cs
            GetCapture/
              GetCaptureQuery.cs
              GetCaptureHandler.cs
              GetCaptureResult.cs
        Infrastructure/
          TheBrain/
          OB1/
          Plane/
          Persistence/
          Files/
        Middleware/

Use a module folder above these feature groups when the module
boundaries become concrete. Keep contracts near the application code
that owns them; place implementations in infrastructure.

Small related records may share a file. Avoid mandatory file-per-type
ceremony and a catch-all shared service layer. The current combined
ping slice is a small health-check example, not the required template
for substantive features.

## 4. Endpoint discovery and dependency injection

Automatically discover and register endpoint definitions through DI.
ASP.NET Core supplies DI and routing, but does not automatically
discover our custom endpoint classes without registration code or an
appropriate library.

Use a small endpoint-registration contract, for example:

    public interface IEndpoint
    {
        void MapEndpoint(IEndpointRouteBuilder routes);
    }

Startup registration should discover concrete implementations only
from explicitly selected application/module assemblies, register them,
and invoke their mapping methods once. Fail startup on registration
or routing errors rather than silently skipping endpoints.

Keep the composition root short. Conceptually it registers modules,
endpoints, authentication, and authorization, then maps REST and MCP.
The exact extension methods are part of the template implementation,
not existing framework methods.

Endpoint-registration classes can be stateless. If resolved from the
root provider at startup, they must not capture scoped handlers,
database contexts, or request/user state. Inject scoped handlers into
the route delegate so they are resolved for each request.

Static classes are suitable for mapping helpers. Application handlers
are normally non-static, constructor-injected classes. DI discovery
should target concrete types implementing the registration contract.

## 5. CQRS without a mandatory mediator

Separate commands that change state from queries that read it. Give
each use case an explicit input and result.

- Inject a typed handler directly into each transport adapter.
- Use constructor injection for the handler's dependencies.
- Define interfaces for backend/service boundaries that need swapping
  or isolation in tests; do not require a generic mediator abstraction.
- Forward cancellation tokens through asynchronous calls.
- Put shared business validation and permission checks where every
  caller, including MCP, must pass them.

CQRS does not require MediatR, separate databases, a message bus, or
separate deployments. Do not build a home-grown mediator merely to
replace a package. Review current license terms before adopting any
package; this template does not depend on MediatR.

## 6. REST behavior

Design resource-oriented HTTP contracts independently of internal
command names. A command handler does not require a verb-shaped URL.

| Intent | Example | Typical success |
| --- | --- | --- |
| Create | POST /api/captures | 201 with Location |
| Retrieve | GET /api/captures/{id} | 200; 404 if absent |
| List/search | GET /api/captures?... | 200, even if empty |
| Full replacement | PUT /api/resources/{id} | 200 or 204 |
| Partial update | PATCH /api/resources/{id} | 200 or 204 |
| Delete | DELETE /api/resources/{id} | Commonly 204 |
| Start long work | POST /api/bootstrap-runs | 202 with status location |

PUT may return 201 when creation at the requested URI is supported.
PATCH semantics and idempotency depend on the chosen patch contract.
For DELETE, choose and document how an already-absent resource is
reported; idempotency concerns the resulting state, not identical
status codes.

- Keep GET safe: no business writes triggered by a read.
- Use typed minimal-API results and dedicated immutable DTOs.
- Provide OpenAPI descriptions and stable operation names.
- Return consistent Problem Details errors without internal details.
- Return 401 for missing/invalid authentication and 403 for denied
  permissions; do not redirect API/MCP calls to a browser login page.
- Define pagination, filters, concurrency, and conflict responses as
  each resource needs them.
- Use DateTimeOffset for timestamps and propagate cancellation.
- Add retry/idempotency protection where repeating a command could
  duplicate external writes.

## 7. Authentication, admission, and authorization

Use external identity providers such as Google for sign-in. CRO still
makes the final admission and permission decisions. Successful
provider authentication alone must never grant application access.

Distinguish these responsibilities:

- OIDC authenticates a user.
- OAuth access tokens authorize a client to access a resource server.
- CRO maps an approved identity to a local application user and checks
  that user's roles, permissions, and resource access.

### Approved users

The requirement is a hard application allowlist, not open access to
every account at a trusted provider. A username or verified email can
support enrollment and display, but use validated issuer plus subject
(`iss` + `sub`) as the external identity key.

Map approved external identities to local users. Explicitly approve
account linking across providers; do not link solely because email
addresses match. Deny unknown identities and disabled local users.
Do not accept a username or role supplied in a request body as proof.

### Pipeline and endpoint policies

Run authentication before authorization in the HTTP middleware
pipeline. Require authentication by default, then attach named
permission policies to each endpoint or protected endpoint group.
Allow anonymous access only for an explicitly reviewed exception.

For example, creating a capture requires a permission such as
`Captures.Write`. Derive permissions from CRO-controlled assignments,
not arbitrary external claims. Check resource-specific permissions
inside the shared application path as well.

Apply equivalent admission and authorization to MCP tools. MCP tool
execution must not bypass checks enforced on REST. Background jobs
need an explicit service identity and permission policy, not an
implicit authentication bypass.

### Browser, API, and MCP flows

A browser may use OIDC authorization-code sign-in with a secure
session cookie. Protect cookie-authenticated writes against CSRF.
API and HTTP MCP clients need a supported access-token flow with
tokens intended for CRO. A Google ID token is not automatically a CRO
API access token.

Validate issuer, audience, signature, and lifetime for the selected
token scheme. Select the API/MCP authorization server and client flows
before implementation; use authorization code with PKCE where
appropriate. Do not create an improvised token issuer.

External sign-in does not authorize sending Brain content to an
identity provider or exposing CRO publicly. Keep credentials and
signing material out of source control and application logs.

## 8. Backend and file-system boundaries

Expect several backends with different capabilities: TheBrain, OB1,
Plane, CRO-owned PostgreSQL storage, and approved file operations.
Use backend-specific adapters rather than forcing everything through
one generic repository interface.

- Keep external API details and persistence models out of handlers'
  transport contracts.
- Preserve canonical ownership: TheBrain owns durable knowledge,
  OB1 owns semantic thought history, and Plane owns tasks.
- CRO owns bounded operational state and a rebuildable retrieval
  index, not another authoritative knowledge store.
- Keep CRO-owned databases separate from OB1/Plane-owned databases.
- CRO is the client-facing MCP surface; use the approved REST/API
  connections to backends, not another MCP hop.
- Restrict file operations to approved roots, validate resolved paths,
  and account for traversal and links that escape those roots.
- File-system support does not grant CRO access to repositories.
  Repository reads/writes remain out of scope.
- Attachments must follow TheBrain's supported attachment workflow;
  copying bytes into an arbitrary folder is not equivalent.

Set explicit timeouts and retry rules per adapter. Surface backend
failures and partial completion; never turn them into success-shaped
fallbacks. Retry writes only with an idempotency/reconciliation plan.

## 9. Event sourcing is selective, not the template default

CQRS, domain events, audit history, and event sourcing are distinct.
Event sourcing makes an event stream authoritative for reconstructing
state. A disposable index rebuilt from canonical sources is not, by
itself, event sourcing.

Consider event sourcing only for a named CRO-owned workflow with a
clear benefit. Decide event ownership, versioning, optimistic
concurrency, replay behavior, projections, and retention before
adopting it. Do not copy all external knowledge into an authoritative
CRO event stream.

There is no single atomic transaction across APIs, databases, and
files. Model partial progress and recovery explicitly. Durable
workflow state, idempotency keys, an outbox where applicable, and
retryable steps may solve the actual problem without event sourcing.
An outbox can coordinate local commits with later dispatch; it cannot
make external systems part of the same transaction.

Replay must rebuild local state/projections without blindly repeating
external side effects. Keep event sourcing out of the base template
until a specific workflow justifies it.

## 10. Before coding a slice

- [ ] Confirm the approved Epic/Feature and its acceptance criteria.
- [ ] Identify the owning module and canonical data owners.
- [ ] Define command/query input, result, and shared handler.
- [ ] Decide which REST and MCP surfaces are needed.
- [ ] Define REST semantics, validation, and error mapping.
- [ ] Define allowed identities, permissions, and resource checks.
- [ ] Verify backend capabilities rather than assuming them.
- [ ] Define timeouts, cancellation, idempotency, and recovery.
- [ ] Decide explicitly whether event sourcing adds value here.
- [ ] Keep secrets and sensitive content inside approved boundaries.

## 11. Verify before calling it done

- Endpoint discovery registers each intended route once.
- DI scope validation catches startup/scoped dependency mistakes.
- REST and MCP reach the same use case and enforce the same rules.
- Tests cover anonymous, unapproved, disabled, underprivileged, and
  authorized callers, plus invalid token issuer/audience/lifetime.
- HTTP tests assert status, headers, body, and OpenAPI contracts.
- Handler tests cover validation, permissions, and business behavior.
- Adapter tests cover failures, timeouts, and cancellation.
- Multi-backend commands recover without duplicating side effects.
- Event-sourced workflows, if any, replay without external writes.
- Build and focused tests pass, and the feature is exercised at runtime.

Documentation and a passing build are not proof that runtime auth,
endpoint discovery, or backend integration works. Report what was
actually verified and what remains unimplemented.
