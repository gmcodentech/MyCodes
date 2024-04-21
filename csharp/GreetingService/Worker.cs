namespace GreetingService;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly GreetService _greetService;
    public Worker(ILogger<Worker> logger,GreetService greetService)
    {
        _logger = logger;
        _greetService = greetService;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            _greetService.Greet();
            if (_logger.IsEnabled(LogLevel.Information))
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
            }
            await Task.Delay(1000, stoppingToken);
        }
    }
}
