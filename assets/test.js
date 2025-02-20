// SEND DATA TO FLUTTER
function sendDataToFlutter() {
  var value = {"name":"tashi"}
  window.chrome.webview.postMessage(value);

}
// LISTEN DATA FROM FLUTTER
window.chrome.webview.addEventListener('message', function(e) {
 alert("messagereceived: " + JSON.stringify(e.data));
});