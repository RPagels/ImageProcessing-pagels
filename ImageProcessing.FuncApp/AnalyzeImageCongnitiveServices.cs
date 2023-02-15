using System;
using System.IO;
using System.Net.Http.Headers;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ImageProcessing.FuncApp
{
    public class AnalyzeImageCongnitiveServices
    {
        private readonly ILogger _logger;

        public AnalyzeImageCongnitiveServices(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<AnalyzeImageCongnitiveServices>();
        }

        [Function("AnalyzeImageCongnitiveServices")]
        public void Run([BlobTrigger("samples-workitems/{name}", Connection = "")] string myBlob, string name)
        {
            _logger.LogInformation($"C# Blob trigger function Processed blob\n Name: {name} \n Data: {myBlob}");
        }
    }
}

//#r "Newtonsoft.Json"

//using System;
//using System.Text;
//using System.Net.Http;
//using System.Net.Http.Headers;
//using Newtonsoft.Json;

//public static void Run(Stream myBlob, string name, ILogger log, string extension, Stream outputBlob)
//{
//    log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");

//    // CognitiveServicesVision-rpagels
//    //string _apiKey = "TBD";
//    //string _apiUrlBase = "https://cognitiveservicesvision-rpagels.cognitiveservices.azure.com/";

//    // Key for Cognitive Computer Vision Service
//    string _apiKey = "TBD";

//    // Cognitive Computer Vision Services to resize image
//    string _apiUrlBase = "https://centralus.api.cognitive.microsoft.com/vision/v3.2/";

//    // Request parameters.
//    // Faces,Color,Tags,ImageType,Objects
//    string requestParameters = "visualFeatures=Categories,Tags,Description";


//    using (var httpClient = new HttpClient())
//    {
//        httpClient.BaseAddress = new Uri(_apiUrlBase);
//        httpClient.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", _apiKey);
//        using (HttpContent content = new StreamContent(myBlob))
//        {
//            //get response
//            content.Headers.ContentType = new MediaTypeWithQualityHeaderValue("application/octet-stream");
//            var uri = $"{_apiUrlBase}analyze?{requestParameters}";
//            var response = httpClient.PostAsync(uri, content).Result;

//            response = httpClient.PostAsync(uri, content).Result;

//            // Get the JSON response.
//            string contentString = response.Content.ReadAsStringAsync().Result;

//            //write to Log
//            log.LogInformation($"\t{contentString}");

//            // Caption caption;
//            // caption = Newtonsoft.Json.JsonConvert.DeserializeObject<Caption>(contentString);

//            // foreach (Caption caption in caption)
//            // {
//            //     log.LogInformation($"\t{caption.text} (Confidence: {caption.confidence:p})");
//            // }

//            // Category category;
//            // category = Newtonsoft.Json.JsonConvert.DeserializeObject<Category>(contentString);

//            // foreach (Category category in contentString.Categories)
//            // {
//            //     log.LogInformation($"\t{category.Name} (Confidence: {category.Score:p})");
//            // }

//        }
//    }

//}

//public class Caption
//{
//    public string text { get; set; }
//    public double confidence { get; set; }
//}

//public class Category
//{
//    public string name { get; set; }
//    public double score { get; set; }
//}

//public class Description
//{
//    public List<string> tags { get; set; }
//    public List<Caption> captions { get; set; }
//}

//public class Metadata
//{
//    public int height { get; set; }
//    public int width { get; set; }
//    public string format { get; set; }
//}

//public class Root
//{
//    public List<Category> categories { get; set; }
//    public List<Tag> tags { get; set; }
//    public Description description { get; set; }
//    public List<object> faces { get; set; }
//    public string requestId { get; set; }
//    public Metadata metadata { get; set; }
//    public string modelVersion { get; set; }
//}

//public class Tag
//{
//    public string name { get; set; }
//    public double confidence { get; set; }
//}
