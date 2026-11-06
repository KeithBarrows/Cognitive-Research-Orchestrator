using CRO.Features.Ping;

var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

GetPing.Map(app);

app.Run();
