<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="session"/>
        <title>CommonGood Reset Password</title>
        <script type="text/javascript">
            

            function emailOk(email) {
                if (email.length > 0) {
                    var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    return re.test(email);
                }
                return true;
            }

            function presentPleaseWait() {
                document.getElementById("flash-div").innerHTML = "&nbsp;";
                document.getElementById("email-address-span").innerHTML = document.getElementById("emailAddressInput").value;
                document.getElementById('emailAddressInput').style.display = 'none';
                document.getElementById('email-address-span').style.display = 'inline-block';
                document.getElementById('submit-div').style.display = 'none';
                document.getElementById('wait-div').style.display = 'block';
            }

            function okayToSubmit() {


                var emailAddress = document.getElementById('emailAddressInput').value;
                if (emailAddress != '') {
                    if (emailOk(emailAddress)) {
                        presentPleaseWait();
                        return true;
                    } else {
                        alert("The email address you entered is not valid.");
                    }
                } else {
                    alert("Please enter the email address you use to login.");
                }

                document.getElementById('emailAddressInput').focus();
                document.getElementById('emailAddressInput').select();

                return false;
            }

            function doSubmit() {
                if (okayToSubmit()) {
                    document.getElementById('reset-form').submit();
                }
            }


            window.onload = function onWindowLoad() {

                    document.getElementById("emailAddressInput").focus();
                    document.getElementById("emailAddressInput").select();

            }


        </script>
    </head>
    <body>
            <div id="content-detail">
                <div>Reset Password:</div>
                <div>To reset your password, start by entering the email address to use to login, then click Submit.</div>
                <form id="reset-form" onsubmit="return okayToSubmit();" action="<g:createLink action='sendEmail'/>" method="POST">
                    <div >Email address: <input id="emailAddressInput" type="text" name="emailAddress" value="" /><span id="email-address-span" style="display:none;"></span></div>
                </form>
                <div id="submit-div" class="no-bottom-space" style="display:block;"><a href="#" onclick="doSubmit();">Submit</a></div>
                <div id="wait-div" class="no-bottom-space" style="display:none;">Please wait ...</div>
                
                <div id="flash-div" class="red-text no-top-space"><g:if test="${flash.message}">${flash.message}</g:if><g:else>&nbsp;</g:else></div>
                
            </div>
    </body>
</html>