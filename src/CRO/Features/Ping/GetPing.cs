namespace CRO.Features.Ping;

// Vertical slice: endpoint mapping, handler, and response all live here.
public static class GetPing
{
    public sealed record Response(string Status, DateTimeOffset Timestamp);

    public static void Map(IEndpointRouteBuilder app) =>
        app.MapGet("/api/ping", Handle);

    private static Response Handle() => new("ok", DateTimeOffset.UtcNow);
}
