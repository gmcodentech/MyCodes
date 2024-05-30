//Calculate SHA-256 digest of a file in C#
using System;
using System.Security.Cryptography;
public class Sample{
	public static void Main(){
		string fileContent = System.IO.File.ReadAllText(@"C:\Software\one.txt");
		Console.WriteLine(GetHash(fileContent));
	}
	//Thanks for watching this video...
	private static string GetHash(string input){
		byte[] inputBytes = Encoding.UTF8.GetBytes(input);
		var hashData = SHA256.HashData(inputBytes);
		return Convert.ToHexString(hashData);
	}
}