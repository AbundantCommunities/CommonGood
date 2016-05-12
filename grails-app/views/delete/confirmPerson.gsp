<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Delete Person Confirmation</title>

    </head>
    <body>
            <div class="content-section content-container">
                <div id="content-section-embedded" style="width:460px">
                    <div style="margin-top:-15px;"><h3>Delete Confirmation</h3></div>

                        <p>
                            You asked to DELETE <span style="background-color:lightyellow;">${deleteThis}</span>
                            from the database.
                        </p>

                        <p>These associated records would also be deleted:</p>
                        <ul>
                        <g:each in="${associatedTables}" var="tableWithCount">
                            <li>${tableWithCount}</li>
                        </g:each>
                        </ul>

                        <p>Are you CERTAIN you want to delete ${deleteThis}?</p>

                </div>
            </div>
    </body>
</html>