#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
#FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["outdatedpackages-core.csproj", "."]
RUN dotnet restore "./outdatedpackages-core.csproj"
COPY . .

RUN dotnet tool install nukeeper --global

ENV PATH="${PATH}:/root/.dotnet/tools"
ENTRYPOINT ["nukeeper"]
RUN nukeeper inspect --exclude "Microsoft" > "j.txt" |  pwsh -Command Get-Content "j.txt" | pwsh -Command ForEach-Object {$_ -split ',' }
#RUN pwsh -Command Get-Content "j.txt" | pwsh -Command ForEach-Object {$_ -split "," }
#RUN dotnet restore "./outdatedpackages-core.csproj"



#FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443
#
#FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
#WORKDIR /src
#COPY ["outdatedpackages-core.csproj", "."]
#RUN dotnet restore "./outdatedpackages-core.csproj"
#COPY . .
#WORKDIR "/src/."
#RUN dotnet build "outdatedpackages-core.csproj" -c Release -o /app/build
#
#FROM build AS publish
#RUN dotnet publish "outdatedpackages-core.csproj" -c Release -o /app/publish
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "outdatedpackages-core.dll"]