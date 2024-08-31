using Firebase.Database;
using Google.Api;
using Google.Apis.Auth.OAuth2;
using Google.Cloud.Firestore;
using Google.Cloud.Firestore.V1;
using Google.Cloud.Storage.V1;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddSession();

builder.Services.AddSingleton(provider =>
{
    var projectId = "0"; // Firebase project id
    var credential = GoogleCredential.FromFile("0");
    return FirestoreDb.Create(projectId, new FirestoreClientBuilder { Credential = credential }.Build());
});

// StorageClient configuration
builder.Services.AddSingleton(provider =>
{
    var credential = GoogleCredential.FromFile("0");
    return StorageClient.Create(credential);
});

// Configuration for Firebase Storage bucket
builder.Services.Configure<FirebaseOptions>(builder.Configuration.GetSection("Firebase"));

var app = builder.Build();

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseSession();
app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Login}/{action=Login}/{id?}");

app.Run();
