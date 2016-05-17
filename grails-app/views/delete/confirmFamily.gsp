<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Delete Family Confirmation</title>

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

                        <div class="content-row">Are you CERTAIN you want to delete ${deleteThis}? ${magicToken}</div>
                        <div class="content-space-row">&nbsp;</div>
                        <div class="button-row center"><a href="#" onclick="alert('not yet implemented');"><div class="button bold" >Cancel</div></a><div class="button-spacer"></div><a href="#" onclick="alert('not yet implemented');"><div class="button">Delete</div></a></div>

                </div>
            </div>
    </body>
</html>