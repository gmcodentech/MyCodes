using GreetingService;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddWindowsService();
builder.Services.AddHostedService<Worker>();
builder.Services.AddSingleton<GreetService>();

var host = builder.Build();
host.Run();
