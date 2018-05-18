// window.onGoogleYoloLoad = (googleyolo) => {
//     const retrievePromise = googleyolo.retrieve({
//         supportedAuthMethods: [
//           "https://accounts.google.com",
//         ],
//         supportedIdTokenProviders: [
//           {
//             uri: "https://accounts.google.com",
//             clientId: "656447153174-tc9ihushsjtou7ge392tluel5rcmjnb8.apps.googleusercontent.com"
//           }
//         ]
//       });

//       retrievePromise.then((credential) => {
//         if (credential.idToken) {
//           // A Google Account is retrieved. Since Google supports ID token responses,
//           // you can use the token to sign in instead of initiating the Google sign-in
//           // flow.
//           console.log(credential.idToken);
//         }
//       }, (error) => {
//         // Credentials could not be retrieved. In general, if the user does not
//         // need to be signed in to use the page, you can just fail silently; or,
//         // you can also examine the error object to handle specific error cases.
      
//         // If retrieval failed because there were no credentials available, and
//         // signing in might be useful or is required to proceed from this page,
//         // you can call `hint()` to prompt the user to select an account to sign
//         // in or sign up with.
//         // if (error.type === 'noCredentialsAvailable') {
//         //   googleyolo.hint(...).then(...);
//         // }
//         console.log(error)
//       });

//       const hintPromise = googleyolo.hint({
//         supportedAuthMethods: [
//           "https://accounts.google.com"
//         ],
//         supportedIdTokenProviders: [
//           {
//             uri: "https://accounts.google.com",
//             clientId: "656447153174-tc9ihushsjtou7ge392tluel5rcmjnb8.apps.googleusercontent.com"
//           }
//         ]
//       });
//       hintPromise.then((credential) => {
//         if (credential.idToken) {
//           // Send the token to your auth backend.
//           console.log(credential.idToken);
//         }
//       }, (error) => {
//         switch (error.type) {
//           case "userCanceled":
//             // The user closed the hint selector. Depending on the desired UX,
//             // request manual sign up or do nothing.
//             break;
//           case "noCredentialsAvailable":
//             // No hint available for the session. Depending on the desired UX,
//             // request manual sign up or do nothing.
//             break;
//           case "requestFailed":
//             // The request failed, most likely because of a timeout.
//             // You can retry another time if necessary.
//             break;
//           case "operationCanceled":
//             // The operation was programmatically canceled, do nothing.
//             break;
//           case "illegalConcurrentRequest":
//             // Another operation is pending, this one was aborted.
//             break;
//           case "initializationError":
//             // Failed to initialize. Refer to error.message for debugging.
//             break;
//           case "configurationError":
//             // Configuration error. Refer to error.message for debugging.
//             break;
//           default:
//             // Unknown error, do nothing.
//         }
//       });
// };


function init() {
  console.log(gapi);
  gapi.load('auth2', function() {
    console.log(gapi.auth2.getAuthInstance())
   });
}

function onSignIn(googleUser) {
  var profile = googleUser.getBasicProfile();
  console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
  console.log('Name: ' + profile.getName());
  console.log('Image URL: ' + profile.getImageUrl());
  console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.

  var form = document.createElement("form");
  form.method = "POST"; // or "post" if appropriate
  form.action = "/profile";

  var inputField = document.createElement("input");
  inputField.type = "text";
  inputField.name = "id";
  inputField.value = profile.getId();
  form.appendChild(inputField);

  var inputField = document.createElement("input");
  inputField.type = "text";
  inputField.name = "email";
  inputField.value = profile.getEmail();
  form.appendChild(inputField);

  var inputField = document.createElement("input");
  inputField.type = "text";
  inputField.name = "name";
  inputField.value = profile.getName();
  form.appendChild(inputField);

  var inputField = document.createElement("input");
  inputField.type = "text";
  inputField.name = "image";
  inputField.value = profile.getImageUrl();
  form.appendChild(inputField);

  document.body.appendChild(form);

  form.submit();
}