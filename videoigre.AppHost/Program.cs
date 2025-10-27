var builder = DistributedApplication.CreateBuilder(args);

var apiService = builder.AddProject<Projects.videoigre_ApiService>("apiservice");

builder.AddProject<Projects.videoigre_Web>("webfrontend")
    .WithExternalHttpEndpoints()
    .WithReference(apiService)
    .WaitFor(apiService);

builder.Build().Run();
