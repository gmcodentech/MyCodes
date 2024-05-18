//How to handle large files in C#
//Example: Convert TSV data to CSV
void Main()
{
	Console.WriteLine("start...");
	string tsvFilePath = @"C:\Software\Dotnet\Data\imdb.tsv";
	string csvFilePath = @"C:\Software\Dotnet\Data\imdb.csv";
	ConvertTSVToCSV(tsvFilePath,csvFilePath);
	Console.WriteLine("completed");
}

//thanks for watching this video...

private void ConvertTSVToCSV(string sourceFile,string targetFile){
	bool detectEncodingFromByteOrderMarks = false;
	int bufSize = 1024;
	using(StreamReader streamReader = new StreamReader(sourceFile,Encoding.UTF8,detectEncodingFromByteOrderMarks,bufSize)){
		string line = "";
		int lineCounter = 0;
		int batchSize=100;
		List<string> lines = new List<string>();
		while((line = streamReader.ReadLine())!=null){
			if(lineCounter == batchSize){
				WriteCSVLines(targetFile,lines);
				lineCounter = 0;
				lines.Clear();
				continue;
			}	
			
			lines.Add(line.Replace('\t',','));
			lineCounter += 1;
		}
		//if there is any data lines less than the batchsize
		if(lines.Count()>0){
			WriteCSVLines(targetFile,lines);
		}
	}
}

private void WriteCSVLines(string file,List<string> lines){
	File.AppendAllLines(file,lines,Encoding.UTF8);
}

// You can define other methods, fields, classes and namespaces here
