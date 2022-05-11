
// Get the DynamoDB table name from environment variables
const tableName = process.env.ORDERS_TABLE;

// Create a DocumentClient that represents the query to add an item
const dynamodb       = require('aws-sdk/clients/dynamodb');
const documentClient = new dynamodb.DocumentClient();

exports.handler = async (event) => {
    
    // All log statements are written to CloudWatch
    console.debug('Received event:', JSON.stringify(event, null, 2));

    // get all items from the table (only first 1MB data)
    // https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html#scan-property
    // https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Scan.html
    var params = {
        TableName: tableName
    };
    
    const data = await documentClient.scan(params).promise();
    
    // All log statements are written to CloudWatch
    console.debug('data: ', JSON.stringify(data, null, 2)); 

    const response = {
        statusCode: 200,
        body: JSON.stringify(data.Items)
    };

    return response;
}
