<!-- <script setup>
import { ref, onMounted} from 'vue'

const canvas = ref(null)
const video = ref(null)
const ctx = ref(null)
// const name = ref('')
const constraints = ref({
    audio : false,
    video : true
})

onMounted(async () => {
    if (video.value) {
        ctx.value = canvas.value.getContext("2d");

        await navigator.mediaDevices
            .getUserMedia(constraints.value)
            .then(setStream)
            .catch(err => {
                console.log(err)
            })
    }
})

function setStream (stream) {
    video.value.srcObject = stream;
    video.value.play();

    requestAnimationFrame(Draw);
}

function Draw () {
    ctx.value.drawImage(video.value, 0, 0, canvas.value.width, canvas.value.height)

    requestAnimationFrame(Draw);
}

function TakePicture () {
    const pic_name = name.value
    var link = document.createElement('a')
    link.href = canvas.value.toDataURL()
    
    sendImage(link.href)

    console.log(link.href)
}

const sendImage = async (link) => {
    const res = await fetch(API_URL, 
        {
            method : "POST",
            header : "Content-Type : application/json",
            body : JSON.stringify({
                title : name,
                image : link
            })
        }

    )
}

function SetName () {
    
}
</script>

<template>
    <div>

        <div class="_input_name">
            <input ref="name" type="text" class="_input_enter">
        </div>

        <video ref="video" autoplay playsinline webkit-playsinline muted hidden></video>

        <canvas ref="canvas" width="1280" height="720" class="_canvas_container"></canvas>

        <div class="_btn_container">
            <button @click="TakePicture" class="_btn_take_picture">
            Take Picture
        </button>
        </div>
    </div>
</template>

<style scoped>
    ._canvas_container {
        background-color: black;
        border-radius: 20px;
    }
    ._btn_container {
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 1em;
    }
    ._btn_take_picture {
        background-color: greenyellow;
        padding-left: 2em;
        padding-right: 2em;
        padding-top: 2em;
        padding-bottom: 2em;
        border-radius: 20px;
        color: black;
        font-weight: bold;
        border: none;
    }
    ._input_name {
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 2em;
    }

    ._input_enter {
        width: 25em;
        height: 3em;
        border-radius: 20px;
        padding-left: 1em;
    }
</style> -->

<template>
    <div>
      <h1>Camera Capture App</h1>
  
      <!-- Video element to display the webcam feed -->
      <video ref="webcam" width="640" height="480" autoplay></video>
  
      <!-- Input field for the user to enter a name -->
      <label for="nameInput">Enter your name:</label>
      <input v-model="name" type="text" id="nameInput" />
  
      <!-- Button to capture the image and send it to the backend -->
      <button @click="captureAndSend">Capture and Send</button>
  
      <!-- Display the captured image -->
      <div v-if="imageCaptured">
        <img :src="capturedImage" alt="Captured" />
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        name: '',               // Variable to store the user-entered name
        imageCaptured: false,   // Flag to track whether an image is captured
        capturedImage: null     // Variable to store the captured image data
      };
    },
    methods: {
      async setupWebcam() {
        const constraints = { video: { width: 640, height: 480 } };
  
        try {
          // Access the webcam stream and set it to the video element
          const stream = await navigator.mediaDevices.getUserMedia(constraints);
          this.$refs.webcam.srcObject = stream;
        } catch (error) {
          console.error('Error accessing webcam:', error);
        }
      },
      captureImage() {
        const video = this.$refs.webcam;
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
  
        // Set the canvas size to match the video size
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
  
        // Draw the current frame from the video onto the canvas
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
  
        // Convert the canvas content to a data URL representing a PNG image
        const imageDataURL = canvas.toDataURL('image/png');
  
        // Save the captured image data
        this.capturedImage = imageDataURL;
        this.imageCaptured = true;
      },
      captureAndSend() {
        // Ensure a name is entered before proceeding
        if (!this.name) {
          alert('Please enter a name.');
          return;
        }
  
        // Capture the image
        this.captureImage();
  
        // Send the captured image to the backend with the specified name
        const apiUrl ='http://localhost:3000/api/images';  // Replace with your API endpoint
        const imageName = `${this.name}.png`;
  
        // POST request using fetch
        fetch(apiUrl, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ name: imageName, image: this.capturedImage }),
        })
          .then(response => response.json())
          .then(data => {
            console.log('Image sent successfully', data);
            // You can perform any additional actions here
          })
          .catch(error => {
            console.error('Error sending image', error);
          });
      }
    },
    mounted() {
      // Setup webcam when the component is mounted
      this.setupWebcam();
    }
  };
  </script>
  
  <style scoped>
  /* Add your component styles here */
  </style>
  