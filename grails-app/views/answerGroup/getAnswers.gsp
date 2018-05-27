<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Answers of a Group</title>


        <script type="text/javascript">

            function presentConfirmModal(answerId,answerText) {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // set height of overlay to match height of pagecontainer height
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                // set value of input so if user confirms, form is ready to be submitted.
                document.getElementById('delete-input').value = answerId;

                // set confirm text to specify answer text being deleted from group.
                document.getElementById('confirm-text-div').innerHTML = 'Remove the answer "'+answerText+'" from the group "${result.group.name}"?';                

                // show overlay and confirm-container divs
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("confirm-container").style.visibility='visible';
            }


            function confirmDelete(answerId) {
                alert(answerId);
                document.getElementById('delete-form').submit();
            }


            function dismissConfirmModal() {
                document.getElementById("confirm-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function deleteAnswer() {
                dismissConfirmModal();
                document.getElementById('delete-form').submit();
            }




        </script>


        <style type="text/css">

            #confirm-container {
                top:90px;
                left:280px;
                width:370px;
            }

        </style>





    </head>
    <body>

            <div class="content-section">
                    <div style="margin-top:-10px;"><h3>Answers Grouped under "${result.group.name}"</h3></div>

                    <g:if test="${result.answers.size()>0}">

                        <div>To remove an answer from the group, click the answer below.</div>
                        <div>&nbsp;</div>

                        <g:each in="${result.answers}" var="answer">
                            <div class="content-children-row">
                                <a href="#" onclick="javascript:presentConfirmModal('${answer.id}','${answer.text}');">${answer.text}</a>
                            </div>
                        </g:each>
                        <div class="content-children-row">&nbsp;</div>


                    </g:if>
                    <g:else>
                        <div>There are no answers in the group.</div>
                        <div>&nbsp;</div>
                    </g:else>

                    <div class="button-row" style="margin-top:10px;">
                        <g:link><div class="button">Done</div></g:link>
                    </div>
                    <div>&nbsp;</div>


                    <form id="delete-form" action="<g:createLink action='removeAnswer'/>" method="get">
                        <input id="delete-input" type="text" hidden name="id" value="" />
                    </form>

            </div>

            <div id="transparent-overlay"></div>

            <div id="confirm-container" class="modal">
                <div class="modal-title">Delete Confirmation</div>
                <div>&nbsp;</div>
                <div id="confirm-text-div">Are you sure you would like to delete the answer from the group?</div>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissConfirmModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:deleteAnswer();">Delete</div>
                </div>
            </div>

    </body>
</html>
