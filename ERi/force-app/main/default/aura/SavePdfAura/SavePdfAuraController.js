({
    myAction : function(component, event, helper) {
        var action = component.get("c.generatePDF");
            action.setParams({
                orderId: component.get("v.recordId")
            });
            $A.enqueueAction(action);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})