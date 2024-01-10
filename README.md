## Creating a PFX

openssl pkcs12 -inkey container.key -in container.crt -export -out container.pfx

## Add to Program.cs

```
var httpsConnectionAdapterOptions = new HttpsConnectionAdapterOptions
{
    SslProtocols = System.Security.Authentication.SslProtocols.Tls12,
    ClientCertificateMode = ClientCertificateMode.AllowCertificate,
    ServerCertificate = new System.Security.Cryptography.X509Certificates.X509Certificate2("./container.pfx")
};

builder.WebHost.ConfigureKestrel(options => 
    options.ConfigureEndpointDefaults(listenOptions => 
        listenOptions.UseHttps(httpsConnectionAdapterOptions)));
```

## Database Stuff

- Local Connection String: Server=localhost;Database=AppDataContext;User Id=sa;Password=P@ssword;TrustServerCertificate=true
- In-Container Connection String: Server=mssql;Database=AppDataContext;User Id=sa;Password=P@ssword;TrustServerCertificate=true

- Don't forget to create a DataContext, classes for the tables

- Register your DbContext
```
builder.Services.AddDbContext<AppDataContext>(
    options => options.UseSqlServer(builder.Configuration.GetConnectionString("TestConnectionString"))
);
```

- Ensure Created!
```
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDataContext>();
    dbContext.Database.EnsureCreated();
}
```

