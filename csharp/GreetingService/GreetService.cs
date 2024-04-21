namespace GreetingService;
public sealed class GreetService{
    public void Greet(){
        string file = @"C:\Software\Dotnet\GreetingService\Messages\greetmessages.txt";
        if(!System.IO.File.Exists(file)){
            System.IO.File.Create(file);
        }

        DateTime now = DateTime.Now;
        if(now.Hour < 12){
            System.IO.File.AppendAllText(file,$"Good Morning at {now.ToString("dd MMM yyyy hh:mm:ss")}\n");
        } else if(now.Hour < 16){
            System.IO.File.AppendAllText(file,$"Good Afternoon at {now.ToString("dd MMM yyyy hh:mm:ss")}\n");
        } else{
            System.IO.File.AppendAllText(file,$"Good Evening at {now.ToString("dd MMM yyyy hh:mm:ss")}\n");
        }

    }
}