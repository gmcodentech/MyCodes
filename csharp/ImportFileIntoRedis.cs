using System;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.IO;
using StackExchange.Redis;
namespace ImportDemo{
    public class Demo{
        public static void Main(){
            new Importer().Import<Movie>(@"C:\Software\Dotnet\Data\short.tsv","\t",100);
            Console.WriteLine("Completed");
        }
    }

    public class DataStore{
        private readonly ConnectionMultiplexer _redis;
        private readonly IDatabase _db;
        public DataStore(){
            _redis = ConnectionMultiplexer.Connect("127.0.0.1:6379");
            _db = _redis.GetDatabase();
        }

        public void InsertData<T>(List<T> records){
            foreach(var record in records){
                Movie movie = record as Movie;
                var key = $"movie:{movie.Tconst}";
                _db.HashSet("moviedb",new HashEntry[]{
                    new HashEntry(key,JsonSerializer.Serialize(movie))
                });

                _db.SetAdd($"title:{movie.PrimaryTitle}",movie.Tconst);
            }
        }
    }

    public class Importer{
        public bool Import<T>(string file,string separator,int batchSize){
            bool imported = false;
            bool detectEncoding = false; //detect from byte order marks
            int bufSize = 1024;
            string headerLine = "";
            int lineCounter = 0;
            List<string> lines = new List<string>();
            List<T> records = null;
            DataStore db = new DataStore();
            using(Stream stream = new FileStream(file,FileMode.Open)){
                using(StreamReader streamReader = new StreamReader(stream,Encoding.UTF8,detectEncoding,bufSize)){
                    string line = "";
                    while((line = streamReader.ReadLine())!=null){
                        lineCounter += 1;
                        if(headerLine.Length==0){
                            headerLine = line;
                            continue;
                        }
                        lines.Add(line);
                        if(lineCounter % batchSize == 0){
                            records = CreateObjects<T>(headerLine,lines,separator);
                            db.InsertData<T>(records);
                            records.Clear();
                            lines.Clear();
                            continue;
                        }
                    }
                }
            }
            return imported;
        }

        public List<T> CreateObjects<T>(string headerLine,List<string> dataLines,string separator){
            List<T> list = new List<T>();
            var columnInfo = headerLine.Split(separator).Select((v,i)=>new {
                ColIndex = i,
                ColName = v
            });
            Type type = typeof(T);
            dataLines.ForEach(line=>{
                var values = line.Split(separator);
                T obj = (T)Activator.CreateInstance(type);
                foreach(var prop in type.GetProperties()){
                    var column = columnInfo.SingleOrDefault(c=> prop.Name == c.ColName);
                    if(column!=null){
                        var value = values[column.ColIndex];
                        var propType = prop.PropertyType;
                        prop.SetValue(obj,Convert.ChangeType(value,propType));
                    }
                    list.Add(obj);
                }
            });
            return list;
        }
    }

    public class Movie{
        public string Tconst{get;set;}
        public string TitleType{get;set;}
        public string PrimaryTitle{get;set;}
        public string OriginalTitle{get;set;}
        public int IsAdult{get;set;}
        public int StartYear{get;set;}
        public int EndYear{get;set;}
        public int RuntimeMinutes{get;set;}
        public string Genres{get;set;}
    }
}