using System;
using System.IO;
using System.Net.Http.Headers;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ImageProcessing.FuncApp
{
    public class ResizeImageCognitiveServices
    {
        private readonly ILogger _logger;

        public ResizeImageCognitiveServices(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<ResizeImageCognitiveServices>();
        }

        [Function("ResizeImageCognitiveServices")]
        public void Run([BlobTrigger("samples-workitems/{name}", Connection = "")] string myBlob, string name)
        {
            _logger.LogInformation($"C# Blob trigger function Processed blob\n Name: {name} \n Data: {myBlob}");
        }
    }
}


using System;
using System.Text;
using System.Net.Http;
using System.Net.Http.Headers;

public static void Run(Stream myBlob, string name, ILogger log, string extension, Stream outputBlob)
{
    log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");

    int width = 320;
    int height = 320;
    bool smartCropping = true;

    // Key for Cognitive Computer Vision Service
    string _apiKey = "32ffb026964f46d9ab44928b41adc2f3";

    // Cognitive Computer Vision Services to resize image
    string _apiUrlBase = "https://centralus.api.cognitive.microsoft.com/vision/v3.2/";

    using (var httpClient = new HttpClient())
    {
        httpClient.BaseAddress = new Uri(_apiUrlBase);
        httpClient.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", _apiKey);
        using (HttpContent content = new StreamContent(myBlob))
        {
            //get response
            content.Headers.ContentType = new MediaTypeWithQualityHeaderValue("application/octet-stream");
            var uri = $"{_apiUrlBase}generateThumbnail?width={width}&height={height}&smartCropping={smartCropping.ToString()}";
            var response = httpClient.PostAsync(uri, content).Result;
            var responseBytes = response.Content.ReadAsByteArrayAsync().Result;

            //write to output thumb
            outputBlob.Write(responseBytes, 0, responseBytes.Length);
        }
    }
}