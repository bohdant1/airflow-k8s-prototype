const http = require('http');

exports.handler = async (s3Event) => {
  // Extract S3 event record
  const s3EventRecord = s3Event.Records[0].s3;
  
  // Extract uploaded file name from S3 event metadata
  const uploadedFileName = s3EventRecord.object.key;
  // Generate a random dag run id
  const dagRunId = 'demo_id_' + Math.random().toString(36).substring(7);

  // Define the data payload
  const payload = {
    conf: {
      message: uploadedFileName
    },
    dag_run_id: dagRunId
  };

  // Convert payload to JSON string
  const postData = JSON.stringify(payload);

  // Define the options for the HTTP request
  const options = {
    hostname: 'host.docker.internal',
    port: 8080,
    path: `/api/v1/dags/mar27test1.py/dagRuns`,
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': postData.length,
      'Authorization': 'Basic ' + Buffer.from('admin:admin').toString('base64') // Basic Authentication
    }
  };

  // Make the HTTP POST request
  const req = http.request(options, (res) => {
    let data = '';

    // Concatenate chunks of data
    res.on('data', (chunk) => {
      data += chunk;
    });

    // Log the response data when the response ends
    res.on('end', () => {
      console.log(data);
    });
  });

  // Log any errors that occur during the request
  req.on('error', (error) => {
    console.error(error);
  });

  // Write the data payload to the request body
  req.write(postData);

  // Send the request
  req.end();
};
