<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="session"/>
        <title>CommonGood Reset Password</title>
    </head>
    <body>
        <div id="content-detail">
            <div>Password Reset:</div>
            <div>A message has been sent to email address:</div>
            <div>${reset.emailAddress}</div>
            <div>Please follow the instructions in the message to reset your password.</div>
            <div>You must do this before ${reset.expiryTime}.</div>
        </div>
    </body>
</html>