<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><g:layoutTitle default="Grails"/></title>
        <meta name="description" content="Abundant Community Initiative CommonGood" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'session.css')}" />
        <g:layoutHead/>
    </head>
    <body>
        <div id="pagecontainer">
            <div id="aci-logo-line">
                    <img src="${resource(dir:'images',file:'aci-logo.png')}" width="160" height="156" />
            </div>
            <g:layoutBody/>
            <div id="footer">
                <div class="no-bottom-space">&copy;<script type="text/javascript">document.write(new Date().getFullYear());</script> The Abundant Community Initiative Canada.</div>
                <div class="no-top-space" style="height:20px;">CommonGood Version <g:meta name="app.version"/></div>
            </div>
        </div>
    </body>
</html>