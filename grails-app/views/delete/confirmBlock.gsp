<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Delete Block Confirmation</title>

        <script type="text/javascript">

            function doDelete() {
                document.getElementById('delete-form').submit();
            }


            function doCancel() {
                // Cancel delete.

                var xmlhttp = new XMLHttpRequest( );
                var url = '<g:createLink controller="delete" action="cancel"/>';
                xmlhttp.onreadystatechange = function( ) {
                    if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                        // no response expected
                        completeCancel();
                    }
                };

                xmlhttp.open( "GET", url, true );
                xmlhttp.send( );

                function completeCancel() {
                    document.getElementById('cancel-form').submit();
                }
            }

        </script>
    </head>

    <body>
            <div class="content-section content-container">
                <div class="content-section-embedded" style="width:460px">
                    <div style="margin-top:-15px;"><h3>Delete Confirmation</h3></div>

                        <div class="content-row">You asked to DELETE <span class="bold">${deleteThis}</span> from the database.</div>
                        <div class="content-space-row">&nbsp;</div>
                        <div class="content-row">These associated records would also be deleted:</div>
                        <ul>
                        <g:each in="${associatedTables}" var="tableWithCount">
                            <li>${tableWithCount}</li>
                        </g:each>
                        </ul>

                        <div class="content-row">Are you CERTAIN you want to delete ${deleteThis}?</div>
                        <div class="content-space-row">&nbsp;</div>

                        <div class="button-row center"><a href="#" onclick="doCancel();"><div class="button bold" >Cancel</div></a><div class="button-spacer"></div><a href="#" onclick="doDelete();"><div class="button">Delete</div></a></div>
                        <form id="delete-form" action="<g:createLink controller='delete' action='block' />" method="GET">
                            <input type="hidden" name="id" value="${id}"/>
                            <input type="hidden" name="magicToken" value="${magicToken}"/>
                        </form>
                        <form id="cancel-form" action="<g:createLink controller='navigate' action='${session.lastNavigationLevel}' id='${session.lastNavigationId}'/>" method="GET">
                        </form>

                </div>
            </div>
    </body>
</html>