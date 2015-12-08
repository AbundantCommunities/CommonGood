<body>
<p>
    Nav Context ${result.navContext}
</p>
<p>
    Nav Selection ${result.navSelection}
</p>

<p>
    Nav Children type is ${result.navChildren.childType}
</p>

<g:each in="${result.navChildren.children}" var="child">
    <p>
        ${child.id}. {child.name}
    </p>
</g:each>

</body>
