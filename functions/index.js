const functions = require("firebase-functions");
const axios = require("axios");

// Function 1: Initiate transcription and return the transcription ID
exports.transcribeAudio = functions.https.onRequest(async (req, res) => {
  const audioURL = req.body.audioURL;
  if (!audioURL) {
    return res.status(400).json({ error: "audioURL is required" });
  }

  try {
    const apiKey = process.env.API_KEY;
    if (!apiKey) {
      throw new Error("AssemblyAI API key is not configured");
    }

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

    // Return only the transcription ID for simplicity
    res.status(200).json({ id: response.data.id });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Function 2: Fetch transcription results using the ID
exports.getTranscription = functions.https.onRequest(async (req, res) => {
  const transcriptionId = req.body.transcriptionId;
  if (!transcriptionId) {
    return res.status(400).json({ error: "transcriptionId is required" });
  }

  try {
    const apiKey = process.env.API_KEY;
    if (!apiKey) {
      throw new Error("AssemblyAI API key is not configured");
    }

    const response = await axios.get(
      `https://api.assemblyai.com/v2/transcript/${transcriptionId}`,
      {
        headers: {
          authorization: apiKey,
        },
      }
    );

    const data = response.data;
    if (data.status === "completed") {
      // Return only the text if transcription is complete
      res.status(200).json({ text: data.text });
    } else {
      // Return the current status if not completed
      res.status(200).json({ status: data.status });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});