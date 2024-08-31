using System.Text.Json.Serialization;

namespace GraduationProject.Models
{
    public class FirebaseSettings
    {
        [JsonPropertyName("project_id")]
        public string ProjectId => "0";

        [JsonPropertyName("private_key_id")]
        public string PrivateKeyId => "0";

    }
}
