const functions = require("firebase-functions");
const admin = require("firebase-admin");    // admin통해서 토큰 발급 가능
const auth = require("firebase-auth");
// 앱에서는 서버 없이는 토큰 못 만든다고함. 서버 꼭 필요

var serviceAccount = require("./wewish-b573a-firebase-adminsdk-2zzhb-573a3147cd.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//

 exports.createCustomToken = functions.https.onRequest(async(request, response) => {
    const user = request.body;


    const uid = `kakao:${user.uid}`;
    const updateParams = {
        email : user.email,
        photoURL : user.photoURL,
        displayName : user.displayName,
    };

    try{    // 기존 계정이 있을 경우 업데이트
        await admin.auth().updateUser(uid, updateParams);
    }catch(e){  // 등록이 안 되어 있는 경우
        updateParams["uid"] = uid;
        await admin.auth().createUser(updateParams)
    }
    const token = await admin.auth().createCustomToken(uid); // 토큰 생성

    response.send(token);
 });
