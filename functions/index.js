require("dotenv").config();
const functions = require("firebase-functions"); 
const axios = require("axios");

exports.transcribeAudio = functions.https.onRequest(async (req, res) => {
    try {
        const apiKey = process.env.API_KEY; // Replace with your key
        const audioURL = req.body.audioURL; // Get the file URL from request

        const response = await axios.post(
            "https://api.assemblyai.com/v2/transcript",
            { audio_url: audioURL },
            {
                headers: {
                    authorization: apiKey,
                    "Content-Type": "application/json",
                },
            }
        );

        res.status(200).json(response.data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
