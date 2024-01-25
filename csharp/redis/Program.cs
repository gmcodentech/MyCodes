using NewRedisAPI.Data;
using StackExchange.Redis;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var cn = builder.Configuration.GetConnectionString("ProductDBConnection");
if (cn != null)
{
    builder.Services.AddSingleton<IConnectionMultiplexer>(_ => ConnectionMultiplexer
        .Connect(cn));
}
string? typeName = builder.Configuration.GetValue<string>("DataStoreType");
if(typeName!=null)
{
    Type? dataStoreType = Type.GetType(typeName);
    if(dataStoreType!=null)
    {
    builder.Services.AddScoped(typeof(IProductData),dataStoreType);
    }
}

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
