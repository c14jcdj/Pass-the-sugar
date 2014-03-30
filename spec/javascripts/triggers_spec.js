describe('Triggers', function(){
  describe('login', function(){
    it('should use redirectTo if you call login in the controller',function(){
      spyOn(GlucoseAmigo.controller, 'redirectTo').and.callFake(function(){});
      GlucoseAmigo.controller.login('test');
      expect(GlucoseAmigo.controller.redirectTo).toHaveBeenCalledWith('test');
    });
  });
  describe('logout', function(){
    it("should call Ajax when you logout", function(){
      spyOn(Ajax, 'logout').and.callFake(function(){});
      GlucoseAmigo.controller.logout();
      expect(Ajax.logout).toHaveBeenCalled();
    });
  })
});
