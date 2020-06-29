const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// @ts-ignore
function statusCodeToStatus(status: number): string   {
    switch (status) {
        case 0:
            return "REQUESTED";
        case 1:
            return "VERIFIED";
        case 2:
            return "IN_PROGRESS";
        case 3:
            return "CANCELLED";
        case 4:
            return "DONE";
        case 5:
            return "REJECTED";
    }
}

// @ts-ignore
function statusEnglishToRomanian(status: string): string   {
    switch (status) {
        case "REQUESTED":
            return "solicitat";
        case "VERIFIED":
            return "confirmat";
        case "IN_PROGRESS":
            return "desfășurare";
        case "CANCELLED":
            return "anulat";
        case "DONE":
            return "terminat";
        case "REJECTED":
            return "refuzat";
    }
}

export const updateStatus = functions.firestore
    .document('appointments/{status}')
    // @ts-ignore
    .onUpdate(async snapshot => {
        const appointment = snapshot.after.data();
        const key = snapshot.after.id;
        const previousStatus = snapshot.before.data().status;
        console.log(key)
        if (appointment !== undefined)  {
            console.log("Appointment is: ", appointment)
            let statusId = appointment.status;
            console.log(previousStatus, "=>", statusId)
            //Status confirmed, notify user
            if (statusId == 1)    {
                const querySnapshot = await db
                    .collection('users')
                    .doc(appointment.clientId)
                    .collection('tokens')
                    .get();

                const tokens = querySnapshot.docs.map(snap => snap.id);

                const payload: admin.messaging.MessagingPayload = {
                    notification: {
                        title: 'Appointment confirmed',
                        body: `Appointment on ${appointment.date} with ${appointment.doctorName}} is confirmed`,
                        icon: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.dentalplans.com%2F2016%2Fdear-doctorb%2Fhow-to-read-dental-bill%2Fhappy-tooth-01.png&f=1&nofb=1',
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                };
                console.log(payload)
                return fcm.sendToDevice(tokens, payload);
            }

            //Canceled, notify user
            if (statusId == 3)    {
                const querySnapshot = await db
                    .collection('users')
                    .doc(appointment.clientId)
                    .collection('tokens')
                    .get();

                //Retrieves tokens associated with the doctor of a certain appointment
                const querySnapshot2 = await db
                    .collection('users')
                    .doc(appointment.doctorId)
                    .collection('tokens')
                    .get();

                let tokens = querySnapshot.docs.map(snap => snap.id);
                tokens = tokens.concat(querySnapshot2.docs.map(snap => snap.id));
                console.log("tokens:", tokens)
                const payload: admin.messaging.MessagingPayload = {
                    notification: {
                        title: 'Appointment canceled',
                        body: `Appointment on ${appointment.date} with ${appointment.doctorName} was canceled`,
                        icon: 'your-icon-url',
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                };
                console.log(payload)
                return fcm.sendToDevice(tokens, payload);
            }

            else    {
                return 'Appointment ${key}, on ${appointment.date} changed from ${previousStatus} to ${appointment.status}'
            }
        }
});

export const updateNotes = functions.firestore
    .document('appointments/{notes}')
    .onUpdate(async snapshot => {
        // @ts-ignore
        const appointment = snapshot.after.data();

        //Notes updated, notify user
        const querySnapshot = await db
            .collection('users')
            .doc(appointment.clientId)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'Consultation ${appointment.date} notes updated',
                body: `${appointment.notes}`,
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        return fcm.sendToDevice(tokens, payload);
    });
