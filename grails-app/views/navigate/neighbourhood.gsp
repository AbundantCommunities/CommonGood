<body>
<p>
    Nav Context ${result.navContext}
</p>
<p>
    Nav Selection ${result.navSelection}
</p>
<p>
    Nav Children ${result.navChildren}
</p>
<p>
Nav Children type is ${result.navChildren.childType}
</p>
<g:each in="${result.navChildren}" var="child">
    <p>
        ${child}
    </p>
</g:each>

</p>
</body>
