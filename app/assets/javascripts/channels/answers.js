//= require cable
//= require_self
//= require_tree .

this.App || (this.App = {});
App.cable = ActionCable.createConsumer();

App.answers = App.cable.subscriptions.create('AnswersChannel', {
  received: console.log
});
