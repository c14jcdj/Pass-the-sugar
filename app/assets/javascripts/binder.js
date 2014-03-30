var Binder = (function(Ajax) {
    var _bindButtons = function(controller) {
        $('body')
            .off('click', 'button')
            .on('click', 'button', function(e) {
                switch (_dataTypeOf(this)) {
                    case 'submit':
                        $('form').submit();
                        break;
                    case 'logout':
                        controller.logout();
                        break;
                    case 'cancel':
                        controller.goBack(e);
                        break;
                    case 'add-record':
                        controller.loadAddRecord();
                        break;
                    case 'records-toggle':
                        controller.toggleRecordsPage();
                        break;
                    case 'dashboard-button':
                    case 'edit-diabetic-button':
                    case 'signup':
                        controller.loadNextPage($(this).data());
                        break;
                    case 'edit-record-button':
                        controller.loadNextPageFromData($(this).data());
                        break;
                    case 'help':
                        controller.loadHelpContent();
                        break;
                }
            })
    }
    var _dataTypeOf = function(element) {
        return $(element).data('type')
    }

    // Binds the selection of an item on the dashboard
    var _bindDashboardMenu = function(controller) {
        $('body').on('change', '#menu_choice', function(event) {
            controller.getSubmenu($(this).find(':selected').val())
        });
    }


    // Binds the load of the graph page to load the graph
    var _bindGraphLoad = function(controller) {
      $('body').on('getGraph', '#records-graph', function(event){
        controller.addGraph($(this).data());
      })
    }

    // Bind Ajax success on forms to trigger the next action
    var _bindAjaxForms = function(controller) {
        $('body')
            .off('ajax:success', 'form')
            .on('ajax:success', 'form', function(event, response) {
                if (response.ok && _isLogin(this)){
                  controller.login(response)
                } else if (response.ok) {
                  Ajax.get(response.path, controller.nextPageEvent.bind(controller))
                } else {
                  controller.addAlert(response.alert)
                };
            })
    }

    var _isLogin = function(el){
      return($(el).attr('id') === 'account-login')
    }

    return {
        bind: function(controller) {
            _bindButtons(controller);
            _bindAjaxForms(controller);
            _bindDashboardMenu(controller);
            _bindGraphLoad(controller);
        }

    }
}(Ajax))
