const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    auth: {
        user: 'bfriends.inc@gmail.com',
        pass: 'qgyo awfx jnia vvyq' // app password
    }
});

exports.sendCode = functions.region('asia-east1').https.onRequest(async (req, res) => {
    if (req.method !== 'POST') {
        return res.status(405).send({ message: 'Only POST method is allowed' });
    }

    const email = req.body.email;
    if (!email) {
        return res.status(400).send({ message: 'Email is required' });
    }

    const isRegistered = await checkIfEmailExists(email);

    if (!isRegistered) {
        return res.status(404).send({ message: 'Email is not registered' });
    }

    const verificationCode = Math.floor(1000 + Math.random() * 9000); // 4-digit code
    const expiry = new Date().getTime() + 300000; // Code expires in 5 minutes

    const codesCollection = admin.firestore().collection('verificationCodes');

    await codesCollection.doc(email).set({
        code: verificationCode,
        expiry: expiry
    });

    const mailOptions = {
        from: 'bfriends.inc@gmail.com',
        to: email,
        subject: 'Your verification code',
        text: `Your verification code is ${verificationCode}`
    };

    try {
        await transporter.sendMail(mailOptions);
        res.send({ message: 'Verification code sent' });
    } catch (error) {
        console.error('Failed to send email:', error);
        res.status(500).send({ message: 'Failed to send verification code' });
    }
});

exports.verifyCode = functions.region('asia-east1').https.onRequest(async (req, res) => {
    const { email, code } = req.body;
    if (!email || !code) {
        return res.status(400).send({ message: 'Email and code are required' });
    }

    const codesCollection = admin.firestore().collection('verificationCodes');
    const doc = await codesCollection.doc(email).get();

    if (!doc.exists) {
        return res.status(404).send({ message: 'User data not found' });
    }

    const userData = doc.data();
    if (userData.code == code && new Date().getTime() <= userData.expiry) {
        res.send({ message: 'Verification successful' });
    } else {
        res.status(400).send({ message: 'Invalid or expired code' });
    }
});


exports.resetPassword = functions.region('asia-east1').https.onRequest(async (req, res) => {
    if (req.method !== 'POST') {
        return res.status(405).send({ message: 'Only POST method is allowed' });
    }

    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).send({ message: 'Missing email or new password' });
    }

    try {
        const userRecord = await admin.auth().getUserByEmail(email);
        await admin.auth().updateUser(userRecord.uid, {
            password: password
        });
        res.send({ message: 'Password reset successfully' });
    } catch (error) {
        console.error(error);
        if (error.code === 'auth/user-not-found') {
            res.status(404).send({ message: 'User not found' });
        } else {
            res.status(500).send({ message: 'Failed to reset password', error: error.message });
        }
    }
});

async function checkIfEmailExists(email) {
    try {
        await admin.auth().getUserByEmail(email);
        return true;
    } catch (error) {
        if (error.code === 'auth/user-not-found') {
            console.log('Email not found:', email);
            return false;
        }
        console.error('Error fetching user data:', error);
        throw error;
    }
}

exports.sendNotificationOnNewGroupMessage = functions.region('asia-east1').firestore
  .document('groupChats/{eventId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const eventId = context.params.eventId;
    const eventData = (await admin.firestore().collection('events').doc(eventId).get()).data();
    const participants = Object.keys(eventData.participationList);

    const messageData = snapshot.data();
    const messageText = messageData.message;
    const senderId = messageData.userId;
    const groupName = messageData.groupName;
    const senderSnapshot = await admin.firestore().collection('users').doc(senderId).get();
    const senderUsername = senderSnapshot.data().username;
    const senderAvatarURL = senderSnapshot.data().avatarURL;

    functions.logger.info('New message from:', senderId, 'in event:', eventId);

    const notifications = await Promise.all(participants
      .filter(participantId => participantId !== senderId) // Exclude the sender
      .map(async participantId => {
        const tokenDoc = await admin.firestore().collection('users').doc(participantId).get();
        const recipientToken = tokenDoc.data()['fcmToken'];
        functions.logger.info('Sending notification to:', participantId, recipientToken);
        try {
            const response = await admin.messaging().send({
                token: recipientToken,
                notification: {
                    title: groupName == "" ? `${senderUsername}` : `${groupName} | ${senderUsername}`,
                    body: `${messageText}`,
                    imageUrl: senderAvatarURL,
                },
            });
            console.log('Notification sent:', response);
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }));

    return null;
  });

exports.sendNotificationOnNewPrivateMessage = functions.region('asia-east1').firestore
  .document('privateChats/{relationshipId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const relationshipId = context.params.relationshipId;
    const eventData = (await admin.firestore().collection('relationships').doc(relationshipId).get()).data();
    const participants = eventData.participants;

    const messageData = snapshot.data();
    const messageText = messageData.message;
    const senderId = messageData.userId;
    const senderSnapshot = await admin.firestore().collection('users').doc(senderId).get();
    const senderUsername = senderSnapshot.data().username;
    const senderAvatarURL = senderSnapshot.data().avatarURL;

    functions.logger.info('New message from:', senderId , 'in relationship:', relationshipId);

    const notifications = await Promise.all(participants
      .filter(participantId => participantId !== senderId)
      .map(async participantId => {
        const tokenDoc = await admin.firestore().collection('users').doc(participantId).get();
        const recipientToken = tokenDoc.data()['fcmToken'];
        functions.logger.info('Sending notification to:', participantId, recipientToken);
        try {
            const response = await admin.messaging().send({
                token: recipientToken,
                notification: {
                    title: `${senderUsername}`,
                    body: `${messageText}`,
                    imageUrl: senderAvatarURL,
                },
            });
            console.log('Notification sent:', response);
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }));

    return null;
  });

  



