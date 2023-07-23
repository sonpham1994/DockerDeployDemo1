FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["DockerDeployDemo1.csproj", "./"]
RUN dotnet restore "DockerDeployDemo1.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "DockerDeployDemo1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerDeployDemo1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerDeployDemo1.dll"]
