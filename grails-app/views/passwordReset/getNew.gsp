<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="session"/>
        <title>CommonGood Reset Password</title>
        <script type="text/javascript">
            
            var currentlyHidden = true;

            window.onload = function onWindowLoad() {
                document.getElementById("pw1Hidden").focus();
                document.getElementById("pw1Hidden").select();
            }

            function showHidePw() {
                if (currentlyHidden) {
                    document.getElementById("pw1Shown").value = document.getElementById("pw1Hidden").value;
                    document.getElementById("pw1Shown").style.display = "initial";
                    document.getElementById("pw1Hidden").style.display = "none";
                    document.getElementById("pw2Shown").value = document.getElementById("pw2Hidden").value;
                    document.getElementById("pw2Shown").style.display = "initial";
                    document.getElementById("pw2Hidden").style.display = "none";
                    document.getElementById("showHideButton").innerHTML = "hide";
                    document.getElementById("pw1Shown").focus();
                    document.getElementById("pw1Shown").select();
                } else {
                    document.getElementById("pw1Hidden").value = document.getElementById("pw1Shown").value;
                    document.getElementById("pw1Shown").style.display = "none";
                    document.getElementById("pw1Hidden").style.display = "initial";
                    document.getElementById("pw2Hidden").value = document.getElementById("pw2Shown").value;
                    document.getElementById("pw2Shown").style.display = "none";
                    document.getElementById("pw2Hidden").style.display = "initial";
                    document.getElementById("showHideButton").innerHTML = "show";
                    document.getElementById("pw1Hidden").focus();
                    document.getElementById("pw1Hidden").select();
                }
                currentlyHidden = !currentlyHidden;
            }

            function passwordsOkay(pw1, pw2) {
                if (pw1 == pw2) {
                    if ((pw1.length >= 6)) {
                        return true;
                    } else {
                        alert ("Your password must be at least 6 characters in length.");
                        return false;
                    }
                } else {
                    alert ("You must enter your new password twice. The passwords you entered do not match.");
                    return false;
                }
            }



            function doSubmit() {

                var pw1;
                var pw2;

                if (currentlyHidden) {
                    pw1 = document.getElementById('pw1Hidden').value;
                    pw2 = document.getElementById('pw2Hidden').value;
                } else {
                    pw1 = document.getElementById('pw1Shown').value;
                    pw2 = document.getElementById('pw2Shown').value;
                }

                if (passwordsOkay(pw1,pw2)) {
                    document.getElementById('submitPassword1').value = pw1;
                    document.getElementById('submitPassword2').value = pw2;
                    document.getElementById('resetForm').submit();
                }

            }


            function checkEnter(e) {
                var characterCode;

                if(e && e.which) { //if which property of event object is supported (NN4)
                    e = e;
                    characterCode = e.which; //character code is contained in NN4's which property
                }
                else{
                    e = event;
                    characterCode = e.keyCode; //character code is contained in IE's keyCode property
                }

                if(characterCode == 13) { //if generated character code is equal to ascii 13 (if enter key)

                    doSubmit(); //submit the form
                    return false;
                }
                else{
                    return true;
                }
            }


        </script>
    </head>
    <body>
            <div id="content-detail">
                <div>Password Reset:</div>
                <g:if test="${quality.equals('okay')}">
                    <div>You have requested to reset your password.</div>
                    <div>Enter your new password below (twice), then click Set Password.</div>
                    <form id="dataEntryForm" action="" method="post">
                        <div style="height:20px;"><div style="display:inline-block;width:115px;">New password </div><div style="display:inline-block;"><input id="pw1Hidden" type="password" name="hiddenPassword1" value="" onKeyPress="checkEnter(event);"/><input id="pw1Shown" type="text" name="shownPassword1" value="" style="display:none;" onKeyPress="checkEnter(event);"/>&nbsp;<a id="showHideButton" href="#" onclick="showHidePw();">show</a></div></div>
                        <div><div style="display:inline-block;width:115px;">Enter again </div><div style="display:inline-block;"><input id="pw2Hidden" type="password" name="hiddenPassword2" value="" onKeyPress="checkEnter(event);"/><input id="pw2Shown" type="text" name="shownPassword2" value="" style="display:none;" onKeyPress="checkEnter(event);"/></div></div>
                    </form>
                    <form id="resetForm" action="<g:createLink action='reset'/>" method="post">
                        <input id="submitPassword1" type="hidden" name="password1" value=""/>
                        <input id="submitPassword2" type="hidden" name="password2" value=""/>
                    </form>
                    <div class="no-bottom-space"><a href="#" onclick="doSubmit();">Set Password</a></div>
                    <div>&nbsp;</div>
                </g:if>
                <g:if test="${quality.equals('stale')}">


                </g:if>
                <g:if test="${quality.equals('inactive')}">


                </g:if>
                <g:if test="${quality.equals('nof')}">


                </g:if>

                
            </div>
    </body>
</html>