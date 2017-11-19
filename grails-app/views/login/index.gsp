<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="session"/>
        <title>CommonGood Login</title>
        <script type="text/javascript">
            
            var currentlyHidden = true;


            function getCookie(cname) {
                var name = cname + "=";
                var ca = document.cookie.split(';');
                for(var i=0; i<ca.length; i++) {
                    var c = ca[i];
                    while (c.charAt(0)==' ') c = c.substring(1);
                    if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
                }
                return "";
            }

            window.onload = function onWindowLoad() {

                var email = getCookie('email');
                var showPw = getCookie('showPw');

                if (email) {
                    document.getElementById('emailAddressInput').value = email;
                    document.getElementById('rememberCheckbox').checked = true;
                    document.getElementById("pwHidden").focus();
                    document.getElementById("pwHidden").select();
                } else {
                    document.getElementById("emailAddressInput").focus();
                    document.getElementById("emailAddressInput").select();
                }

                if (showPw=='t') {
                    showHidePw();
                }

            }

            function showHidePw() {
                if (currentlyHidden) {
                    document.getElementById("pwShown").value = document.getElementById("pwHidden").value;
                    document.getElementById("pwShown").style.display = "initial";
                    document.getElementById("pwHidden").style.display = "none";
                    document.getElementById("showHideButton").innerHTML = "hide";
                    document.getElementById("pwShown").focus();
                    document.getElementById("pwShown").select();
                } else {
                    document.getElementById("pwHidden").value = document.getElementById("pwShown").value;
                    document.getElementById("pwShown").style.display = "none";
                    document.getElementById("pwHidden").style.display = "initial";
                    document.getElementById("showHideButton").innerHTML = "show";
                    document.getElementById("pwHidden").focus();
                    document.getElementById("pwHidden").select();
                }
                currentlyHidden = !currentlyHidden;
            }

            function doSubmit() {

                var expirationDate = new Date ();
                expirationDate.setYear (expirationDate.getFullYear () + 1);
                expirationDate = expirationDate.toGMTString ();
                
                document.cookie = "email=; expires=Thu, 01 Jan 1970 00:00:00 UTC;";
                document.cookie = "showPw=; expires=Thu, 01 Jan 1970 00:00:00 UTC;";

                if (currentlyHidden) {
                    document.getElementById('submitPassword').value = document.getElementById('pwHidden').value;
                    document.cookie="showPw=f;expires="+expirationDate+";";
                } else {
                    document.getElementById('submitPassword').value = document.getElementById('pwShown').value;
                    document.cookie="showPw=t;expires="+expirationDate+";";
                }

                if (document.getElementById('rememberCheckbox').checked) {
                    document.cookie="email="+document.getElementById('emailAddressInput').value+";expires="+expirationDate+";";
                }

                document.getElementById('loginForm').submit();
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
                <div>Login to CommonGood:</div>
                <form id="loginForm" action="<g:createLink action='authenticate'/>" method="post">
                    <div>Email address <input id="emailAddressInput" type="text" name="emailAddress" value="" onKeyPress="checkEnter(event);"/></div>
                    <div>Password <input id="pwHidden" type="password" name="hiddenPassword" value="" onKeyPress="checkEnter(event);"/><input id="pwShown" type="text" name="shownPassword" value="" style="display:none;" onKeyPress="checkEnter(event);"/>&nbsp;<a id="showHideButton" href="#" onclick="showHidePw();">show</a></div>
                    <input id="submitPassword" type="hidden" name="password" value=""/>
                </form>
                <div><a href="passwordReset">forgot password</a>&nbsp;&nbsp;&nbsp;&nbsp;<input id="rememberCheckbox" type="checkbox" name="remember" value="remember email address" /> remember email address</div>
                <div class="no-bottom-space"><a href="#" onclick="doSubmit();">Login</a></div>
                
                <div class="red-text no-top-space"><g:if test="${flash.message}">${flash.message}</g:if><g:else>&nbsp;</g:else></div>
                
            </div>
    </body>
</html>