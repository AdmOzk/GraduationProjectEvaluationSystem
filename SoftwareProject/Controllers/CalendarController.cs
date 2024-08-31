using Google.Cloud.Firestore;
using Google.Cloud.Firestore.V1;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace GraduationProject.Controllers
{
    public class CalendarController : Controller
    {
     

     

        public class MyProfessor
        {
            public string Department { get; set; }
            public string Email { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
        }

        public class CalendarViewModel
        {
            public IList<MyBookedDates> BookedDates { get; set; }
            public IList<MyProjects> Projects { get; set; }
            public IList<MyProfessor> Professors { get; set; }
        }


        public class MyBookedDates
        {
            public int ProfessorId { get; set; }
            public int ProjectId { get; set; }
            public DateTime BookedDate { get; set; }

            public string professoremail { get; set; }
        }


        public async Task<IList<MyBookedDates>> GetBookedDates(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"";

            FirestoreDb db = FirestoreDb.Create(projectId: "", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            CollectionReference collection = db.Collection("evaluation-project")
                                               .Document("BookedDates")
                                               .Collection("DatesThatBooked");

            QuerySnapshot snapshot = await collection.GetSnapshotAsync(token);

            IList<MyBookedDates> bookedDates = new List<MyBookedDates>();

            if (snapshot.Count == 0)
            {
                Console.WriteLine("No documents found in the DatesThatBooked collection.");
            }

            foreach (DocumentSnapshot document in snapshot.Documents)
            {
                if (document.Exists)
                {
                    bookedDates.Add(
                        new MyBookedDates()
                        {
                            ProfessorId = document.GetValue<int>("ProfessorId"),
                            ProjectId = document.GetValue<int>("ProjectId"),
                            BookedDate = document.GetValue<DateTime>("BookedDate"),
                            professoremail = document.GetValue<string>("professoremail")
                        }
                    );

                    Console.WriteLine($"BOOKED DATES: Professor ID: {document.GetValue<int>("ProfessorId")}, professoremail :{document.GetValue<string>("professoremail")} ,Project ID: {document.GetValue<int>("ProjectId")}, Booked Date: {document.GetValue<DateTime>("BookedDate")}");
                }
                else
                {
                    Console.WriteLine($"Document {document.Id} does not exist.");
                }
            }

            return bookedDates;
        }




           public class MyProjects
        {
            public string Description { get; set; }
            public string Title { get; set; }
            public string FileUrl { get; set; }
            public string User { get; set; }

            public string ProfessorEmail { get; set; }
        }


        public async Task<IList<MyProjects>> GetProjects(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"";

            FirestoreDb db = FirestoreDb.Create(projectId: "", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            CollectionReference collection = db.Collection("evaluation-project")
                                               .Document("Project")
                                               .Collection("Projects");


            QuerySnapshot snapshot = await collection.GetSnapshotAsync(token);

            IList<MyProjects> projects = new List<MyProjects>();


            foreach (DocumentSnapshot document in snapshot.Documents)
            {
                if (document.Exists)
                {
                    projects.Add(
                        new MyProjects()
                        {
                            Description = document.GetValue<string>("Description"),
                            Title = document.GetValue<string>("Title"),
                            FileUrl = document.GetValue<string>("FileUrl"),
                            User = document.GetValue<string>("User"),
                            ProfessorEmail = document.GetValue<string>("ProfessorEmail")

                        }
                    );

                    Console.WriteLine($"Project: {document.GetValue<string>("Title")}, ProfessorEmail : {document.GetValue<string>("ProfessorEmail")} ,  Description: {document.GetValue<string>("Description")}, User: {document.GetValue<string>("User")}, File URL: {document.GetValue<string>("FileUrl")}");
                }
                else
                {
                    Console.WriteLine($"Document {document.Id} does not exist.");
                }
            }

            return projects;
        }

        public async Task<IList<MyProfessor>> GetProfessors(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"";

            FirestoreDb db = FirestoreDb.Create(projectId: "", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            CollectionReference collection = db.Collection("evaluation-project")
                                               .Document("Professor")
                                               .Collection("Academician");

            QuerySnapshot snapshot = await collection.GetSnapshotAsync(token);

            IList<MyProfessor> professors = new List<MyProfessor>();

            if (snapshot.Count == 0)
            {
                Console.WriteLine("No documents found in the Academician collection.");
            }

            foreach (DocumentSnapshot document in snapshot.Documents)
            {
                if (document.Exists)
                {
                    professors.Add(
                        new MyProfessor()
                        {
                            Email = document.GetValue<string>("email"),
                            FirstName = document.GetValue<string>("Name"),
                            LastName = document.GetValue<string>("LastName"),

                        }
                    );

                    Console.WriteLine($"Professor: {document.GetValue<string>("Name")} {document.GetValue<string>("LastName")}, Email: {document.GetValue<string>("email")}");
                }
                else
                {
                    Console.WriteLine($"Document {document.Id} does not exist.");
                }
            }

            return professors;
        }

        public async Task<IActionResult> Test(CancellationToken cancellationToken)
        {
            Console.WriteLine("Fetching Projects...");
            await GetProjects(cancellationToken);

            Console.WriteLine("Fetching Booked Dates...");
            await GetBookedDates(cancellationToken);

            

            Console.WriteLine("Fetching Professors...");
            await GetProfessors(cancellationToken);

            return Ok("Test Completed");
        }

        public async Task<IActionResult> Index(CancellationToken cancellationToken)
        {
            await Test(cancellationToken);

            IList<MyProjects> projects = await GetProjects(cancellationToken);

            IList<MyBookedDates> bookedDates = await GetBookedDates(cancellationToken);
            
            IList<MyProfessor> professors = await GetProfessors(cancellationToken);

            var viewModel = new CalendarViewModel
            {
                BookedDates = bookedDates,
                Projects = projects,
                Professors = professors
            };

            var viewModelList = new List<CalendarViewModel> { viewModel };

            return View(viewModelList);
        }
    }
}
