import {LightningElement, api, wire} from "lwc";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled} from "lightning/empApi";

export default class DisconnectionNotice extends LightningElement {
  subscription = {};
  status;
  identifier;
  @api channelName = "/event/Asset_Disconnection__e";

  connectedCallback() {
    this.handleSubscribe();
  }

  handleSubscribe() {
    //Implement your subscribing solution here
    if (this.subscription) {
      return;
    }

    const messageCallback = (response) => {
      console.log("New message received 1: ", JSON.stringify(response));

      let disconnected = response.data.payload.Disconnected__c;
      let assetId = response.data.payload.Asset_Identifier__c;
      this.status = disconnected;
      if (disconnected) {
        this.showSuccessToast(assetId);
      } else {
        this.showErrorToast();
      }

      console.log("New message received 2: ", response);
    };

    this.subscription = subscribe(this.channelName, -1, messageCallback).then((response) => {
      console.log("Subscription request sent to: ", JSON.stringify(response.channel));
      this.subscription = response;
    });
  }

  disconnectedCallback() {
    //Implement your unsubscribing solution here
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  showSuccessToast(assetId) {
    const event = new ShowToastEvent({
      title: "Success",
      message: "Asset Id " + assetId + " is now disconnected",
      variant: "success",
      mode: "dismissable",
    });
    this.dispatchEvent(event);
  }

  showErrorToast() {
    const event = new ShowToastEvent({
      title: "Error",
      message: "Asset was not disconnected. Try Again.",
      variant: "error",
      mode: "dismissable",
    });
    this.dispatchEvent(event);
  }
}
