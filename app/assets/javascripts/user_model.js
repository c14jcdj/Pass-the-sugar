var User = function(uId){
  this.uId = uId || null;
};

User.prototype = {
  listenForLogin: function(){
    var self = this
    $('body').on('login', function(event, data){
      self.uId = data;
    })
  }
}
