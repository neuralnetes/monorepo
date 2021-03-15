/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */
exports.entry = (event, context) => {
    console.log(event)
    console.log(context)
    const { data } = event
    const message = data
        ? Buffer.from(data, 'base64').toString()
        : 'Hello, World';
    console.log(message);
};
