var View = function(){
  this.selectors = {
    navbarSelector: '#navbar',
    titleSelector: 'h1#title',
    contentSelector: '#content',
    submenuSelector: '#submenu',
    recordsSummarySelector: '#records-summary',
    recordsGraphSelector: '#records-graph',
    recordsToggleButtonSelector: '#records-toggle-button',
    alertBoxSelector: '#notice'
  };
  this.templates = HandlebarsTemplates;
  this.toggleButtonText = ['Graph','Records']
}

View.prototype = {
  clearNavBar: function(){
    $(this.selectors.navbarSelector).empty();
  },
  addNavBar: function(left,right){
    this.clearNavBar();
    var template = this.templates.navbar;
    var context = {
                    'left-button': left,
                    'right-button': right
                  }
    $(this.selectors.navbarSelector).append(template(context));
  },
  changeTitle: function(title){
    $(this.selectors.titleSelector).text(title);
  },
  changeContent: function(html){
    $(this.selectors.contentSelector).html(html);
  },
  newPage: function(html){
    $('body').html(html);
  },
  reloadPage: function(html){
    this.changeContent(html);
    this.addNavBar(leftButton, rightButton);
    this.changeTitle(title);
  },
  // Alerts
  addAlert: function(alert){
    this.showAlertBox();
    $(this.selectors.alertBoxSelector).html(this.formatAlert(alert));
    setTimeout(this.hideAlertBox.bind(this),5000);
  },
  showAlertBox: function(){
    $(this.selectors.alertBoxSelector).show();
  },
  hideAlertBox: function(){
    $(this.selectors.alertBoxSelector).html('').hide()
  },
  formatAlert: function(alert){
    var result = "<ul>"
    if(typeof alert === "object"){
      for(var i = 0; i < alert.length; i++){
        result = result + '<li>' + alert[i] + '</li>';
      }
    } else {
      result = result + '<li>' + alert + '</li>'
    }

    return(result + '</ul>')
  },

  // Submenu
  addSubmenu: function(menu){
    $(this.selectors.submenuSelector).html(menu);
  },

  // Record page
  toggleRecordsPage: function(){
    $(this.selectors.recordsSummarySelector).toggle();
    $(this.selectors.recordsGraphSelector).toggle();
    this.switchRecordsToggleButton();
  },
  switchRecordsToggleButton: function(){
    var button = this.selectors.recordsToggleButtonSelector
    if ($(button).text() === this.toggleButtonText[0]){
      $(button).text(this.toggleButtonText[1])
    }else{
      $(button).text(this.toggleButtonText[0])
    }
  }
}
