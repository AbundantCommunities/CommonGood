<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <style type="text/css">
            #content-detail {
                height:100px;
            }
            #block-code-heading {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #block-code-value {
                position: absolute;
                top:30px;
                left: 155px;
            }
            #block-description-heading {
                position: absolute;
                top:50px;
                left: 10px;
            }
            #block-description-value {
                position: absolute;
                top:50px;
                left: 155px;
            }
            #order-within-neighbourhood-heading {
                position: absolute;
                top:70px;
                left: 10px;
            }
            #order-within-neighbourhood-value {
                position: absolute;
                top:70px;
                left: 155px;
            }
        </style>
    </head>
    <body>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>

                <div id="block-code-heading">Block code: </div>
                <div id="block-code-value">${navSelection.code}</div>
                <div id="block-description-heading">Description: </div>
                <div id="block-description-value">${navSelection.description}</div>
                <div id="order-within-neighbourhood-heading">Order within block: </div>
                <div id="order-within-neighbourhood-value">${navSelection.orderWithinNeighbourhood}</div>

                <div id="content-actions-left-side">
                    <div class="content-left-action"><a href="${resource(dir:'block',file:"contactList")}/${navSelection.id}">Contact List</a></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                    <div class="content-action"><a href="#">Search</a></div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Addresses for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#">+ Add New ${navChildren.childType}</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
            </div>
    </body>
</html>