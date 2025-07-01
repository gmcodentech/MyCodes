FROM mcr.microsoft.com/dotnet/aspnet:8.0
RUN mkdir app
WORKDIR /app
COPY ./publish ./
ENTRYPOINT ["dotnet","LinuxTestAPI.dll"]