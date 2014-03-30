var Ajax = (function(){
  var _request = function(data,reaction){
    $.ajax(data)
    .done(function(response) {
      reaction(response);
    });
  }


  return {
    get: function(url, reaction){
      _request({ url: url }, reaction)
    },
    getSubmenu: function(submenu, reaction){
      var data = {
        url: '/dashboard/get',
        data: { 'menu_choice': submenu }
      }
      _request(data, reaction)
    },
    getEdit: function(type,id,reaction){
      var url = '/'+type+'/'+id+'/edit'
      this.get(url, reaction)
    },
    logout: function(userId, reaction){
      var data = {
        type: 'DELETE',
        url: '/sessions/'+userId
      }
      _request(data, reaction)
    },
    getHelpPage: function( reaction){
      var data = {
        url: '/help'
      }
      _request(data, reaction)
    },

  }
}());
